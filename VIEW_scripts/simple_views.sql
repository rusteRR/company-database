create schema if not exists views;

set search_path = views, public;

create or replace view v_position as
    select *
    from company_database.position;

create or replace view v_office as
    select o.office_code,
           o.name,
           o.city
    from company_database.office o
    where o.city = 'New York';

create or replace view v_meeting as
    select m.room_id,
           m.name as meeting_room_name,
           o.name as office_name
    from company_database.meeting_room m
    left join company_database.office o
        on m.office_code = o.office_code;

create or replace view v_employee as
    select e.employee_id,
           left(e.first_name, 1) || '***' || right(e.first_name, 1) as first_name,
           left(e.second_name, 1) || '***' || right(e.second_name, 1) as second_name,
           p.name
    from company_database.employee e
    left join company_database.position p
        on e.position_id = p.position_id;

create or replace view v_pass as
    select p.pass_id,
           e.first_name,
           p.is_valid
    from company_database.pass p
    left join company_database.employee e
        on p.employee_id = e.employee_id;

create or replace view v_booking as
    select r.room_id,
           e.employee_id,
           r.booking_date
    from company_database.room_booking r
    left join company_database.employee e
        on r.employee_id = e.employee_id
    where date(r.booking_date) > '2023-12-20';


create or replace view v_entrance as
    select entr.pass_id
    from company_database.entrance_time entr
    where is_entrance is true;

create or replace view v_versions as
    select ver.employee_id,
           ver.position_id,
           ver.salary
    from company_database.employee_versions ver
    where ver.salary > 100000;
