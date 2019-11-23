delimiter $$
drop procedure if exists EnrollStudent $$
create procedure EnrollStudent (
	in sid int,
    in ccode char(20),
    in sem char(20),
    in y int
)
begin

IF EXISTS (SELECT * 
			FROM
			requires r
			WHERE
			r.UoSCode = ccode
            AND r.EnforcedSince <= curdate()
			AND r.PrereqUoSCode not in 
			(SELECT 
				UoSCode
			FROM
				transcript
			WHERE
				StudId = sid 
				AND grade IS NOT NULL))
THEN
	SELECT PrereqUoSCode
	FROM requires
	WHERE UoSCode = ccode
    AND EnforcedSince <= curdate();
ELSEIF 	EXISTS (select * from transcript
		where StudId = sid and UoSCode = ccode and Semester = sem and Year = y)
THEN
	SELECT "You are already enrolled in this course";
ELSEIF ((select Enrollment from uosoffering WHERE UoSCode = ccode AND Year = y AND Semester = sem)
		>=
		(select MaxEnrollment from uosoffering WHERE UoSCode = ccode AND Year = y AND Semester = sem))
THEN
	SELECT "Maximum capacity reached";
ELSE
	START TRANSACTION;
	INSERT INTO transcript value(sid,ccode,sem,y,null);
	UPDATE uosoffering 
	SET Enrollment = Enrollment + 1
	WHERE UoSCode = ccode AND Year = y AND Semester = sem;
    COMMIT;
END IF;
end $$
delimiter ;