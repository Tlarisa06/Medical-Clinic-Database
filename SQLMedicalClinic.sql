/*
=============================================================================
Proiect: Sistem Gestiune Cabinet Medical
Descriere: Script complet pentru crearea bazei de date, 
           validări, proceduri stocate și mecanisme de monitorizare.
=============================================================================
*/

-- CREAREA BAZEI DE DATE ȘI A STRUCTURII
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'CabinetMedical')
BEGIN
    CREATE DATABASE CabinetMedical;
END
GO

USE CabinetMedical;
GO

-- Ștergem tabelele în ordine inversă a cheilor externe pentru a evita erorile
IF OBJECT_ID('Consultatie', 'U') IS NOT NULL DROP TABLE Consultatie;
IF OBJECT_ID('Medic', 'U') IS NOT NULL DROP TABLE Medic;
IF OBJECT_ID('Pacient', 'U') IS NOT NULL DROP TABLE Pacient;
IF OBJECT_ID('Departament', 'U') IS NOT NULL DROP TABLE Departament;
IF OBJECT_ID('Spital', 'U') IS NOT NULL DROP TABLE Spital;
GO

CREATE TABLE Spital (
    Id_Spital INT IDENTITY(1,1) PRIMARY KEY, 
    NumeSpital VARCHAR(100),
    Adresa VARCHAR(200)
);

CREATE TABLE Departament (
    Id_Departament INT IDENTITY(1,1) PRIMARY KEY, 
    NumeDepartament VARCHAR(100)
);

CREATE TABLE Pacient (
    Id_Pacient INT IDENTITY(1,1) PRIMARY KEY, 
    NumePacient VARCHAR(100),
    Varsta INT,
    Adresa VARCHAR(200)
);

CREATE TABLE Medic (
    Id_Medic INT IDENTITY(1,1) PRIMARY KEY, 
    NumeMedic VARCHAR(100),
    Specializare VARCHAR(100),
    Telefon VARCHAR(20),
    Id_Spital INT FOREIGN KEY REFERENCES Spital(Id_Spital),
    Id_Departament INT FOREIGN KEY REFERENCES Departament(Id_Departament)
);

CREATE TABLE Consultatie (
    Id_Consultatie INT IDENTITY(1,1) PRIMARY KEY, 
    Id_Medic INT FOREIGN KEY REFERENCES Medic(Id_Medic),
    Id_Pacient INT FOREIGN KEY REFERENCES Pacient(Id_Pacient),
    DataConsultatiei DATE,
    Diagnostic VARCHAR(200)
);
GO

USE CabinetMedical;
GO

INSERT INTO Spital (NumeSpital, Adresa) VALUES
('Spitalul de Urgente', 'Institutii 61'),
('Spitalul de Psihiatrie', 'Calea Transilvaniei');

INSERT INTO Departament (NumeDepartament) VALUES
('Cardiologie'),
('Neurologie');

INSERT INTO Pacient (NumePacient, Varsta, Adresa) VALUES
('Maria Pop', 25, 'Plopilor 10'),
('Constantin Florescu', 40, 'Salcamilor 24B');

INSERT INTO Medic (NumeMedic, Specializare, Telefon, Id_Spital, Id_Departament) VALUES
('Lucian Grigorescu', 'Cardiolog', '0712345678', 1, 1),
('Ioana Alaci', 'Neurolog', '0798765432', 2, 2);

INSERT INTO Consultatie (Id_Medic, Id_Pacient, DataConsultatiei, Diagnostic) VALUES
(1, 1, '2025-10-14', 'Hipertensiune'),
(2, 2, '2025-12-04', 'Depresie');
GO

SELECT * FROM Spital;
SELECT * FROM Departament;
SELECT * FROM Medic;
SELECT * FROM Pacient;
SELECT * FROM Consultatie;

-- Operatii de baza

UPDATE Spital SET Adresa='Izvor' 
WHERE Id_Spital= 1 AND NumeSpital='Spitalul de Urgente'

DELETE FROM Consultatie
WHERE Diagnostic ='Hipertensiune' AND DataConsultatiei IS NOT NULL

SELECT NumePacient AS Nume FROM Pacient
UNION
SELECT NumeMedic AS Nume FROM Medic;

-- INNER JOIN între 3 tabele (Consultatie, Medic, Pacient)
SELECT 
    C.Id_Consultatie,
    M.NumeMedic,
    P.NumePacient,
    C.DataConsultatiei,
    C.Diagnostic
