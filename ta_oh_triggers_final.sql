use ta_oh;
-- trigger that prevent TA insert his/her hour to an timeslot that will cause time conflict

drop trigger if exists TA_timeconflict_oneself;
delimiter //

create trigger TA_timeconflict_oneself
	before insert 
    on office_hour for each row
begin 
	declare checkflag_conflict int;
    declare message varchar(255);
    declare course_num_var varchar(10);
    DECLARE student_name_var varchar(45);
    set checkflag_conflict = 0;
    
    select count(*) into checkflag_conflict from office_hour 
    left join ta using (Ta_id)
	left join student using (student_id)
	where ((start_time <= new.start_time and end_time >=new.end_time) or (new.start_time <= end_time) or (new.end_time >= start_time))
    and name = (select name from student join ta using (student_id) where ta_id = new.TA_id ) and day_of_week = new.day_of_week;
	
    select course_num into course_num_var from office_hour 
    left join ta using (Ta_id)
	left join student using (student_id)
    left join course using (course_id)
	where ((start_time <= new.start_time and end_time >=new.end_time) or (new.start_time <= end_time) or (new.end_time >= start_time))
    and name = (select name from student join ta using (student_id) where ta_id = new.TA_id ) and day_of_week = new.day_of_week;
	
    select name into student_name_var from student
    join ta using(student_id) 
    where ta_id = new.ta_id;
    
	if checkflag_conflict > 0 then
		select concat(student_name_var,' had this time was scheduled already for ', course_num_var) into message;
		signal sqlstate 'HY000' set message_text = message;
	end if;
end //

delimiter ;

-- demo case. Assiging Tony Stark to 10-12 Wed for EECE 2160
insert into office_hour(ta_id, day_of_week, start_time, end_time, zoomlink) values
(9,4,'10:00','12:00','23232');


-- for courses like Database Design, TAs are not allowed to have overlap in each other's office hour
-- This trigger prevent such cases from happening.
drop trigger if exists TA_timeconflict_others;
delimiter //

create trigger TA_timeconflict_others
	before insert 
    on office_hour for each row
begin 
	declare checkflag_conflict int;
    declare message2 varchar(255);
    declare student_name_var varchar(45);
    declare course_num_var varchar(10);
    set checkflag_conflict = 0;
    
    select count(*) into checkflag_conflict from office_hour 
    left join ta using (ta_id) 
	left join course using (course_id)
	where course_num = (select course_num from course 
						left join ta using (course_id) 
                        left join office_hour using (ta_id)
                        where ta_id = new.ta_id limit 1) 
	and TAoh_timeconflict = 1
	and ((start_time <= new.start_time and end_time >=new.end_time) or (new.start_time <= end_time) 
    or (new.end_time >= start_time)) and day_of_week = new.day_of_week;
	
    select name into student_name_var 
    from office_hour 
    left join ta using (ta_id) 
	left join course using (course_id)
    left join student using (student_id)
	where course_num = (select course_num from course 
						left join ta using (course_id) 
                        where ta_id = new.ta_id ) 
	and TAoh_timeconflict = 1
	and ((start_time <= new.start_time and end_time >=new.end_time) or (new.start_time <= end_time) 
    or (new.end_time >= start_time)) and day_of_week = new.day_of_week;
    
    select course_num into course_num_var from course join ta using (course_id) where ta_id = new.ta_id;
	if checkflag_conflict > 0 then
		select concat("this time was scheduled already for ", student_name_var, "."  ,
        course_num_var," doesn't allow overlap in office hour with others") into message2;
		signal sqlstate 'HY000' set message_text = message2;
	end if;
end //

delimiter ;

-- Test run for the trigger TA_timeconflict_others
insert into office_hour(ta_id, day_of_week, start_time, end_time, zoomlink) values
(5,5,'18:00','19:00','23232');




-- Test run as an example run including multiple triggers

