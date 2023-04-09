use ta_oh;

-- insert for college 
insert into college(college_name) value ('Khoury College of Computer Sciences');
insert into college(college_name) value ('College of Science');
insert into college(college_name) value ('College of Engineering');
insert into college(college_name) value ('College of Arts, Media, and Design');
insert into college(college_name) value ('Bouve College of Health Sciences');
insert into college(college_name) value ('College of Social Sciences and Humanities');
insert into college(college_name) value ("D'Amore McKim School of Business");


-- insert for course (each college should have at least for each)
-- total amount 9 courses
insert into course(course_num, course_name, description, college_id,Taoh_timeconflict) values 
('CS1800','Discrete Structures',"the introduction of basic math including probability, countings and logic",1,0);
insert into course(course_num, course_name, section, description, college_id,Taoh_timeconflict) values
('CS3200','Database Desgin',3,'Studies the design of a database for use in a relational database management system',1,1),
('MATH3081','Probability and Statistics',2,'A course that focuses on probability theory', 2,1),
('GE1502','Cornerstone of Engineering 2',8,'Continues GE 1501 using a project-based approach under a unifying theme',3,1),
('EECE2160','Embedded Desgin and Enabling Robotics',1,'Offers students a hands-on experience developing a remote-controlled robotic arm using an embedded systems platform',3,1),
('COMM1101','Introduction to Communication Studies',1,'Introductory to communication studies',4,1),
('BUSN1101','Introduction to Business',1,'Introductory to Business',7,1),
('PHTH1260','The American Health System',1,'Introduces the organization and dynamics of the healthcare system and the role of consumers',5,1),
('ECON1115','Macroeconomic Principle',1,'Introduces macroeconomic analysis ',6,1);


-- insert students (each college should have one student for each at least)
insert into student (nuid, name, email,college_id) values 
(001112222,'Tony Stark','stark.to@northeastern.edu',1),
(001562245,'Tony Anderson','anderson.to@northeastern.edu',1),
(001451367,'Nathan Drake','drake.nat@northeasern.edu',2),
(001853628,'Oliver Williams','williams.o@northeastern.edu',2),
(001233323,'Chris Zhang','zhang.ch@northeastern.edu',3),
(001923214,'Chris Redfield','redfield.ch@northeastern.edu',3),
(001287772,'Claire Redfield','redfield.cl@northeastern.edu',4),
(001142355,'Eason Hunt','hunt.eas@northeastern.edu',4),
(001462331,'Daniel Wiseman','wiseman.dan@northeastern.edu',6),
(001286623,'Ada Wong','wong.ada@northastern.edu',6),
(001228897,'Joseph Aoun','thegreataoun@northeastern.edu',5),
(001195624,'Virginia Potts','potts.vir@northeastern.edu',5),
(001457822,'Alan Smith','smith.ala@northeastern,edu',7),
(001992384,'James Bond','bond.J@northeastern.edu',7),
(001818112,'Peter Parker','parker.pe@northeastern.edu',1);


insert into TA (course_id, student_id) values
(1,1),(1,2),(1,4),
(2,5),(2,15),
(4,6),(4,5),
(3,3),
(5,1),
(6,7),
(7,13),
(8,12),
(9,9),
(9,10);


insert into enrollment (student_id, course_id) values 
(8,1),(8,2),(8,3),(8,6),
(11,1),(11,5),(11,9),(11,7),
(1,2),(1,3),(1,9),
(14,4),(14,8);



insert into office_hour(ta_id,day_of_week,start_time, end_time,room) values
(1,4,'10:00','12:00','ISEC 102'),
(1,6,'18:00','20:00','ISEC 102'),
(2,5,'16:00','18:00','RI 233'),
(2,2,'16:00','18:00','RI 233'),
(4,5,'16:00','20:00','NI 217'),
(5,2,'18:00','20:00','NI 217'),
(6,6,'14:00','17:00','SN 303'),
(7,2,'14:00','17:00','SN 303'),
(10,4,'13:00','15:00','HS 204'),
(11,5,'16:00','17:00','CG 231'),
(13,2,'16:00','18:00','RB 204');


insert into office_hour(ta_id, day_of_week, start_time, end_time, zoomlink) values
(3,1,'15:00','17:00','northeastern.zoom.us/78781233'),
(3,3,'10:00','13:00','northeastern.zoom.us/78781233'),
(5,6,'17:00','19:00','northeastern.zoom.us/28475612'),
(8,4,'15:00','17:00','northeastern.zoom.us/94891212'),
(9,3,'16:00','18:00','northeastern.zoom.us/28323231'),
(10,3,'17:00','18:00','northeastern.zoom.us/63547118'),
(12,6,'10:00','12:00','northeastern.zoom/us/37474711'),
(13,4,'13:00','15:00','northeastern.zoom.us/33231612'),
(14,6,'16:00','18:00','northeastern.zoom.us/87534135'),
(14,3,'19:00','20:00','northeastern.zoom.us/87534135');