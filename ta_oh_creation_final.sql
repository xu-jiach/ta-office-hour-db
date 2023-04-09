drop database if exists ta_oh;
create database if not exists ta_oh;
use ta_oh; 

create table college
(
	college_id int primary key not null unique auto_increment,
	college_name enum('Khoury College of Computer Sciences', 
		'Bouve College of Health Sciences', 
        'College of Science', 
        'College of Engineering', 
        'College of Arts, Media, and Design', 
        'College of Social Sciences and Humanities',
        'D\'Amore McKim School of Business') not null unique
);

create table course
(
	course_id int primary key not null unique auto_increment,
	course_num varchar(8) not null,
	course_name varchar(88) not null,
	section int,
	description varchar(255),
	college_id int not null, 
    TAoh_timeconflict boolean not null,
	constraint course_fk_college 
		foreign key(college_id) references college(college_id)
);

create table student
(
	student_id int primary key not null unique auto_increment,
	nuid int not null unique, 
	name varchar(45) not null,
	email varchar(100) not null unique,
	picture blob,
	college_id int,
	constraint student_fk_college 
		foreign key(college_id) references college(college_id)
);

create table enrollment
(
	student_id int not null,
	course_id int not null,
	constraint enrollment_fk_student 
		foreign key(student_id) references student(student_id), 
	constraint enrollment_fk_course 
		foreign key(course_id) references course(course_id)
);

create table ta
(
	ta_id int primary key not null unique auto_increment,
	student_id int not null,
	course_id int not null,
	constraint ta_fk_student 
		foreign key(student_id) references student(student_id),
	constraint ta_fk_course 
		foreign key(course_id) references course(course_id)
);


create table office_hour(
	ta_id int not null,
	day_of_week int not null,
	start_time time not null,
	end_time time not null,
    room varchar(45),
    zoomlink varchar(100),
	constraint officehour_fk_ta 
		foreign key(ta_id) references ta(ta_id)
);


