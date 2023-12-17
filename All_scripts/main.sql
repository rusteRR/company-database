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

INSERT INTO position (name) VALUES
    ('Manager'),
    ('Developer'),
    ('Designer'),
    ('Analyst'),
    ('HR'),
    ('Engineer'),
    ('Director');

INSERT INTO office (office_code, name, city) VALUES
    ('OFC001', 'Headquarters', 'New York'),
    ('OFC002', 'Branch Office 1', 'San Francisco'),
    ('OFC003', 'Branch Office 2', 'London'),
    ('OFC004', 'Branch Office 3', 'Moscow'),
    ('OFC005', 'Branch Office 4', 'Dubai'),
    ('OFC006', 'Branch Office 5', 'Paris'),
    ('OFC007', 'Branch Office 6', 'Tokyo');

INSERT INTO meeting_room (name, office_code) VALUES
    ('MR.Conference.01.001', 'OFC001'),
    ('MR.MeetingRoom.02.002', 'OFC002'),
    ('MR.MeetingRoom.03.003', 'OFC003'),
    ('MR.MeetingRoom.04.004', 'OFC004'),
    ('MR.MeetingRoom.05.005', 'OFC005'),
    ('MR.MeetingRoom.06.006', 'OFC006'),
    ('MR.MeetingRoom.07.007', 'OFC007');

INSERT INTO employee (position_id, first_name, second_name, birth_date, phone_number, salary, load, valid_from, valid_to) VALUES
    (1, 'Ethan', 'Johnson', '1990-05-15', '+8742951036', 70000, 20, '2023-01-01', '9999-01-01'),
    (2, 'Olivia', 'Miller', '1985-09-23', '+5168902743', 80000, 30, '2022-12-01', '2024-06-30'),
    (3, 'Liam', 'Davis', '1993-02-08', '+2094875631', 90000, 25, '2022-11-01', '2025-05-30'),
    (4, 'Emma', 'Smith', '1988-11-30', '+7531862940', 65000, 20, '2023-02-01', '2023-12-31'),
    (5, 'Noah', 'Anderson', '1995-07-12', '+6420378159', 49000, 15, '2023-08-01', '9999-01-01'),
    (6, 'Ava', 'Taylor', '1983-04-18', '+1956283470', 150000, 30, '2022-10-01', '2024-01-30'),
    (7, 'Mason', 'Brown', '1992-12-05', '+4309675812', 100000, 18, '2023-05-01', '2024-12-31'),
    (2, 'Sophia', 'White', '1987-06-20', '+3619584027', 88000, 9, '2022-12-15', '2024-09-30');

INSERT INTO pass (employee_id, is_valid) VALUES
    (1, true),
    (2, true),
    (3, true),
    (4, true),
    (5, true),
    (6, true),
    (7, true),
    (8, true);

INSERT INTO office_x_pass (office_code, pass_id) VALUES
    ('OFC001', 1),
    ('OFC002', 2),
    ('OFC003', 3);
    ('OFC004', 4),
    ('OFC005', 5),
    ('OFC006', 6),
    ('OFC007', 7);

INSERT INTO room_booking (room_id, employee_id, booking_date, start_booking, end_booking) VALUES
    (1, 1, '2023-01-10', '2023-01-10 15:00', '2023-01-10 15:30'),
    (2, 2, '2023-01-12', '2023-01-12 11:00', '2023-01-12 12:00');
    (3, 3, '2023-01-15', '2023-01-15 10:00', '2023-01-15 12:00'),
    (3, 3, '2023-01-16', '2023-01-16 10:00', '2023-01-16 12:00');
    (5, 4, '2023-01-20', '2023-01-20 13:00', '2023-01-20 15:00'),
    (7, 6, '2023-01-21', '2023-01-21 14:00', '2023-01-21 16:00');

INSERT INTO entrance_time (pass_id, office_code, time, is_entrance) VALUES
    (1, 'OFC001', '2023-01-10 14:55', true),
    (2, 'OFC002', '2023-01-12 10:55', true),
    (3, 'OFC003', '2023-01-15 09:55', true),
    (3, 'OFC003', '2023-01-16 09:55', true),
    (5, 'OFC005', '2023-01-20 08:55', true),
    (7, 'OFC007', '2023-02-15 12:55', true);

