delimiter $$
drop procedure if exists update_person $$
create procedure update_person(
	in sid INT,
    in pwd varchar(20),
    in addrs varchar(50)
)
begin
	START TRANSACTION;
    update student set Password = pwd, Address = addrs where Id = sid;
	COMMIT;
end $$
delimiter ;

call update_person(3213,'lunch','Cronulla');
