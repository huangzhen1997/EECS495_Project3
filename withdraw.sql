delimiter $$
drop procedure if exists withdraw $$
create procedure withdraw(
	in sid INT,
    in cid char(20),
    in y_ear INT,
    in s_emester char(5)
)
begin
	DECLARE curYear int;
    DECLARE curSem char(5);
    SET curYear = year(curdate());
    IF month(curdate()) BETWEEN 7 and 12
	THEN
		SET curSem = "Q2";
	ELSE
		SET curSem = "Q1";
	END IF;
    IF (select grade from transcript where UoSCode = cid and year = y_ear and Semester = s_emester) IS NOT NULL
    THEN
		SELECT "You cannot withdraw from a completed class";
	ELSEIF (curYear = y_ear AND curSem > s_emester) OR curYear > y_ear
    THEN
		SELECT "You cannot withdraw from a class from previous year";
    ELSE
		delete from transcript where Studid = sid and UoSCode = cid and year = y_ear and Semester = s_emester;
		update uosoffering set Enrollment = Enrollment -1 where UoScode = cid and year =y_ear and Semester = s_emester;
        show warnings;
    END IF;
 
end $$
delimiter ;


