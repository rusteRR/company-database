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