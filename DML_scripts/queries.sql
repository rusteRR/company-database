set search_path = company_database, public;

-- Найти свободные переговорки в указанном офисе на указанный период времени
-- Ожидаемый результат: id, имя переговорок, не имеющих брони в указанный промежуток в нужном офисе

select mr.room_id, mr.name
from meeting_room mr
         inner join office o on mr.office_code = o.office_code
where o.name = 'Times Square Office'

except

select mr.room_id, mr.name
from meeting_room mr
         inner join room_booking rb
                    on mr.room_id = rb.room_id
where ('2023-12-21 13:00'::timestamp < rb.end_booking and rb.end_booking <= '2023-12-21 14:00'::timestamp)
   or ('2023-12-21 13:00'::timestamp <= rb.start_booking and rb.start_booking < '2023-12-21 14:00'::timestamp)
   or (rb.start_booking <= '2023-12-21 13:00'::timestamp and '2023-12-21 14:00'::timestamp <= rb.end_booking);

----------------------------------------------------------------------------------------

-- Посчитать по каждому офису кол-во человек в указанную дату (считаем, что офисы не работают по ночам)
-- Ожидаемый результат:  office_name ,кол-во человек

select o.office_code, coalesce(count(distinct ocpi.pass_id), 0) as total_employees
from (select distinct on(et.pass_id) o.office_code,
             et.pass_id
      from entrance_time et
               right join office o on et.office_code = o.office_code
      where et.time::date = '2023-01-12'::date
      group by o.office_code, et.pass_id, et.time) ocpi right join office o on ocpi.office_code = o.office_code
group by o.office_code;

-- ;

----------------------------------------------------------------------------------------

-- Найти топ-3 сотрудников по зарплате (текущей) на каждой должности
-- Ожидаемый результат:
--                      для каждой должности: id сотрудника, имя, фамилия, зп, ранк

select *
from (select p.name,
             e.employee_id,
             e.first_name,
             e.second_name,
             e.salary,
             rank() over (partition by e.position_id order by e.salary desc) as rank
      from employee e
               inner join position p on e.position_id = p.position_id) r
where rank < 4
order by name, rank;

----------------------------------------------------------------------------------------

-- Найти сотрудников, которые "недорабатывают" за месяц, исходя из посещений офиса
-- Ожидаемый результат: все, кроме сотрудника с id 5. У него маленькая нагрузка, поэтому он отработал нужное время

select e.employee_id,
       e.first_name,
       e.second_name,
       date_trunc('month', et.time)
from employee e
         inner join company_database.pass p
                    on e.employee_id = p.employee_id
         inner join company_database.entrance_time et
                    on p.pass_id = et.pass_id
group by e.employee_id, date_trunc('month', et.time)
having sum(case
               when et.is_entrance
                   then -1
               else 1
               end * extract(epoch from et.time) / 3600) < e.load * 4
order by employee_id;

----------------------------------------------------------------------------------------

-- Получить список переговорных комнат, который забронировал сотрудник, совещания в которых
-- ещё не начались
-- Ожидаемый результат: MR.NY02.03.01, до 2023-12-25 13:00

select mr.name
from employee e
    inner join company_database.room_booking rb
        on e.employee_id = rb.employee_id
    inner join company_database.meeting_room mr
        on mr.room_id = rb.room_id
where e.employee_id = 2 and rb.start_booking >= now()::timestamp;

----------------------------------------------------------------------------------------

-- Получить историю изменений зарплаты сотрудников
-- Ожидаемый результат: id сотрудника, зарплата, дата начала, дата конца
--                      отсортировано по id-сотрудника, внутри по дате начала должности
-- (есть проблема, что если сотрудник уволился, потом вернулся на ту же должность и зп, то период увольнения будет посчитан, как период получения зп)
-- табличка скорее техническая и сама по себе не сильно много информации содержит, но по ней можно чего нить интересного достать

select employee_id,
       position_id,
       salary,
       min(valid_from) as start_date,
       max(valid_to) as end_date
from employee_versions
group by employee_id, salary, position_id
order by employee_id, start_date;