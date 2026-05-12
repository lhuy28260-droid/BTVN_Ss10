DROP DATABASE IF EXISTS HospitalFinancials;
CREATE DATABASE HospitalFinancials ;
USE HospitalFinancials;


CREATE TABLE Departments (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(100) NOT NULL
);


CREATE TABLE Patients (
    Patient_ID INT PRIMARY KEY,
    Full_Name VARCHAR(100) NOT NULL,
    Identity_Card VARCHAR(20) NOT NULL UNIQUE
);


CREATE TABLE Invoices (
    Invoice_ID INT PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Dept_ID INT NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL CHECK (Amount >= 0),
    FOREIGN KEY (Dept_ID) REFERENCES Departments(Dept_ID),
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID)
);


INSERT INTO Departments VALUES (1, 'Nội'), (2, 'Ngoại');

INSERT INTO Patients VALUES 
(1, 'Bệnh Nhân A', '123456789'),
(2, 'Bệnh Nhân B', '987654321'),
(3, 'Bệnh Nhân C', '456789123');

INSERT INTO Invoices VALUES 
(101, 1, 1, 500.00), 
(102, 2, 1, 300.00), 
(103, 3, 2, 1000.00);

CREATE VIEW Department_Revenue_View AS
SELECT 
    d.Dept_Name AS `Tên Khoa`,
    COUNT(DISTINCT i.Patient_ID) AS `Tổng Số Bệnh Nhân`,
    IFNULL(SUM(i.Amount), 0) AS `Tổng Doanh Thu`
FROM Departments d
LEFT JOIN Invoices i ON d.Dept_ID = i.Dept_ID
LEFT JOIN Patients p ON i.Patient_ID = p.Patient_ID
GROUP BY d.Dept_ID, d.Dept_Name;

SELECT * FROM Department_Revenue_View;

UPDATE Department_Revenue_View 
SET `Tổng Doanh Thu` = 1500.00 
WHERE `Tên Khoa` = 'Nội';

