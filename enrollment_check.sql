delimiter $$
drop trigger if exists enrollment_check $$
create trigger enrollment_check
after update on uosoffering
for each row
begin
    if (new.Enrollment < (new.MaxEnrollment / 2))
    then
    SIGNAL sqlstate '01000' set message_text = 'The Enrollment number now is below half of maximum !!', MYSQL_ERRNO = 01000;
    end if;
end $$
delimiter ;
