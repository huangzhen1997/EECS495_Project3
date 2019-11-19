delimiter $$
drop procedure if exists transcript $$
create procedure transcript(
	in sid char(20)
)
begin
select UoSCode,Year,Grade,Semester from student as s natural join transcript as t where s.id = t.StudId and s.id = sid order by Year;
end $$
delimiter ;

-- call transcript(5123);