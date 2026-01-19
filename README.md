# Medical-Clinic-Database

This project represents a database solution for managing a medical clinic, developed using Microsoft SQL Server Management Studio (SSMS). The project covers the entire data lifecycle: from relational schema design to the implementation of validation mechanisms and activity monitoring.

## Main Features
* **Relational Architecture:** Optimized structure featuring 5 interconnected tables (Hospitals, Departments, Doctors, Patients, Consultations).
* **Data Integrity:** Strict validation for age, phone formats, and mandatory fields using User-Defined Functions (UDF).
* **Automation:** Stored procedures for secure data insertion and triggers for auditing INSERT and DELETE operations.
* **Reporting:** Complex Views that combine data from multiple tables for a quick overview of medical history.

## Database Structure
The database consists of the following entities:
1. **Spital (Hospital):** Stores medical units and their addresses.
2. **Departament (Department):** Defines available sections (e.g., Cardiology, Neurology).
3. **Medic (Doctor):** Includes contact details, specialization, and hospital/department affiliation.
4. **Pacient (Patient):** Patient records including age and address details.
5. **Consultatie (Consultation):** A junction table that records diagnoses and consultation history.

<img width="1539" height="560" alt="Untitled (1)" src="https://github.com/user-attachments/assets/4e856be0-e4de-4368-a7e9-2acefb0489ee" />

## Instructions for Use
1. Open Microsoft SQL Server Management Studio.
2. Load the SQL file provided in this repository.
3. Execute the entire script to generate the "CabinetMedical" database and all associated objects (tables, functions, procedures).
4. The insertion procedures include built-in validation logic; attempting to enter invalid data will return an error message in the "Messages" console.

## Implemented Functionalities
* **String Validation:** Prevents the entry of empty or null fields.
* **Age Validation:** Restricts data entry to logical ranges (0 - 120 years).
* **Monitoring:** Triggers automatically display the date and time when patients are added or removed from the system in the console.
* **Data Aggregation:** Queries for calculating average ages and identifying the most recent consultations per doctor.

## Technologies Used
* **Language:** T-SQL (Transact-SQL)
* **DBMS:** Microsoft SQL Server
* **Concepts:** Integrity Constraints, Stored Procedures, Functions, Views, Triggers, Joins, Subqueries.

---
Project developed for the "Database Design" course.
