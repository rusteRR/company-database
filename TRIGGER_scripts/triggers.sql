set search_path = company_database, public;

create or replace function prevent_concurrent_booking()
returns trigger as $$
begin
    if exists (
        select 1
        from company_database.room_booking rb
        where rb.room_id = new.room_id
          and rb.booking_date = new.booking_date
          and (
            (new.start_booking between rb.start_booking and rb.end_booking)
            or (new.end_booking between rb.start_booking and rb.end_booking)
            or (new.start_booking <= rb.start_booking and new.end_booking >= rb.end_booking)
          )
    ) then
        raise exception 'Concurrent booking is not allowed for room % and date %',
            new.room_id, new.booking_date;
    end if;
    return new;
end;
$$ language plpgsql;

create trigger prevent_concurrent_booking_trigger
before insert or update
on company_database.room_booking
for each row
execute function prevent_concurrent_booking();

create or replace function before_update_employee_is_active()
returns trigger as $$
begin
    if new.is_active is distinct from old.is_active and new.is_active = false then
        update pass
        set is_valid = false
        where employee_id = old.employee_id;
    end if;
    return new;
end;
$$ language plpgsql;

create trigger before_update_employee_is_active_trigger
before update on company_database.employee
for each row
execute function before_update_employee_is_active();
