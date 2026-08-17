CREATE DATABASE skytrack_db;
USE skytrack_db;
CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    flight_number VARCHAR(20) UNIQUE NOT NULL,
    source VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    departure_date DATE NOT NULL,
    ticket_price DECIMAL(10,2) CHECK (ticket_price > 0)
);
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    passenger_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    booking_date DATE NOT NULL,

    FOREIGN KEY (passenger_id)
        REFERENCES Passengers(passenger_id),

    FOREIGN KEY (flight_id)
        REFERENCES Flights(flight_id)
);
INSERT INTO Flights
(flight_id, flight_number, source, destination, departure_date, ticket_price)
VALUES
(1, 'SK101', 'Hyderabad', 'Delhi', '2026-08-10', 5500.00),
(2, 'SK102', 'Hyderabad', 'Mumbai', '2026-08-11', 4500.00),
(3, 'SK103', 'Delhi', 'Bangalore', '2026-08-12', 6000.00),
(4, 'SK104', 'Mumbai', 'Chennai', '2026-08-13', 5000.00),
(5, 'SK105', 'Bangalore', 'Delhi', '2026-08-14', 6200.00),
(6, 'SK106', 'Chennai', 'Hyderabad', '2026-08-15', 4800.00),
(7, 'SK107', 'Hyderabad', 'Bangalore', '2026-08-16', 5200.00),
(8, 'SK108', 'Delhi', 'Mumbai', '2026-08-17', 5700.00),
(9, 'SK109', 'Mumbai', 'Delhi', '2026-08-18', 5300.00),
(10, 'SK110', 'Chennai', 'Bangalore', '2026-08-19', 4900.00);
SELECT * FROM Flights;
INSERT INTO Passengers
(passenger_id, passenger_name, email)
VALUES
(101, 'Rahul Sharma', 'rahul@gmail.com'),
(102, 'Priya Reddy', 'priya@gmail.com'),
(103, 'Arjun Kumar', 'arjun@gmail.com'),
(104, 'Sneha Rao', 'sneha@gmail.com'),
(105, 'Vikram Singh', 'vikram@gmail.com'),
(106, 'Ananya Patel', 'ananya@gmail.com'),
(107, 'Kiran Das', 'kiran@gmail.com'),
(108, 'Meena Joseph', 'meena@gmail.com'),
(109, 'Rohit Verma', 'rohit@gmail.com'),
(110, 'Divya Nair', 'divya@gmail.com');

SELECT * FROM Passengers;
INSERT INTO Bookings
(booking_id, passenger_id, flight_id, booking_date)
VALUES
(1, 101, 1, '2026-08-01'),
(2, 102, 2, '2026-08-01'),
(3, 103, 3, '2026-08-02'),
(4, 104, 4, '2026-08-02'),
(5, 105, 5, '2026-08-03'),
(6, 106, 6, '2026-08-03'),
(7, 107, 7, '2026-08-04'),
(8, 108, 8, '2026-08-04'),
(9, 109, 9, '2026-08-05'),
(10, 110, 10, '2026-08-05');


-- Display Bookings

SELECT * FROM Bookings;

SELECT
    p.passenger_name AS Passenger_Name,
    f.flight_number AS Flight_Number,
    f.source AS Source,
    f.destination AS Destination
FROM Bookings b
INNER JOIN Passengers p
    ON b.passenger_id = p.passenger_id
INNER JOIN Flights f
    ON b.flight_id = f.flight_id;
    SELECT
    destination,
    COUNT(flight_id) AS Total_Flights
FROM Flights
GROUP BY destination;
CREATE TABLE Flight_History (
    history_id INT PRIMARY KEY,
    flight_id INT,
    flight_number VARCHAR(20),
    action VARCHAR(50),
    action_date DATE,

    FOREIGN KEY (flight_id)
        REFERENCES Flights(flight_id)
);

START TRANSACTION;


-- Add new flight

INSERT INTO Flights
(flight_id, flight_number, source, destination, departure_date, ticket_price)
VALUES
(11, 'SK111', 'Hyderabad', 'Kolkata', '2026-08-20', 5800.00);


-- Record the new flight in history

INSERT INTO Flight_History
(history_id, flight_id, flight_number, action, action_date)
VALUES
(1, 11, 'SK111', 'NEW FLIGHT ADDED', CURDATE());


-- Save both operations

COMMIT;

SELECT * FROM Flight_History;
CREATE INDEX idx_flight_number
ON Flights(flight_number);
SELECT *
FROM Flights
WHERE flight_number = 'SK105';
SELECT * FROM Flights;

SELECT * FROM Passengers;

SELECT * FROM Bookings;

SELECT * FROM Flight_History;
