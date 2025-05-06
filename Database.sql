DROP TABLE Pizzeria,Cliente,Dipendente,Ordine,Pizza,Compresa,Recapito;
DROP DATABASE Ordini;
#Creazione Database
CREATE DATABASE IF NOT EXISTS Ordini;

USE Ordini;

#Creazione tabelle
CREATE TABLE IF NOT EXISTS Pizzeria(
	ID INT NOT NULL,
    N_telefono INT,
    Indirizzo VARCHAR(25),
    primary key(id)
);

CREATE TABLE IF NOT EXISTS  Dipendente(
	Matricola INT NOT NULL,
    Nome VARCHAR(20),
    Cognome VARCHAR(20),
    N_telefono INT,
    Ruolo VARCHAR(20),
    N_tavoli INT,
	ID INT NOT NULL,
    primary key(Matricola,ID),
    foreign key(ID) references Pizzeria(ID)
);
    
CREATE TABLE IF NOT EXISTS Cliente(
	Codice INT NOT NULL,
    Nominativo VARCHAR(20),
    N_telefono INT,
    primary key(Codice)
);
    
CREATE TABLE IF NOT EXISTS Ordine(
	N_Ordine INT NOT NULL,
    Stato VARCHAR(20),
	Matricola INT NOT NULL,
    Cod_Cliente INT NOT NULL,
    tavolo INT,
    Orario DATETIME,
    primary key(N_Ordine,Matricola,Cod_Cliente),
    foreign key(Matricola) references Dipendente(Matricola),
    foreign key(Cod_Cliente) references Cliente(Codice)
);

CREATE TABLE IF NOT EXISTS  Pizza(
	Nome VARCHAR(20) NOT NULL,
	Prezzo DOUBLE,
	primary key(Nome)
);

CREATE TABLE IF NOT EXISTS Compresa(
	Nome_P VARCHAR(20) NOT NULL,
    Num_Ordine INT NOT NULL,
    primary key(Nome_P,Num_Ordine),
    foreign key(Nome_P) references Pizza(Nome),
    foreign key(Num_Ordine) references Ordine(N_Ordine)
);

CREATE TABLE IF NOT EXISTS Recapito(
	Numero INT NOT NULL,
	Matricola INT NOT NULL,
    primary key(Numero,Matricola),
    foreign key(Matricola) references Dipendente(Matricola)
);

#Caricamento
INSERT INTO Pizzeria (ID, N_telefono, Indirizzo)
VALUES 
(1, 123456789, 'Via Roma 1'),
(2, 987654321, 'Via Garibaldi 2'),
(3, 111222333, 'Via Dante 3');

INSERT INTO Dipendente (Matricola, Nome, Cognome, N_telefono, Ruolo, N_tavoli, ID)
VALUES 
(101, 'Mario', 'Rosso', 333444555, 'Pizzaiolo', 0, 1),
(102, 'Luigi', 'Verde', 666777888, 'Cameriere', 5, 2),
(103, 'Giovanni', 'Bianco', 999000111, 'Cassiere', 0, 3),
(104, 'Maria', 'Nero', 222333444, 'Cameriere', 7, 1),
(105, 'Paola', 'Giallo', 555666777, 'Pizzaiolo', 0, 2);

INSERT INTO Cliente (Codice, Nominativo, N_telefono)
VALUES 
(1, 'Bianchi', 111222333),
(2, 'Rossi', 444555666),
(3, 'Verdi', 777888999);

INSERT INTO Ordine (N_Ordine, Stato, Matricola, Cod_Cliente, tavolo, Orario)
VALUES 
(1001, 'In preparazione', 101, 1, 10, '2024-02-22 10:00:00'),
(1002, 'Pronto', 102, 2, 5, '2024-02-22 11:30:00'),
(1003, 'In Attesa', 103, 3, 0, '2024-02-22 12:45:00');

INSERT INTO Pizza (Nome, Prezzo)
VALUES 
('Margherita', 5.00),
('Prosciutto e Funghi', 6.50),
('Quattro Stagioni', 7.00),
('Capricciosa', 7.50),
('Diavola', 6.00);

INSERT INTO Compresa (Nome_P, Num_Ordine)
VALUES 
('Margherita', 1001),
('Prosciutto e Funghi', 1002),
('Quattro Stagioni', 1003),
('Capricciosa', 1001),
('Diavola', 1002);

INSERT INTO Recapito (Numero, Matricola)
VALUES 
(111111111, 101),
(222222222, 102),
(333333333, 103),
(444444444, 104),
(555555555, 105);


#QUERY

#Una selezione ordinata su un attributo di una tabella con condizioni AND e OR
SELECT *
FROM Ordine
WHERE (Stato = 'In Attesa' AND Matricola = 101) OR (Stato = 'Pronto' AND Cod_Cliente = 2)
ORDER BY N_Ordine;

#Una selezione su due o più tabelle con condizioni; 
SELECT Ordine.*, Cliente.Nominativo
FROM Ordine,CLiente
WHERE Ordine.Cod_Cliente = Cliente.Codice AND Ordine.Stato = 'In preparazione' ;

#Una selezione aggregata su tutti i valori
SELECT N_Ordine, SUM(Prezzo) AS Totale
FROM Ordine,Compresa,Pizza
WHERE Ordine.N_Ordine = Compresa.Num_Ordine AND Compresa.Nome_P = Pizza.Nome
GROUP BY N_Ordine;

#Una selezione aggregata su raggruppamenti 
SELECT d.Nome, COUNT(o.N_Ordine) AS NumeroOrdini
FROM Dipendente d,Ordine o
WHERE d.Matricola = o.Matricola
GROUP BY d.Nome;

#Una selezione aggregata su raggruppamenti con condizioni 
SELECT d.Nome, o.N_Ordine, SUM(p.Prezzo) AS TotaleOrdine
FROM Dipendente d,Ordine o,Compresa c,Pizza p
WHERE d.Matricola = o.Matricola AND o.N_Ordine = c.Num_Ordine AND c.Nome_P = p.Nome
GROUP BY d.Nome, o.N_Ordine
HAVING SUM(p.Prezzo) > 10;

#Una selezione aggregata su raggruppamenti con condizioni che includano un’altra funzione di raggruppamento
SELECT d.Nome, COUNT(o.N_Ordine) AS NumeroOrdini, SUM(p.Prezzo) AS TotaleOrdini
FROM Dipendente d,Ordine o,Compresa c,Pizza p
WHERE d.Matricola = o.Matricola AND o.N_Ordine = c.Num_Ordine AND c.Nome_P = p.Nome
GROUP BY d.Nome
HAVING COUNT(o.N_Ordine) >= 3 AND SUM(p.Prezzo) > 10;

#Una selezione con operazioni insiemistiche
SELECT Nome, 'Dipendente' AS Tipo
FROM Dipendente
UNION
SELECT Nominativo, 'Cliente' AS Tipo
FROM Cliente;

#Una selezione con l’uso appropriato della divisione
SELECT Codice,Nominativo
FROM Cliente cl
WHERE NOT EXISTS(
	SELECT *
    FROM Compresa co
    WHERE co.Nome_P='Margherita' AND NOT EXISTS(
		SELECT *
        FROM Ordine o
        WHERE o.Cod_Cliente=cl.Codice AND o.N_Ordine=co.Num_Ordine
	)
);
    
