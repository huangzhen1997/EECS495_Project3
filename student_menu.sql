delimiter $$
drop procedure if exists student_menu $$
create procedure student_menu(
	in sid int,
	in y int,
	in sem char(5)
)
begin
select t1.UoSCode,t2.UoSName from transcript as t1 inner join unitofstudy as t2 
on t1.UoSCode = t2.UoSCode
where t1.Studid = sid and t1.Year = y and t1.Semester = sem and t1.grade is null;
end $$
delimiter ;

call student_menu(5123,2019,'Q2')


