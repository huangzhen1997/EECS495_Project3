delimiter $$
drop trigger if exists enrollment_check $$
create trigger enrollment_check
after delete on uosoffering
for each row
begin
    if (new.MaxEnrollment > 2*new.Enrollment and new.MaxEnrollment <= 2* (new.Enrollment + 1))
    then SIGNAL sqlstate '45000' set message_text = 'The Enrollment number now is below 50 !!';
    end if;
end $$
delimiter ;
