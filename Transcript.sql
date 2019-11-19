delimiter $$
drop procedure if exists transcript $$
create procedure transcript(
	in sid int
)
begin
	select UoSCode,Year,Grade,Semester
	from
		student
	inner join
		transcript
	where
		student.Id = transcript.StudId AND student.Id = sid order by Year;
end $$
delimiter ;

-- call transcript(5123);
