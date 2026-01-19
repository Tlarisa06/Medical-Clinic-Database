# Medical-Clinic-Database

Acest proiect reprezinta o solutie de baza de date pentru administrarea unui cabinet medical, realizata in Microsoft SQL Server Management Studio (SSMS). Proiectul acopera intreg ciclul de viata al datelor: de la proiectarea schemei relationale pana la implementarea mecanismelor de validare si monitorizare a activitatii.

## Caracteristici principale
* Arhitectura Relationala: Structura optimizata cu 5 tabele interconectate (Spitale, Departamente, Medici, Pacienti, Consultatii).
* Integritatea Datelor: Validari stricte pentru varsta, formate de telefon si campuri obligatorii prin functii User-Defined (UDF).
* Automatizare: Proceduri stocate pentru inserarea securizata a datelor si triggere pentru auditarea actiunilor de tip INSERT si DELETE.
* Raportare: View-uri complexe care combina datele din mai multe tabele pentru o vizualizare rapida a istoricului medical.

## Structura Bazei de Date
Baza de date este compusa din urmatoarele entitati:
1. Spital: Stocheaza unitatile medicale si adresele acestora.
2. Departament: Defineste sectiile disponibile (ex: Cardiologie, Neurologie).
3. Medic: Include datele de contact, specializarea si afilierea la spital/departament.
4. Pacient: Evidenta pacientilor cu detalii despre varsta si adresa.
5. Consultatie: Tabela de legatura care inregistreaza diagnosticele si istoricul consultatiilor.

<img width="1539" height="560" alt="Untitled (1)" src="https://github.com/user-attachments/assets/4e856be0-e4de-4368-a7e9-2acefb0489ee" />



## Instructiuni de Utilizare
1. Deschideti Microsoft SQL Server Management Studio.
2. Incarcati fisierul SQL furnizat in acest repository.
3. Executati scriptul integral pentru a genera baza de date "CabinetMedical" si toate obiectele aferente (tabele, functii, proceduri).
4. Procedurile de insert contin logica de validare incorporata; incercarea de a introduce date invalide va returna un mesaj de eroare in consola "Messages".

## Functionalitati Implementate
* Validare siruri de caractere: Previne introducerea campurilor goale sau nule.
* Validare varsta: Limiteaza introducerea datelor intre praguri logice (0 - 120 ani).
* Monitorizare: Triggerele afiseaza automat in consola data si ora la care au fost adaugati sau stersi pacienti din sistem.
* Agregare date: Interogari pentru calculul mediilor de varsta si identificarea ultimelor consultatii per medic.

## Tehnologii Folosite
* Limbaj: T-SQL (Transact-SQL)
* DBMS: Microsoft SQL Server
* Concepte: Constrangeri de integritate, Proceduri Stocate, Functii, View-uri, Triggere, Join-uri, Subinterogari.

---
Proiect realizat pentru disciplina Proiectarea Bazelor de Date.
