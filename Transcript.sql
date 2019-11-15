delimiter $$
drop procedure if exists transcript $$
create procedure transcript(
	in sid char(20)
)
begin
select UoSCode,Year,Grade,Semester from student natural join transcript where id = sid order by Year;
end $$
delimiter ;