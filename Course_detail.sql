delimiter $$
drop procedure if exists course_detail $$
create procedure course_detail(
	in sid INT,
    in cid char(20)
)
begin
	select c.UoSCode,c.UoSName,r.Year,r.semester,r.Grade,o.Name,o.Enrollment,o.MaxEnrollment
    from (select us.UoSCode,us.UoSName from unitofstudy as us where us.UoSCode = cid) as c,
    (select Name,UoSCode,Year,Grade,Semester from student natural join transcript where id = sid order by Year) as r,
    (SELECT u.UoSCode,f.Name,u.Enrollment,u.MaxEnrollment,u.year,u.Semester FROM uosoffering as u,faculty as f where u.InstructorID = f.id and u.UoSCode = cid) as o
    where c.UoSCode = r.UoSCode and o.year = r.year and o.Semester = r.Semester;

end $$
delimiter ;


call course_detail(3213,'COMP2007')