FROM Consultatie AS C
INNER JOIN Medic AS M ON C.Id_Medic = M.Id_Medic
INNER JOIN Pacient AS P ON C.Id_Pacient = P.Id_Pacient;

-- INNER JOIN între 3 tabele (Medic, Departament, Spital)
SELECT 
    M.NumeMedic,
    M.Specializare,
    D.NumeDepartament,
    S.NumeSpital
FROM Medic AS M
INNER JOIN Departament AS D ON M.Id_Departament = D.Id_Departament
INNER JOIN Spital AS S ON M.Id_Spital = S.Id_Spital;

-- LEFT JOIN (toți pacienții, chiar dacă nu au consultație)
DELETE FROM Consultatie
WHERE Id_Pacient = 2

SELECT 
    P.NumePacient,
    C.DataConsultatiei,
    C.Diagnostic,
    M.NumeMedic
FROM Pacient AS P
LEFT JOIN Consultatie AS C
    ON P.Id_Pacient = C.Id_Pacient
LEFT JOIN Medic AS M
    ON C.Id_Medic = M.Id_Medic;

-- GROUP BY + MAX (afișează data ultimei consultații pentru fiecare medic)
SELECT
    M.NumeMedic,
    MAX(C.DataConsultatiei) AS UltimaConsultatie
FROM Medic AS M
LEFT JOIN Consultatie AS C
    ON M.Id_Medic = C.Id_Medic
GROUP BY M.NumeMedic;


-- GROUP BY + AVG + DISTINCT 
SELECT 
    DISTINCT M.NumeMedic,
    AVG(P.Varsta) AS VarstaMediePacienti
FROM Medic AS M
INNER JOIN Consultatie AS C ON M.Id_Medic = C.Id_Medic
INNER JOIN Pacient AS P ON C.Id_Pacient = P.Id_Pacient
GROUP BY M.NumeMedic;

-- GROUP BY + HAVING (condiție pe rezultat agregat)
SELECT 
    D.NumeDepartament,
    COUNT(M.Id_Medic) AS NrMedici
FROM Departament AS D
LEFT JOIN Medic AS M ON D.Id_Departament = M.Id_Departament
GROUP BY D.NumeDepartament
HAVING COUNT(M.Id_Medic) > 0;

-- Subinterogare cu IN (pacientii care au consultatie)
SELECT NumePacient
FROM Pacient
WHERE Id_Pacient IN (SELECT Id_Pacient FROM Consultatie);

-- Subinterogare cu EXISTS + condiție compusă cu AND
SELECT NumeMedic, Specializare
FROM Medic AS M
WHERE EXISTS (
        SELECT 1 FROM Consultatie AS C
        WHERE C.Id_Medic = M.Id_Medic AND (C.Diagnostic IS NOT NULL)
    ); 


-- Validări (Funcții user-defined) 
-- Funcția 1: Validare text (să nu fie gol sau NULL)
GO
ALTER FUNCTION dbo.ValidateString (@text VARCHAR(MAX))
RETURNS INT
AS
BEGIN
    DECLARE @isValid INT;
    IF @text IS NULL OR LEN(TRIM(@text)) = 0
        SET @isValid = 0; -- Invalid
    ELSE
        SET @isValid = 1; -- Valid
    RETURN @isValid;
END;
GO

-- Funcția 2: Validare vârstă pozitivă
ALTER FUNCTION dbo.ValidateAge (@age INT)
RETURNS INT
AS
BEGIN
    DECLARE @isValid INT;
    IF @age IS NULL OR @age <= 0 OR @age > 120
        SET @isValid = 0; -- Invalid
    ELSE
        SET @isValid = 1; -- Valid
    RETURN @isValid;
END;
GO

-- Funcția 3: Validare telefon (format simplu de 10 cifre)
ALTER FUNCTION dbo.ValidatePhone (@phone VARCHAR(20))
RETURNS INT
AS
BEGIN
    DECLARE @isValid INT;
    IF @phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
        SET @isValid = 1; -- Valid
    ELSE
        SET @isValid = 0; -- Invalid
    RETURN @isValid;
END;
GO

-- Proceduri Stocate 
-- Procedura: Inserare în tabelul 'Departament' 
-- Parametrii sunt atributele, mai puțin cheia primară 
GO
ALTER PROCEDURE sp_InsertDepartament
    @NumeDepartament VARCHAR(100)
