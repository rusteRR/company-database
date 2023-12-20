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


----------------------------------------------------------------------------------

-- Посчитать по каждому офису кол-во человек в указанную дату
-- Ожидаемый результат:  office_name ,кол-во человек

select et.office_code, count(distinct et.pass_id)
from entrance_time et right join office o on et.office_code = o.office_code
where et.is_entrance and et.time::date = '2023-01-10'::date
group by et.pass_id, et.office_code;