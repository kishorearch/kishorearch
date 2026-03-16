create database Hotel_booking_system;
use Hotel_booking_system;

-- 1. Room Categories (Parent Table)
CREATE TABLE RoomTypes (
    room_type_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL);
INSERT INTO RoomTypes (category_name, base_price) VALUES
('Standard', 750.00),
('Deluxe', 1500.00),
('Suite', 3000.00),
('Penthouse', 9999.00);
    
    -- 2. Physical Rooms
CREATE TABLE Rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    room_type_id INT,
    status ENUM('Available', 'Occupied', 'Maintenance') DEFAULT 'Available',
    FOREIGN KEY (room_type_id) REFERENCES RoomTypes(room_type_id)
);

INSERT INTO Rooms (room_number, room_type_id, status) VALUES
('101', 1, 'Available'), ('102', 1, 'Available'), ('103', 1, 'Occupied'),('104', 1, 'Occupied'),
('201', 2, 'Available'), ('202', 2, 'Occupied'), ('203', 2, 'Maintenance'),
('301', 3, 'Available'), ('302', 3, 'Occupied'),('303', 3, 'Occupied'),
('401', 4, 'Available'), ('402', 4, 'Occupied'),;

-- 3. Guest Information
CREATE TABLE Guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20)
);

INSERT INTO Guests (first_name, last_name, email, phone) VALUES
('John', 'Doe', 'john.doe@email.com', '9090909090'),
('Jane', 'Smith', 'jane.smith@email.com', '7878787878'),
('Michael', 'Brown', 'mbrown@email.com', '9879879879'),
('Emily', 'Davis', 'emily.d@email.com', '8989898989'),
('Chris', 'Wilson', 'chris.w@email.com', '7878788989'),
('Sarah', 'Miller', 'sarah.m@email.com', '9876543219'),
('David', 'Taylor', 'dtaylor@email.com', '9123456789'),
('Laura', 'Anderson', 'laura.a@email.com', '9876544567'),
('James', 'Thomas', 'jthomas@email.com', '8765432189'),
('Olivia', 'Jackson', 'olivia.j@email.com', '8765432167'),
('Daniel', 'White', 'dwhite@email.com', '9876767689'),
('Sophia', 'Harris', 'sophia.h@email.com', '7345678901'),
('Matthew', 'Martin', 'mmartin@email.com', '9856565656'),
('Isabella', 'Thompson', 'isabella.t@email.com', '8798879887'),
('Ethan', 'Garcia', 'egarcia@email.com', '9876543434'),
('Mia', 'Martinez', 'mia.m@email.com', '9790974709'),
('Lucas', 'Robinson', 'lucas.r@email.com', '8765454545'),
('Ava', 'Clark', 'ava.c@email.com', '987678998');

-- 4. Bookings (The Connection Table)
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    room_id INT,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (guest_id) REFERENCES Guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

INSERT INTO Bookings (guest_id, room_id, check_in_date, check_out_date, total_amount) VALUES
(1, 1, '2024-01-01', '2024-01-05', 3000.00),
(2, 4, '2024-01-02', '2024-01-04', 3000.00),
(3, 7, '2024-01-05', '2024-01-10', 15000.00),
(4, 9, '2024-01-10', '2024-01-12', 19998.00),
(5, 2, '2024-01-12', '2024-01-15', 2250.00),
(6, 5, '2024-01-15', '2024-01-20', 7500.00),
(7, 8, '2024-01-18', '2024-01-22', 12000.00),
(8, 10, '2024-01-20', '2024-01-25', 49995.00),
(9, 3, '2024-01-22', '2024-01-24', 1500.00),
(10, 6, '2024-01-25', '2024-01-28', 4500.00),
(11, 1, '2024-02-01', '2024-02-03', 1500.00),
(12, 4, '2024-02-05', '2024-02-10', 9999.00),
(13, 7, '2024-02-10', '2024-02-12', 1500.00),
(14, 9, '2024-02-15', '2024-02-17', 19998.00),
(15, 2, '2024-02-20', '2024-02-22', 1500.00),
(16, 5, '2024-02-22', '2024-02-25', 29997.00),
(17, 8, '2024-02-25', '2024-02-28', 9000.00),
(18, 10, '2024-03-01', '2024-03-05', 39996.00);
truncate table bookings;
select * from bookings;
select * from guests;
select * from rooms;
select * from roomtypes;
SELECT 
    G.first_name, 
    R.room_number,
    DATEDIFF(B.check_out_date, B.check_in_date) AS nights_stayed,
    (DATEDIFF(B.check_out_date, B.check_in_date) * RT.base_price) AS calculated_total
FROM Bookings B
JOIN Guests G ON B.guest_id = G.guest_id
JOIN Rooms R ON B.room_id = R.room_id
JOIN RoomTypes RT ON R.room_type_id = RT.room_type_id;
-- how much income are made by room vice -- 
SELECT 
    RT.category_name, 
    COUNT(B.booking_id) AS total_bookings,
    SUM(B.total_amount) AS total_revenue
FROM RoomTypes RT
JOIN Rooms R ON RT.room_type_id = R.room_type_id
JOIN Bookings B ON R.room_id = B.room_id
GROUP BY RT.category_name
ORDER BY total_revenue DESC;

-- front desk--  
SELECT 
    G.first_name, 
    G.last_name, 
    R.room_number, 
    B.check_out_date
FROM Bookings B
JOIN Guests G ON B.guest_id = G.guest_id
JOIN Rooms R ON B.room_id = R.room_id
WHERE B.check_out_date = '2024-01-05';

-- THE VIP GUEST FINDER--  
SELECT 
    G.first_name, 
    G.last_name, 
    G.email, 
    SUM(B.total_amount) AS lifetime_value
FROM Guests G
JOIN Bookings B ON G.guest_id = B.guest_id
GROUP BY G.guest_id
HAVING lifetime_value > 25000
ORDER BY lifetime_value DESC;

SELECT G.guest_id, G.first_name, SUM(B.total_amount) AS total_spent
FROM Guests G
JOIN Bookings B ON G.guest_id = B.guest_id
GROUP BY G.guest_id, G.first_name;

SELECT R.room_number, RT.category_name, RT.base_price
FROM Rooms R
JOIN RoomTypes RT ON R.room_type_id = RT.room_type_id
WHERE R.status = 'Available';

SELECT RT.category_name, COUNT(B.booking_id) AS booking_count
FROM RoomTypes RT
JOIN Rooms R ON RT.room_type_id = R.room_type_id
JOIN Bookings B ON R.room_id = B.room_id
GROUP BY RT.category_name
ORDER BY booking_count DESC;

SELECT 
    RT.category_name,
    COUNT(R.room_id) AS total_rooms,
    SUM(CASE WHEN R.status = 'Available' THEN 1 ELSE 0 END) AS rooms_available,
    SUM(CASE WHEN R.status = 'Occupied' THEN 1 ELSE 0 END) AS rooms_occupied,
    ROUND((SUM(CASE WHEN R.status = 'Occupied' THEN 1 ELSE 0 END) / COUNT(R.room_id)) * 100, 2) AS occupancy_percentage
FROM RoomTypes RT
JOIN Rooms R ON RT.room_type_id = R.room_type_id
GROUP BY RT.category_name;