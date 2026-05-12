DROP DATABASE IF EXISTS ER_Monitoring;
CREATE DATABASE ER_Monitoring;
USE ER_Monitoring;

CREATE TABLE Patients (
    Patient_ID CHAR(5) PRIMARY KEY,
    Full_Name VARCHAR(100) NOT NULL, 
    Admission_Time DATETIME DEFAULT CURRENT_TIMESTAMP -- Mặc định là thời gian hiện tại
);

CREATE TABLE Vitals_Logs (
    Log_ID INT AUTO_INCREMENT PRIMARY KEY, 
    Patient_ID CHAR(5) NOT NULL, 
    Heart_Rate INT NOT NULL,
    Blood_Pressure VARCHAR(20) NOT NULL,
    Record_Time DATETIME DEFAULT CURRENT_TIMESTAMP, 
    
    CONSTRAINT chk_heart_rate CHECK (Heart_Rate > 0),
    
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID) ON DELETE CASCADE
);

-- Tạo Composite Index tối ưu trên bảng dữ liệu lớn Vitals_Logs
CREATE INDEX idx_patient_record_time ON Vitals_Logs(Patient_ID, Record_Time);

INSERT INTO Patients (Patient_ID, Full_Name, Admission_Time) VALUES
('BN001', 'Nguyễn Văn A', '2026-05-12 08:00:00'),
('BN002', 'Trần Thị B', '2026-05-12 08:30:00'),
('BN003', 'Lê Hoàng C', '2026-05-12 09:00:00'); 

INSERT INTO Vitals_Logs (Patient_ID, Heart_Rate, Blood_Pressure, Record_Time) VALUES
('BN001', 75, '120/80', '2026-05-12 08:05:00'),
('BN001', 82, '122/81', '2026-05-12 09:15:00'), 
('BN002', 115, '130/85', '2026-05-12 08:35:00'),
('BN002', 135, '145/95', '2026-05-12 09:20:00'); 

CREATE VIEW ER_Dashboard_View AS
SELECT 
    p.Patient_ID,
    p.Full_Name,
    p.Admission_Time,
    COALESCE(CAST(v.Heart_Rate AS CHAR), 'Pending') AS Heart_Rate,
    COALESCE(v.Blood_Pressure, 'Pending') AS Blood_Pressure,
    COALESCE(CAST(v.Record_Time AS CHAR), 'Pending') AS Latest_Update,
    CASE 
        WHEN v.Heart_Rate IS NULL THEN 'Pending'
        WHEN v.Heart_Rate > 120 OR v.Heart_Rate < 50 THEN 'CRITICAL'
        ELSE 'STABLE'
    END AS Urgency_Level
FROM Patients p
-- Kỹ thuật Correlated Subquery trong ON Clause để chỉ bốc ra bản ghi mới nhất của mỗi người
LEFT JOIN Vitals_Logs v ON p.Patient_ID = v.Patient_ID 
  AND v.Record_Time = (
      SELECT MAX(v2.Record_Time) 
      FROM Vitals_Logs v2 
      WHERE v2.Patient_ID = p.Patient_ID
  );
  
  SELECT * FROM ER_Dashboard_View;
  
UPDATE ER_Dashboard_View 
SET Heart_Rate = '90' 
WHERE Patient_ID = 'BN001';

