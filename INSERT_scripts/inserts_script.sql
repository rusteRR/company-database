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

insert into employee (position_id, first_name, second_name, birth_date, phone_number, salary, load) VALUES 
    (1, 'John', 'Doe', '1990-01-15', '+1234567890', 80000, 40),
    (2, 'Jane', 'Smith', '1985-05-20', '+9876543210', 60000, 30),
    (3, 'Mike', 'Johnson', '1995-08-10', '+1112233445', 70000, 35),
    (4, 'Emma', 'Smith', '1988-11-30', '+7531862940', 65000, 20),
    (5, 'Noah', 'Anderson', '1995-07-12', '+6420378159', 49000, 15),
    (6, 'Ava', 'Taylor', '1983-04-18', '+1956283470', 150000, 30),
    (7, 'Mason', 'Brown', '1992-12-05', '+4309675812', 100000, 18);
  
INSERT INTO employee_versions (employee_id, position_id, first_name, second_name, birth_date, phone_number, salary, load, valid_from, valid_to) VALUES 
    (1, 1, 'John', 'Doe', '1990-01-15', '+1234567890', 80000, 40, '2023-01-01', '9999-01-01'),
    (2, 2, 'Jane', 'Smith', '1985-05-20', '+9876543210', 60000, 30, '2023-01-01', '9999-01-01'),
    (3, 3, 'Mike', 'Johnson', '1995-08-10', '+1112233445', 70000, 35, '2023-01-01', '9999-01-01'),
    (4, 4, 'Emma', 'Smith', '1988-11-30', '+7531862940', 65000, 20, '2018-02-01', '2020-02-01'),
    (4, 6, 'Emma', 'Smith', '1988-11-30', '+7531862940', 65000, 20, '2020-02-02', '2023-04-29'),
    (4, 7, 'Emma', 'Smith', '1988-11-30', '+7531862940', 65000, 20, '2023-04-30', '9999-01-01'),
    (5, 6, 'Noah', 'Anderson', '1995-07-12', '+6420378159', 49000, 15, '2023-08-01', '9999-01-01'),
    (6, 5, 'Ava', 'Taylor', '1983-04-18', '+1956283470', 150000, 30, '2022-10-01', '2023-10-15'),
    (7, 6, 'Mason', 'Brown', '1992-12-05', '+4309675812', 100000, 18, '2019-05-01', '2021-01-10');

insert into pass (employee_id, is_valid) values
    (1, true),
    (2, true),
    (3, true),
    (4, true),
    (5, true),
    (6, false),
    (7, false);

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