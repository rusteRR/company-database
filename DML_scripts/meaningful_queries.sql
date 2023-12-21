set search_path = company_database, public;

-- Найти свободные переговорки в указанном офисе на указанный период времени
-- Ожидаемый результат: id, имя переговорок, не имеющих брони в указанный промежуток в нужном офисе

select mr.room_id, mr.name
from meeting_room mr
         inner join office o on mr.office_code = o.office_code
where o.name = 'Branch Office 2'

except

select mr.room_id, mr.name
from meeting_room mr
         inner join room_booking rb
                    on mr.room_id = rb.room_id
where ('2023-01-10 15:00'::timestamp < rb.end_booking and rb.end_booking <= '2023-01-10 16:00'::timestamp)
   or ('2023-01-10 15:00'::timestamp <= rb.start_booking and rb.start_booking < '2023-01-10 16:00'::timestamp)
   or (rb.start_booking <= '2023-01-10 15:00'::timestamp and '2023-01-10 16:00'::timestamp <= rb.end_booking);

----------------------------------------------------------------------------------------

-- Посчитать по каждому офису кол-во человек в указанную дату (считаем, что офисы не работают по ночам)
-- Ожидаемый результат:  office_name ,кол-во человек

select ocpi.office_code, coalesce(count(distinct ocpi.time), 0)
from (select o.office_code,
             et.pass_id,
             case
                 when et.time::date = '2023-01-10'::date then et.time::date
                 end as time
      from entrance_time et
               right join office o on et.office_code = o.office_code) as ocpi
group by office_code, pass_id;

----------------------------------------------------------------------------------------

-- Получить историю изменений зарплаты сотрудников
-- Ожидаемый результат: id сотрудника, зарплата, дата начала, дата конца
--                      отсортировано по id-сотрудника, внутри по дате начала должности
-- (есть проблема, что если сотрудник уволился, потом вернулся на ту же должность и зп, то период увольнения будет посчитан, как период получения зп)
-- табличка скорее техническая и сама по себе не сильно много информации содержит, но по ней можно чего нить интересного достать (возможно имеет смысл пихнуть во вью)

select employee_id, position_id, salary, min(valid_from) as start_date, max(valid_to) as end_date
from employee_versions
group by employee_id, salary, position_id
order by employee_id, start_date;

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
order by name, rank