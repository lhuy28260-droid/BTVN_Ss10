DROP DATABASE IF EXISTS HospitalPharmacy;
CREATE DATABASE HospitalPharmacy ;
USE HospitalPharmacy;

CREATE TABLE Pharmacy_Inventory (
    Inventory_ID INT AUTO_INCREMENT PRIMARY KEY,
    Drug_Name VARCHAR(255) NOT NULL,
    Batch_Number VARCHAR(50) NOT NULL,
    Expiry_Date DATE NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity >= 0)
);

CREATE INDEX idx_composite_drug_expiry ON Pharmacy_Inventory(Drug_Name, Expiry_Date);

EXPLAIN SELECT * FROM Pharmacy_Inventory 
WHERE Drug_Name = 'Paracetamol 500mg' 
  AND Expiry_Date <= '2026-06-30';
  
SELECT * FROM Pharmacy_Inventory WHERE Drug_Name LIKE '%Paracetamol%';


ALTER TABLE Pharmacy_Inventory ADD FULLTEXT idx_fulltext_drug_name(Drug_Name);


SELECT * FROM Pharmacy_Inventory 
WHERE MATCH(Drug_Name) AGAINST('Paracetamol' IN BOOLEAN MODE)
  AND Expiry_Date <= '2026-06-30';