AS
BEGIN
    IF dbo.ValidateString(@NumeDepartament) = 1
    BEGIN
        INSERT INTO Departament (NumeDepartament)
        VALUES (@NumeDepartament);
        PRINT 'Departament inserat cu succes.';
    END
    ELSE
    BEGIN
        PRINT 'Eroare: Nume departament invalid.';
    END
END;
GO


EXEC sp_InsertDepartament  @NumeDepartament = 'Radiologie';--ok
EXEC sp_InsertDepartament  @NumeDepartament = '';-- nu e ok


-- Procedura: Inserare în tabelul 'Pacient'
GO
ALTER PROCEDURE sp_InsertPacient
    @NumePacient VARCHAR(100),
    @Varsta INT,
    @Adresa VARCHAR(200)
AS
BEGIN
    IF dbo.ValidateString(@NumePacient) = 1 AND dbo.ValidateAge(@Varsta) = 1
    BEGIN
        INSERT INTO Pacient (NumePacient, Varsta, Adresa)
        VALUES (@NumePacient, @Varsta, @Adresa);
        PRINT 'Pacient inserat cu succes.';
    END
    ELSE
    BEGIN
        PRINT 'Eroare: Date invalide pentru pacient (nume sau varsta).';
    END
END;
GO

EXEC sp_InsertPacient  @NumePacient = 'Ion Creanga', @Varsta = 45, @Adresa = 'Str. Humulesti';
--e ok, declanseaza și triggerul de INSERT.
EXEC sp_InsertPacient  @NumePacient = 'Vasile', @Varsta = -5, @Adresa = 'Test';


-- Procedura: Inserare în 'Consultatie' (tabela de legatura)
-- Pentru tabela de legatura se pot indica FK-urile care o definesc 
GO
ALTER PROCEDURE sp_InsertConsultatie
    @Id_Medic INT,
    @Id_Pacient INT,
    @DataConsultatiei DATE,
    @Diagnostic VARCHAR(200)
AS
BEGIN
    IF dbo.ValidateString(@Diagnostic) = 1
    BEGIN
        INSERT INTO Consultatie (Id_Medic, Id_Pacient, DataConsultatiei, Diagnostic)
        VALUES (@Id_Medic, @Id_Pacient, @DataConsultatiei, @Diagnostic);
        PRINT 'Consultatie inserata cu succes.';
    END
    ELSE
    BEGIN
        PRINT 'Eroare: Diagnostic invalid.';
    END
END;
GO

EXEC sp_InsertConsultatie 
    @Id_Medic = 1, 
    @Id_Pacient = 1, 
    @DataConsultatiei = '2025-01-01', 
    @Diagnostic = '   ';

-- Cerința: Creare View 
-- Combină date din Medic, Pacient și Consultatie (3 tabele)
GO
ALTER VIEW View_SumarConsultatii AS
SELECT 
    C.Id_Consultatie,
    P.NumePacient,
    M.NumeMedic,
    M.Specializare,
    C.DataConsultatiei,
    C.Diagnostic
FROM Consultatie C
INNER JOIN Medic M ON C.Id_Medic = M.Id_Medic
INNER JOIN Pacient P ON C.Id_Pacient = P.Id_Pacient;
GO

SELECT * FROM View_SumarConsultatii;

-- Triggere (Insert și Delete) 
-- Implementare pentru tabelul 'Pacient'
-- Trigger pentru INSERT 
GO
CREATE TRIGGER TR_Pacient_Insert
ON Pacient
AFTER INSERT
AS
BEGIN
    PRINT 'Data/Ora: ' + CAST(GETDATE() AS VARCHAR) + ' | Operatie: INSERT | Tabel: Pacient';
END;
GO

-- Trigger pentru DELETE
GO
CREATE TRIGGER TR_Pacient_Delete
ON Pacient
AFTER DELETE
AS
BEGIN
    PRINT 'Data/Ora: ' + CAST(GETDATE() AS VARCHAR) + ' | Operatie: DELETE | Tabel: Pacient';
END;
GO


EXEC sp_InsertPacient  
    @NumePacient = 'Ion Creanga', 
    @Varsta = 45, 
    @Adresa = 'Str. Humulesti nr. 1';

SELECT * FROM Pacient

DELETE FROM Consultatie WHERE Id_Pacient = 8;
DELETE FROM Pacient WHERE Id_Pacient = 8;



