delimiter $$
drop procedure if exists student_menu $$
create procedure student_menu(
	in sid char(20),
	in y char(20),
	in sem char(20)
)
begin
select UoSCode from transcript where 
Studid = sid and Year = y and Semester = sem and grade is null;
end $$
delimiter ;

