drop procedure if exists ShowOfferings;
delimiter $$
create procedure ShowOfferings()
begin
DECLARE curYear int;
DECLARE curSem char(20);
DECLARE nextYear int;
DECLARE nextSem char(20);

SET curYear = year(curdate());
IF month(curdate()) BETWEEN 7 and 12
THEN
	SET curSem = "Q2";
    SET nextYear = curYear + 1;
    SET nextSem = "Q1";
ELSE
	SET curSem = "Q1";
    SET nextYear = curYear;
    set nextSem = "Q2";
END IF;

SELECT UoSCode, Semester, Year, Textbook, Enrollment, MaxEnrollment
FROM uosoffering
WHERE
(Semester = curSem AND Year = curYear)
OR
(Semester = nextSem AND Year = nextYear);


end $$
delimiter ;

CALL ShowOfferings();
