create schema company_database;

set search_path = company_database, public;

create table if not exists position (
    position_id serial primary key,
    name        text
);

create table if not exists office (
    office_code text primary key check(regexp_match(office_code, '[a-zA-Z0-9]+') notnull),
    name        text,
    city        text
);

create table if not exists meeting_room (
    room_id     serial primary key,
    name        text check(regexp_match(name, 'MR.[a-zA-Z0-9]+.[0-9]{1,2}.[0-9]+') notnull),
    office_code text references office(office_code) on update cascade on delete cascade
);

create table if not exists employee (
    employee_id  serial primary key,
    position_id  int references position(position_id) on delete set null,
    first_name   text,
    second_name  text,
    birth_date   date,
    phone_number text check(regexp_match(phone_number, '^[+]?[(]?[0-9]{3}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4,6}$') notnull),
    salary       int check (salary > 0),
    load         int check (load between 0 and 40),
    valid_from   date,
    valid_to     date
);

create table if not exists pass (
    pass_id     serial primary key,
    employee_id int references employee(employee_id) on delete cascade,
    is_valid    bool
);

create table if not exists office_x_pass (
    office_code text references office(office_code) on update cascade on delete cascade,
    pass_id     int references pass(pass_id) on delete cascade,
    primary key (office_code, pass_id)
);

create table if not exists room_booking (
    room_id       int references meeting_room(room_id) on delete cascade,
    employee_id   int references employee(employee_id) on delete cascade,
    booking_date  date,
    start_booking date,
    end_booking   date,
    primary key (room_id, employee_id, booking_date)
);

create table if not exists entrance_time (
    pass_id     int references pass(pass_id) on delete cascade,
    office_code text references office(office_code) on update cascade on delete cascade,
    time        date,
    is_entrance bool,
    primary key (pass_id, office_code, time)
)


// Task 4 - заполнение таблиц

insert into position (name) values
    ('Manager'),
    ('Developer'),
    ('Designer'),
    ('Analyst'),
    ('HR'),
    ('Engineer'),
    ('Director');

insert into office (office_code, name, city) values
    ('NYOFC001', 'Headquarters', 'New York'),
    ('SFOFC002', 'Branch Office 1', 'San Francisco'),
    ('LonOFC003', 'Branch Office 2', 'London'),
    ('MosOFC004', 'Branch Office 3', 'Moscow'),
    ('DubOFC005', 'Branch Office 4', 'Dubai'),
    ('ParOFC006', 'Branch Office 5', 'Paris'),
    ('TokOFC007', 'Branch Office 6', 'Tokyo');

insert into meeting_room (name, office_code) values
    ('MR.NYOFC001.01.001', 'NYOFC001'),
    ('MR.SFOFC002.02.002', 'SFOFC002'),
    ('MR.LonOFC003.03.003', 'LonOFC003'),
    ('MR.MosOFC004.04.004', 'MosOFC004'),
    ('MR.DubOFC005.05.005', 'DubOFC005'),
    ('MR.ParOFC006.06.006', 'ParOFC006'),
    ('MR.TokOFC007.07.007', 'TokOFC007');

insert into employee (position_id, first_name, second_name, birth_date, phone_number, salary, load, valid_from, valid_to) values
    (1, 'Ethan', 'Johnson', '1990-05-15', '+8742951036', 70000, 20, '2023-01-01', '9999-01-01'),
    (2, 'Olivia', 'Miller', '1985-09-23', '+5168902743', 80000, 30, '2022-12-01', '9999-01-01'),
    (3, 'Liam', 'Davis', '1993-02-08', '+2094875631', 90000, 25, '2021-11-01', '2022-11-01'),
    (3, 'Liam', 'Davis', '1993-02-08', '+2094875631', 90000, 25, '2022-11-02', '9999-01-01'),
    (4, 'Emma', 'Smith', '1988-11-30', '+7531862940', 65000, 20, '2018-02-01', '2020-02-01'),
    (4, 'Emma', 'Smith', '1988-11-30', '+7531862940', 65000, 20, '2020-02-02', '2023-04-29'),
    (4, 'Emma', 'Smith', '1988-11-30', '+7531862940', 65000, 20, '2023-04-30', '9999-01-01'),
    (5, 'Noah', 'Anderson', '1995-07-12', '+6420378159', 49000, 15, '2023-08-01', '9999-01-01'),
    (6, 'Ava', 'Taylor', '1983-04-18', '+1956283470', 150000, 30, '2022-10-01', '2023-10-15'),
    (7, 'Mason', 'Brown', '1992-12-05', '+4309675812', 100000, 18, '2019-05-01', '2021-01-10');

insert into pass (employee_id, is_valid) values
    (1, true),
    (2, true),
    (3, true),
    (4, true),
    (5, true),
    (6, true),
    (7, true),
    (8, true),
    (9, false),
    (10, false);

insert into office_x_pass (office_code, pass_id) values
    ('NYOFC001', 1),
    ('SFOFC002', 2),
    ('LonOFC003', 3),
    ('MosOFC004', 4),
    ('DubOFC005', 5),
    ('ParOFC006', 6),
    ('TokOFC007', 7);

insert into room_booking (room_id, employee_id, booking_date, start_booking, end_booking) values
    (1, 1, '2023-01-10', '2023-01-10 15:00', '2023-01-10 15:30'),
    (2, 2, '2023-01-12', '2023-01-12 11:00', '2023-01-12 12:00'),
    (3, 3, '2023-01-15', '2023-01-15 10:00', '2023-01-15 12:00'),
    (3, 3, '2023-01-16', '2023-01-16 10:00', '2023-01-16 12:00'),
    (5, 4, '2023-01-20', '2023-01-20 13:00', '2023-01-20 15:00'),
    (7, 6, '2023-01-21', '2023-01-21 14:00', '2023-01-21 16:00');

insert into entrance_time (pass_id, office_code, time, is_entrance) values
    (1, 'NYOFC001', '2023-01-10 14:55', true),
    (1, 'NYOFC001', '2023-01-10 15:30', false),
    (2, 'SFOFC002', '2023-01-12 10:55', true),
    (2, 'SFOFC002', '2023-01-12 12:00', false),
    (3, 'LonOFC003', '2023-01-15 09:55', true),
    (3, 'LonOFC003', '2023-01-15 12:00', false),
    (5, 'DubOFC005', '2023-01-16 09:55', true),
    (5, 'DubOFC005', '2023-01-16 12:00', false);

