delimiter $$
drop trigger if exists enrollment_check $$
create trigger enrollment_check
after update on uosoffering
for each row
begin
    if (new.Enrollment < (old.MaxEnrollment / 2))
    then
		if exists (select * from information_schema.tables where table_name = "tmp")
        then
			update tmp set flag = 1;
        end if;
    end if;
end $$
delimiter ;
