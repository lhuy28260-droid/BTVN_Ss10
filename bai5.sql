DROP DATABASE IF EXISTS RikkeiHospital_Central;
CREATE DATABASE RikkeiHospital_Central;
USE RikkeiHospital_Central;

CREATE TABLE Records_North (
    Record_ID INT PRIMARY KEY,
    Patient_Name VARCHAR(100) NOT NULL,
    Diagnosis TEXT NOT NULL,
    Record_Date DATE NOT NULL
);


CREATE TABLE Records_South (
    Record_ID INT PRIMARY KEY,
    Patient_Name VARCHAR(100) NOT NULL,
    Diagnosis TEXT NOT NULL,
    Record_Date DATE NOT NULL
);


INSERT INTO Records_North (Record_ID, Patient_Name, Diagnosis, Record_Date) 
VALUES (1, 'Nguyen Van A', 'Flu', '2026-04-28');

INSERT INTO Records_South (Record_ID, Patient_Name, Diagnosis, Record_Date) 
VALUES (1, 'Le Thi B', 'Cold', '2026-04-28');


CREATE VIEW National_Record_View AS
-- Lấy dữ liệu miền Bắc và gắn nhãn cột ảo 'North'
SELECT 
    Record_ID,
    Patient_Name,
    Diagnosis,
    Record_Date,
    'North' AS Branch_Name
FROM Records_North

UNION ALL

-- Hợp nhất dữ liệu miền Nam và gắn nhãn cột ảo 'South'
SELECT 
    Record_ID,
    Patient_Name,
    Diagnosis,
    Record_Date,
    'South' AS Branch_Name
FROM Records_South;

-- Truy vấn kiểm tra toàn bộ dữ liệu trên toàn quốc thông qua tầng ảo hóa View
SELECT * FROM National_Record_View;