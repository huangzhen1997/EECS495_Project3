delimiter $$
drop procedure if exists course_detail $$
create procedure course_detail(
	in sid INT,
    in cid char(20)
)
begin
	
select o.UoSCode,u.UoSName,o.Year,o.Semester,f.Name, o.Enrollment,o.MaxEnrollment, t.Grade
 from unitofstudy as u
 inner join uosoffering as o
	on o.UoSCode=u.UoSCode
inner join faculty as f
	on o.InstructorId = f.id
inner join transcript as t
	on t.UoSCode = o.UoSCode and o.Semester = t.Semester and o.year = t.year
where t.Studid = sid and u.UoSCode = cid;
 
end $$
delimiter ;


-- call course_detail(5123,'COMP2007')


