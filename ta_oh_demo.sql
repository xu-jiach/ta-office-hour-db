-- demo file 
-- 1.single table query
-- show all the student
use ta_oh;
select * from student;
select * from office_hour;
select * from TA;
select * from course;

-- 2.Procedures. 
-- Display used procedure

-- procedure 1: show all the office hour that student was enrolling in 
-- NUID and Student Name (NUID was insert all purpose to avoid name reptition)
-- order by course num, day, start time, end time
call AllOfficeHours_thatStudent('Joseph Aoun');
call AllOfficeHours_thatStudent('James Bond');
call AllOfficeHours_thatStudent('Eason Hunt');
call AllOfficeHours_thatStudent('Tony Stark');

-- procedure 2: procedure to show a specfic office hour of a specfic TA for that student 
-- order by course num, day, start time, end time

call OfficeHour_exactTA_forthatCourse('CS1800','Tony Stark');
call OfficeHour_exactTA_forthatCourse('EECE2160','Tony Stark');
call OfficeHour_exactTA_forthatCourse('GE1502','Chris Zhang');

-- procedure 3: procedure to show all office hour for that course
-- order by course num, day, start time, end time

 call OfficeHour_course('CS1800'); 
 call OfficeHour_course('CS3200');
 call OfficeHour_course('EECE2160');
 
-- procedure 4: show the student the closest office hour for the courses he would go for
-- the course is the insert

CALL nextofficehour_forthatCourse('GE1502');
call nextofficehour_forthatCourse('CS1800');
call nextofficehour_forthatCourse('CS3200');
call nextofficehour_forthatCourse('COMM1101');
call nextofficehour_forthatCourse('ECON1115');

-- 3.Triggers 

-- Trigger 1: TA having time conflict with himself
-- Stop it when insert and notice which course he is conflicting with
-- Assiging Tony Stark to 10-12 Wed for EECE2160 while he has this time hold for CS1800 already.
insert into office_hour(ta_id, day_of_week, start_time, end_time, zoomlink) values
(9,4,'10:00','12:00','23232');

-- Trigger 2: TA having time conflict with other student while this course doesn't allow overlapp in office hour
-- stop it before insert and notice who he is conflicting with 
-- Assigning Peter Parker to Thursday 6pm to 7pm while the other TA in CS3200 hold this time period already
insert into office_hour(ta_id, day_of_week, start_time, end_time, zoomlink) values
(5,5,'18:00','19:00','23232');

-- Trigger 3: Prevent TA having more than 10 hour of office hour
-- Tony stark is having 6 hour already. so it shall have error
insert into office_hour(ta_id, day_of_week, start_time, end_time, room) values
(1,2,'12:00','20:00','NI217');

-- Trigger 4: Prevent student to be a TA that he is still studying 
-- James bond is taking GE1502 right now. 
insert into ta(student_id, course_id) values
(14,4);


-- Trigger 5: remove a student and remove all information related to that student from this table
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

-- An demo case for multiple triggers
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

