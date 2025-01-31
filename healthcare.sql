CREATE DATABASE IF NOT EXISTS HealthcareManagementDB;
USE HealthcareManagementDB;

-- Patients Table
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Email VARCHAR(100),
    PhoneNumber VARCHAR(20)
);

-- Doctors Table
CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Specialty VARCHAR(100),
    Email VARCHAR(100)
);

-- Offices Table (One-to-One with Doctor)
CREATE TABLE Offices (
    OfficeID INT AUTO_INCREMENT PRIMARY KEY,
    Location VARCHAR(100),
    Phone VARCHAR(20),
    DoctorID INT UNIQUE,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Appointments Table (One-to-Many with Doctor and Many-to-One with Patient)
CREATE TABLE Appointments (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    AppointmentDate DATE,
    Notes VARCHAR(255),
    PatientID INT,
    DoctorID INT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Doctor_Patient Table (Many-to-Many between Doctor and Patient)
CREATE TABLE Doctor_Patient (
    DoctorID INT,
    PatientID INT,
    PRIMARY KEY (DoctorID, PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Insert Data into Patients Table
INSERT INTO Patients (FirstName, LastName, DateOfBirth, Email, PhoneNumber) VALUES
('John', 'Doe', '1980-01-15', 'johndoe@example.com', '555-1234'),
('Jane', 'Smith', '1990-02-20', 'janesmith@example.com', '555-5678'),
('Jim', 'Brown', '1975-03-10', 'jimbrown@example.com', '555-8765');

-- Insert Data into Doctors Table
INSERT INTO Doctors (FirstName, LastName, Specialty, Email) VALUES
('Alice', 'Johnson', 'Cardiology', 'alicejohnson@example.com'),
('Bob', 'Williams', 'Neurology', 'bobwilliams@example.com'),
('Charlie', 'Davis', 'Pediatrics', 'charliedavis@example.com');

-- Insert Data into Offices Table
INSERT INTO Offices (Location, Phone, DoctorID) VALUES
('101 Heart St.', '555-1230', 1),
('202 Brain Blvd.', '555-5670', 2),
('303 Child Way', '555-8760', 3);

-- Insert Data into Appointments Table
INSERT INTO Appointments (AppointmentDate, Notes, PatientID, DoctorID) VALUES
('2024-09-01', 'Routine check-up', 1, 1),
('2024-09-02', 'Neurology consultation', 2, 2),
('2024-09-03', 'Pediatrics consultation', 3, 3);

-- Insert Data into Doctor_Patient Table (Many-to-Many)
INSERT INTO Doctor_Patient (DoctorID, PatientID) VALUES
(1, 1),
(2, 2),
(3, 3),
(1, 2),  -- Doctor 1 also sees Patient 2
(2, 3);  -- Doctor 2 also sees Patient 3
