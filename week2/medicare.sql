CREATE DATABASE medicare_db;

USE medicare_db;
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    consultation_fee DECIMAL(10,2) CHECK (consultation_fee > 0)
);
INSERT INTO Doctors
(doctor_id, doctor_name, specialization, consultation_fee)
VALUES
(1, 'Dr. Ravi Kumar', 'Cardiologist', 800),
(2, 'Dr. Priya Sharma', 'Neurologist', 1000),
(3, 'Dr. Arjun Reddy', 'Orthopedic', 700),
(4, 'Dr. Sneha Rao', 'Pediatrician', 600),
(5, 'Dr. Kiran Patel', 'Dermatologist', 750),
(6, 'Dr. Anjali Singh', 'General Physician', 500),
(7, 'Dr. Vikram Das', 'ENT Specialist', 650),
(8, 'Dr. Meena Kapoor', 'Gynecologist', 900),
(9, 'Dr. Suresh Babu', 'Oncologist', 1200),
(10, 'Dr. Neha Verma', 'Ophthalmologist', 700);
SELECT * FROM Doctors;
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);
INSERT INTO Patients
(patient_id, patient_name, email)
VALUES
(101, 'Rahul Sharma', 'rahul@gmail.com'),
(102, 'Ananya Reddy', 'ananya@gmail.com'),
(103, 'Vijay Kumar', 'vijay@gmail.com'),
(104, 'Sneha Patel', 'sneha@gmail.com'),
(105, 'Karthik Rao', 'karthik@gmail.com'),
(106, 'Divya Singh', 'divya@gmail.com'),
(107, 'Arun Das', 'arun@gmail.com'),
(108, 'Pooja Verma', 'pooja@gmail.com'),
(109, 'Manoj Babu', 'manoj@gmail.com'),
(110, 'Keerthi Nair', 'keerthi@gmail.com');
SELECT * FROM Patients;
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    doctor_id INT,
    patient_id INT,
    appointment_date DATE NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);
INSERT INTO Appointments
(appointment_id, doctor_id, patient_id, appointment_date)
VALUES
(1, 1, 101, '2026-08-01'),
(2, 2, 102, '2026-08-02'),
(3, 3, 103, '2026-08-03'),
(4, 4, 104, '2026-08-04'),
(5, 5, 105, '2026-08-05'),
(6, 6, 106, '2026-08-06'),
(7, 7, 107, '2026-08-07'),
(8, 8, 108, '2026-08-08'),
(9, 9, 109, '2026-08-09'),
(10, 10, 110, '2026-08-10');
SELECT * FROM Appointments;
SELECT
    p.patient_name,
    d.doctor_name,
    d.specialization,
    a.appointment_date
FROM Appointments a
INNER JOIN Patients p
    ON a.patient_id = p.patient_id
INNER JOIN Doctors d
    ON a.doctor_id = d.doctor_id;
    SELECT
    specialization,
    COUNT(doctor_id) AS total_doctors
FROM Doctors
GROUP BY specialization;
CREATE TABLE Doctor_History (
    history_id INT PRIMARY KEY,
    doctor_id INT,
    doctor_name VARCHAR(100),
    registration_date DATE,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);
START TRANSACTION;
INSERT INTO Doctors
(doctor_id, doctor_name, specialization, consultation_fee)
VALUES
(11, 'Dr. Amit Joshi', 'Dermatologist', 850);
INSERT INTO Doctor_History
(history_id, doctor_id, doctor_name, registration_date)
VALUES
(1, 11, 'Dr. Amit Joshi', CURDATE());
COMMIT;
START TRANSACTION;

INSERT INTO Doctors
(doctor_id, doctor_name, specialization, consultation_fee)
VALUES
(11, 'Dr. Amit Joshi', 'Dermatologist', 850);

INSERT INTO Doctor_History
(history_id, doctor_id, doctor_name, registration_date)
VALUES
(1, 11, 'Dr. Amit Joshi', CURDATE());

COMMIT;

SELECT * FROM Doctor_History;
CREATE INDEX idx_doctor_specialization
ON Doctors(specialization);
SELECT *
FROM Doctors
WHERE specialization = 'Dermatologist';
SELECT * FROM Doctors;
SELECT * FROM Patients;
SELECT * FROM Appointments;
SELECT * FROM Doctor_History;