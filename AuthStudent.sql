DROP PROCEDURE IF EXISTS AuthStudent;

delimiter //
CREATE PROCEDURE AuthStudent (IN username VARCHAR(20), IN passw VARCHAR(20))
BEGIN
	SELECT * FROM student
    WHERE Name = username AND Password = passw;
END //
delimiter ;

-- CALL AuthStudent("Harry Jenkins","butterflY");

