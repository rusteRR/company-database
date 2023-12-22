create schema if not exists views;

set search_path = views, public;

create or replace view v_position as
    select *
    from position;

create or replace view v_office
    select o.office_code,
           o.name,
           o.city
    from office o
    where o.city = 'Moscow'

create or replace view v_meeting as
    select m.room_id,
           m.name,
           o.name
    from meeting_room m
    left join office o
        on m.office_cide = o.office_code;  

create or replace view v_employee as
    select e.employee_id,
           '***' as first_name,
           '***' as second_name,
           p.name
    from employee e
    left join position p
        on e.position_id = p.position_id;

create or replace view v_pass as 
    select p.pass_id,
           e.employee.first_name, 
           p.is_valid
    from pass p
    left join employee e
        on p.employee_id = e.employee_id;

create or replace view v_booking as 
    select r.room_id,
           e.employee.employee_id, 
           r.booking_date
    from room_booking r
    where date(r.booking_date) > "2023-12-20"
    left join employee e
        on r.employee_id = e.employee_id;

create or replace view v_entrance as 
    select entr.pass_id
    from entrance_time entr
    where is_entrance IS TRUE 

create or replace view v_versions as 
    select ver.employee_id,
           ver.position_id, 
           ver.salary
    from employee_versions ver
    where ver.salary > 100000


-- Статистика по каждой переговорке за день:
-- количество проведённых в ней встреч
-- суммарное количество часов за день, которое переговорка была занята

create or replace view meeting_room_load_statistic as
select o.office_code,
       mr.name,
       date(rb.start_booking)                                                                  as date,
       count(1)                                                                                as total_bookings,
       extract(epoch from sum(rb.end_booking::timestamp - rb.start_booking::timestamp)) / 3600 as busy_time_in_hours
from company_database.office o
         inner join company_database.meeting_room mr
                    on o.office_code = mr.office_code
         inner join company_database.room_booking rb
                    on mr.room_id = rb.room_id
group by o.office_code, date(rb.start_booking), mr.room_id
order by total_bookings desc, date;


-- Представление для анализа средней продолжительности
-- нахождения в офисе по каждому сотруднику в часах

create or replace view employee_load_statistic as
select e.employee_id,
       e.first_name,
       date(et.time),
       round(sum(case
                     when et.is_entrance
                         then -1
                     else 1
                     end * extract(epoch from et.time) / 3600), 1) as total_office_time_in_hours

from company_database.employee e
         inner join company_database.pass p
                    on e.employee_id = p.employee_id
         inner join company_database.entrance_time et
                    on p.pass_id = et.pass_id
group by e.employee_id, date(et.time);

-- Представление с изменением зарплаты у каждого сотрудника, у каждой версии указывается зарплата предыдущей версии
-- Сортируется по id сотрудника, затем по актуальности версии

create or replace view salary_modifications_history as
select employee_id,
       salary,
       lag(salary) over (partition by employee_id order by valid_from) as prev_salary,
       valid_from
from company_database.employee_versions
order by employee_id, valid_from;