-- record Peter Parker as TA for discrete
insert into TA(Ta_id,student_id, course_id) values
(15,15,1); 
-- the following line should fail since Peter has that time scheduled for Database design already
insert into office_hour(ta_id, day_of_week, start_time, end_time, room) values
(15,2,'18:00','20:00','NI217');  
-- record Peter Parker's Office Hour for Discrete at Wed 10-12. Should be good to go.
-- Though Tony Stark holds this timeslot for Discrete already, it's a course that's allowing overlap. so it should be good to go
insert into office_hour(ta_id, day_of_week, start_time, end_time, room) values
(15,4,'10:00','12:00','ISEC 102'); 




-- trigger that prevent a TA to record time over 10 hours per week
drop trigger if exists totalhourlimit;
delimiter //
create trigger totalhourlimit 
	before insert 
    on office_hour for each row
begin 
	declare duration_var float;
    declare name_var varchar(45);
	declare message3 varchar(255);
    
    select name into name_var from student 
    join ta using (student_id) 
    where ta_id = new.ta_id;
    
    select sum(time_to_sec(end_time) - time_to_sec(start_time))/3600 into duration_var from office_hour 
    join ta using (ta_id)
    join student using (student_id)
	where name = name_var;
    
	if (round((time_to_sec(new.end_time)-time_to_sec(new.start_time))/3600 + duration_var,0) > 10 )then
		select concat(name_var, " cannot have more than 10 hours of office hour per week") into message3;
		signal sqlstate 'HY000' set message_text = message3;
        end if;
end//

delimiter ;


-- Adding 8 hours to Tony Stark's Schedule. Should fail since Tony Stark had 6 hours already.
insert into office_hour(ta_id, day_of_week, start_time, end_time, room) values
(1,2,'12:00','20:00','NI217');


-- trigger that prevent student to be TA that they are enrolling in
drop trigger if exists TA_enrollment_conflict;
delimiter //
create trigger TA_enrollment_conflict
	before insert 
    on ta for each row
begin 
	declare message varchar(255); 
    declare course_num_var varchar(10);
    declare student_name_var varchar(55);
    select name into student_name_var from student where student_id = new.student_id;
    select course_num into course_num_var from course where course_id = new.course_id;
	if (new.course_id in (select course_id from enrollment where student_id = new.student_id)) then 
		select concat( student_name_var, ' cannot be the TA of ',course_num_var, ' until he complete this course') into message;
		signal sqlstate 'HY000' set message_text = message;
	end if;
end //

delimiter ;

-- Example that should fail
-- James Bond is taking GE1502 so he cannot be the TA of GE1502
insert into ta(student_id, course_id) values
(14,8);

-- TRIGGERs that remove all related infomration from the table once a student was removed from the student table
drop trigger if exists removeStudent;
delimiter //
create trigger removestudent
	before delete
    on student for each row
begin 
	declare student_id_var int;
    select student_id into student_id_var from student where name = old.name and nuid = old.nuid;
    delete from office_hour where ta_id in (select ta_id from ta where student_id =student_id_var);
    delete from enrollment where student_id = student_id_var;
	delete from ta where student_id = student_id_var;
    
    
end //
delimiter ;


-- demo cases. Add a new student Bruce Banner
-- Assiging Bruce Banner as TA for discrete and a student for CS3200
insert into student (nuid, name, email) values ('001451227','Bruce Banner','b.bruce@northeastern.edu');
insert into ta(course_id, student_id) (select 1, student_id from student where name = 'Bruce Banner');
insert into enrollment(course_id, student_id) (select 2, student_id from student where name = 'Bruce Banner');

-- Test run. Now Bruce Banner should be recorded 
select * from enrollment where student_id in (select student_id from student where name = 'Bruce Banner');
select * from ta where student_id in (select student_id from student where name = 'Bruce Banner');

-- delete Bruce Banner away from the student table
delete from student where nuid = '001451227' and name = 'Bruce Banner';

-- Check again. Now Bruce Banner's enrollment and TA should all be removed 
select * from enrollment where student_id in (select student_id from student where name = 'Bruce Banner');
select * from ta where student_id in (select student_id from student where name = 'Bruce Banner');