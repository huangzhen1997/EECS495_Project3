delimiter $$
drop procedure if exists EnrollStudent $$
create procedure EnrollStudent (
	in sid int,
    in ccode char(20),
    in sem char(20),
    in y int
)
begin
IF NOT EXISTS (SELECT * 
				FROM
				requires r
				WHERE
				r.UoSCode = ccode
				AND r.PrereqUoSCode not in 
				(SELECT 
					UoSCode
				FROM
					transcript
				WHERE
					StudId = sid 
					AND grade IS NOT NULL
					AND grade != 'D'))
THEN
	IF NOT EXISTS (select * from transcript
    where StudId = sid and UoSCode = ccode and Semester = sem and Year = y)
    THEN
		INSERT INTO transcript value(sid,ccode,sem,y,null);
		UPDATE uosoffering 
		SET Enrollment = Enrollment + 1
		WHERE UoSCode = ccode AND Year = y AND Semester = sem;
    END IF;
ELSE
	SELECT PrereqUoSCode
	FROM requires
	WHERE UoSCode = ccode;
END IF;
end $$
delimiter ;