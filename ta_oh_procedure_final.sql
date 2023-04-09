-- final project procedure 
use ta_oh;
-- procedure to show all the office hour for that student 
drop procedure if exists AllOfficeHours_thatStudent;

delimiter //

-- show all the office hour for the course that the student is enrolling in
-- student name is the insert
create procedure AllOfficeHours_thatStudent(
in student_name_param varchar(55)
)
begin 

select course_num, TAinformation.name as 'TA_Name', case day_of_week 
when '1' then 'Sunday'
when '2' then 'Monday'
when '3' then 'Tuesday'
when '4' then 'Wednesday'
when '5' then 'Thursday'
when '6' then 'Friday'
when '7' then 'Saturday'
end as 'day',
	start_time, end_time, ifnull(room,'No room assigned') as room_information, ifnull(zoomlink,"No link available") as 'Link'
    from student
left join enrollment using (student_id)
left join course using (course_id)
left join TA using (course_id)
left join office_hour using (TA_id)
left join student as TAinformation on TAinformation.student_id = TA.student_id
where student.name = student_name_param
 order by course_num, day_of_week, start_time, end_time;

end //

delimiter ; 


call AllOfficeHours_thatStudent('Joseph Aoun');
call AllOfficeHours_thatStudent('James Bond');
call AllOfficeHours_thatStudent('Eason Hunt');
call AllOfficeHours_thatStudent('Tony Stark');
-- procedure to show a specfic office hour of a specfic TA for that student 

drop procedure if exists OfficeHour_exactTA_forthatCourse;
delimiter //
create procedure OfficeHour_exactTA_forthatCourse(
	in course_param varchar(10),
    in TA_param varchar(20)
)
begin 
 
select course_num, TAstudent.name as 'TA_Name', case day_of_week 
when '1' then 'Sunday'
when '2' then 'Monday'
when '3' then 'Tuesday'
when '4' then 'Wednesday'
when '5' then 'Thursday'
when '6' then 'Friday'
when '7' then 'Saturday'
end as 'day',
	start_time, end_time, ifnull(room,'No room assigned') as room_information, ifnull(zoomlink,"No link available") as 'Link'
    from student 
    left join ta using (student_id)
    left join student as TAstudent on TAstudent.student_id = ta.student_id
    left join course using (course_id)
    left join office_hour using (ta_id)
	where course_num = course_param and TAstudent.name = TA_param
    order by course_num, day_of_week, start_time, end_time;

end //

delimiter ; 

call OfficeHour_exactTA_forthatCourse('CS1800','Tony Stark');
call OfficeHour_exactTA_forthatCourse('EECE2160','Tony Stark');

-- procedure to show all office hour for that specfic course 
-- course is the insert
drop procedure if exists OfficeHour_course;
delimiter //
create procedure OfficeHour_course(IN course_param varchar(45))
begin 
select name as student_name, 
case day_of_week 
when '1' then 'Sunday'
when '2' then 'Monday'
when '3' then 'Tuesday'
when '4' then 'Wednesday'
when '5' then 'Thursday'
when '6' then 'Friday'
when '7' then 'Saturday'
end as 'day', 
start_time, end_time, 
ifnull(room,'No room assigned') as room, 
ifnull(zoomlink,"No link available") as zoomlink 
from course 
left join TA using (course_id) 
left join student using (student_id)
left join office_hour using (Ta_id)
where course_num = course_param
 order by course_num, day_of_week, start_time, end_time;

end // 
)
delimiter ;
 
 call OfficeHour_course('CS1800'); 
 call OfficeHour_course('CS3200');
 call OfficeHour_course('EECE2160');



-- procedure to show the student the closest office hour for the courses he would go for
-- the course is the insert
drop procedure if exists nextofficehour_forthatCourse;
delimiter //
create procedure nextofficehour_forthatCourse(
course_param varchar(10)
)
begin 
declare dow_now int;
declare time_now time;
declare checkflag int;
declare checkflag2 int; 
SET checkflag = 0;
set checkflag2 = 0;

select count(*) into checkflag from office_hour 
left join ta using (ta_id)
left join course using (course_id)
where course_num = course_param
 and day_of_week =  dayofweek(now()) and end_time > time(now());
 
 select count(*) into checkflag2 from office_hour 
left join ta using (ta_id)
left join course using (course_id)
where course_num = course_param
 and day_of_week >  dayofweek(now()); 
 
if (checkflag > 0) then 
	select name as 'TA name',case day_of_week 
when '1' then 'Sunday'
when '2' then 'Monday'
when '3' then 'Tuesday'
when '4' then 'Wednesday'
when '5' then 'Thursday'
when '6' then 'Friday'
when '7' then 'Saturday'
end as 'day',
start_time, end_time,ifnull(room,'No room assigned') as room, 
ifnull(zoomlink,"No link available") as zoomlink from office_hour
	left join ta using (ta_id)
	left join student using (student_id)
	left join course using (course_id)
	where course_num = course_param and dayofweek(now()) = day_of_week and time(now()) <= end_time
	order by day_of_week, start_time, end_time
    limit 1;
elseif  (checkflag2 > 0 ) then 
	select name as 'TA name', case day_of_week 
when '1' then 'Sunday'
when '2' then 'Monday'
when '3' then 'Tuesday'
when '4' then 'Wednesday'
when '5' then 'Thursday'
when '6' then 'Friday'
when '7' then 'Saturday'
end as 'day',
	start_time, end_time, 
    ifnull(room,'No room assigned') as room, 
	ifnull(zoomlink,"No link available") as zoomlink 
    from office_hour
	left join ta using (ta_id)
	left join student using (student_id)
	left join course using (course_id)
	where course_num = course_param and day_of_week > dayofweek(now()) 
	order by day_of_week, start_time, end_time
    limit 1;
else 
	select name as 'TA name', case day_of_week 
when '1' then 'Sunday'
when '2' then 'Monday'
when '3' then 'Tuesday'
when '4' then 'Wednesday'
when '5' then 'Thursday'
when '6' then 'Friday'
when '7' then 'Saturday'
end as 'day',
	start_time, end_time,
    ifnull(room,'No room assigned') as room, 
	ifnull(zoomlink,"No link available") as zoomlink 
    from office_hour
	left join ta using (ta_id)
	left join student using (student_id)
	left join course using (course_id)
	where course_num = course_param and day_of_week < dayofweek(now()) 
	order by day_of_week, start_time, end_time
    limit 1;
end if;


    
end //
delimiter ;

-- demo calling the next office hour
CALL nextofficehour_forthatCourse('GE1502');
call nextofficehour_forthatCourse('CS1800');
call nextofficehour_forthatCourse('CS3200');
call nextofficehour_forthatCourse('COMM1101');
call nextofficehour_forthatCourse('ECON1115');


