delimiter $$
drop procedure if exists withdraw $$
create procedure withdraw(
	in sid INT,
    in cid char(20),
    in y_ear INT,
    in s_emester char(5)
)
begin
	
    delete from transcript where Studid = sid and UoSCode = cid and year = y_ear and Semester = s_emester;
    update uosoffering set Enrollment = Enrollment -1 where UoScode = cid and year =y_ear and Semester = s_emester;
 
end $$
delimiter ;


