delimiter $$
drop procedure if exists update_person $$
create procedure update_person(
	in sid INT,
    in pwd varchar(20),
    in addrs varchar(50)
)
begin
	
    update student set Password = pwd, Address = addrs where Id = sid;
 
end $$
delimiter ;

call update_person(3213,'lunch','Cronulla');
00:55:31	call update_person(3213,'lunch','Cronulla')	1 row(s) affected, 2 warning(s): 3719 'utf8' is currently an alias for the character set UTF8MB3, but will be an alias for UTF8MB4 in a future release. Please consider using UTF8MB4 in order to be unambiguous. 3719 'utf8' is currently an alias for the character set UTF8MB3, but will be an alias for UTF8MB4 in a future release. Please consider using UTF8MB4 in order to be unambiguous.	0.0011 sec
