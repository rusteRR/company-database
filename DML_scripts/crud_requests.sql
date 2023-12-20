set search_path = company_database, public;

select employee_id, first_name, second_name, salary * (load::numeric(2) / 40)
from employee
where salary * (load::numeric(2) / 40) > 100000;

select position_id, avg(salary) as average_salary
from employee
group by position_id
order by average_salary, position_id;

select position_id, avg(salary) as average_salary
from employee
group by position_id
having avg(salary) > 100000
order by average_salary, position_id;

select employee_id, first_name, second_name, salary
from employee
order by salary desc;

insert into position(name) values
       ('Junior Developer'),
       ('QA'),
       ('Senior Developer');

update position
set name = 'Middle Developer'
where name = 'Developer';

select count(1) as total_workers
from employee
where is_active = true;

delete from office
where name = 'Branch Office 1';

