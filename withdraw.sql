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
    IF NOT EXISTS(select * from transcript where StudId = sid and UoSCode = cid and year = y_ear and Semester = s_emester)
    THEN
     SELECT "You are not currently enrolled in this class";
    ELSEIF (select grade from transcript where StudId = sid and UoSCode = cid and year = y_ear and Semester = s_emester) IS NOT NULL
    THEN
		SELECT "You cannot withdraw from a completed class";
	ELSEIF (curYear = y_ear AND curSem > s_emester) OR curYear > y_ear
    THEN
		SELECT "You cannot withdraw from a class that has already completed";
    ELSE
		
        START TRANSACTION;
        CREATE TABLE tmp as select 0 as flag;
		delete from transcript where Studid = sid and UoSCode = cid and year = y_ear and Semester = s_emester;
		update uosoffering set Enrollment = Enrollment -1 where UoScode = cid and year =y_ear and Semester = s_emester;
        if (select flag from tmp) = 1
        then
			drop table tmp;
			select "Drop successful, but enrollment has dropped below 50%";
		else
			drop table tmp;
        end if;
        COMMIT;
        
    END IF;
 
end $$
delimiter ;


