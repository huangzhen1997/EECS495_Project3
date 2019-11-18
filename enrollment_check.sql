drop table if exists flag_tag;
create table flag_tag(tag varchar(5) primary key, val integer, UoSCode char(8), Semester char(2), Year int(11));
insert into flag_tag values('flag',0,'','',0);
delimiter $$
drop trigger if exists enrollment_check $$
create trigger enrollment_check
after update on uosoffering
for each row
begin
    if (new.MaxEnrollment > 2*new.Enrollment and new.MaxEnrollment<= 2* (new.Enrollment+1))
    then update flag_tag set val = 1,UoSCode = new.UoSCode,Semester = new.Semester,Year = new.Year where tag = 'flag';
    elseif (new.MaxEnrollment <= 2*new.Enrollment)
    then update flag_tag set val = 0 where tag = 'flag';
    end if;
end $$
delimiter ;

select * from flag_tag;