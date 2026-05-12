DROP DATABASE IF EXISTS ClinicManagement;
CREATE DATABASE ClinicManagement ;
USE ClinicManagement;

CREATE TABLE Patients (
    Patient_ID INT PRIMARY KEY AUTO_INCREMENT,
    Full_Name VARCHAR(100),
    Phone VARCHAR(15),
    Age INT,
    Address VARCHAR(255)
);

DELIMITER //
CREATE PROCEDURE SeedPatients()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    -- Tối ưu hóa tốc độ ghi bằng Transaction
    START TRANSACTION;
    WHILE i <= 500000 DO
        INSERT INTO Patients (Full_Name, Phone, Age, Address)
        VALUES (
            CONCAT('Patient ', i), 
            CONCAT('090', LPAD(i, 7, '0')), -- Tạo số điện thoại duy nhất, độ dài đều nhau
            FLOOR(RAND()*100), 
            'Ho Chi Minh City'
        );
        SET i = i + 1;
    END WHILE;
    COMMIT;
END //
DELIMITER ;

-- 3. Gọi Procedure để kích hoạt nạp dữ liệu
CALL SeedPatients();

EXPLAIN SELECT * FROM Patients WHERE Phone = '0900025000';

CREATE INDEX idx_phone ON Patients(Phone);

-- Khi đã có Index (Index Lookup)
EXPLAIN SELECT * FROM Patients WHERE Phone = '0900025000';

-- Tạo Stored Procedure kiểm thử tốc độ ghi 1.000 dòng
DELIMITER //
CREATE PROCEDURE TestInsertSpeed()
BEGIN
    DECLARE i INT DEFAULT 1;
    START TRANSACTION;
    WHILE i <= 1000 DO
        INSERT INTO Patients (Full_Name, Phone, Age, Address)
        VALUES (CONCAT('New Patient ', i), CONCAT('099', LPAD(i, 7, '0')), 30, 'Hanoi');
        SET i = i + 1;
    END WHILE;
    COMMIT;
END //
DELIMITER ;

CALL TestInsertSpeed();