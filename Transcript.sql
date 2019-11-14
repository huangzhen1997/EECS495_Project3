delimiter $$
drop procedure if exists transcript $$
create procedure transcript(
	in sid char(20)
)
begin
select Name,UoSCode,Year,Grade from student natural join transcript where id = sid order by Year;
end $$
delimiter ;

