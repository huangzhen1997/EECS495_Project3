delimiter $$
drop trigger if exists enrollment_check $$
create trigger enrollment_check
after update on uosoffering
for each row
begin
    if (new.MaxEnrollment > 2*new.Enrollment and new.MaxEnrollment <= 2* (new.Enrollment + 1))
    then 
    update tmp set flag = 1;
    end if;
end $$
delimiter ;