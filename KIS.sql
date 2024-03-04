CREATE TABLE Kocka (
    ID_vzorku_kuze INT PRIMARY KEY AUTO_INCREMENT,
    jmeno VARCHAR(50),
    rasa VARCHAR(20),
    ID_hostitele INT,
    FOREIGN KEY (ID_hostitele) REFERENCES Hostitel (ID_hostitele)
);

CREATE TABLE Hostitel (
    ID_hostitele INT PRIMARY KEY AUTO_INCREMENT,
    jmeno VARCHAR(20),
    vek INT,
    pohlavi ENUM('Muž', 'Žena') NOT NULL,
    rodne_cislo VARCHAR(255) UNIQUE,
    cislo_bankovniho_uctu VARCHAR(255) UNIQUE
);

CREATE TABLE Hracka (
    ID_hracky INT PRIMARY KEY AUTO_INCREMENT,
    typ VARCHAR(255),
    barva VARCHAR(255),
    cena DECIMAL(10,2),
    ID_kocka INT,
    FOREIGN KEY (ID_kocka) REFERENCES Kocka (ID_vzorku_kuze)
);

CREATE TABLE Teritorium (
    ID_teritoria INT PRIMARY KEY AUTO_INCREMENT,
    nazev VARCHAR(255),
    rozloha DECIMAL(10,2),
    pocet_kocek INT
);

CREATE TABLE Zivot (
    ID_zivota INT PRIMARY KEY AUTO_INCREMENT,
    datum_narozeni DATE,
    cas_narozeni TIME,
    ID_kocka INT,
    FOREIGN KEY (ID_kocka) REFERENCES Kocka (ID_vzorku_kuze)
);

CREATE TABLE Probehly_zivot (
    delka_zivota INT,
    zpusob_smrti VARCHAR(255),
    ID_zivota INT,
    FOREIGN KEY (ID_zivota) REFERENCES Zivot (ID_zivota)
);

CREATE TABLE Kocka_Teritorium (
    ID_kocka INT,
    ID_teritoria INT,
    PRIMARY KEY (ID_kocka, ID_teritoria),
    FOREIGN KEY (ID_kocka) REFERENCES Kocka (ID_vzorku_kuze),
    FOREIGN KEY (ID_teritoria) REFERENCES Teritorium (ID_teritoria)
);

INSERT INTO Hostitel (jmeno, vek, pohlavi, rodne_cislo, cislo_bankovniho_uctu)
VALUES
('Jan Novak', 35, 'Muž', '850505/1234', '123456789/0800'),
('Marie Dvorakova', 28, 'Žena', '920215/5678', '987654321/0800');

INSERT INTO Kocka (jmeno, rasa, ID_hostitele)
VALUES
('Mikes', 'Siamese', 1),
('Whiskers', 'British Shorthair', 2);

INSERT INTO Hracka (typ, barva, cena, ID_kocka)
VALUES
('Mice', 'Grey', 49.99, 1),
('Ball', 'Red', 29.99, 2);

INSERT INTO Teritorium (nazev, rozloha)
VALUES
('Garden', 100.00),
('House', 200.00);

INSERT INTO Zivot (datum_a_cas_narozeni, ID_kocka)
VALUES
('2023-01-20 14:35:00', 1),
('2023-02-11 09:15:00', 2);

INSERT INTO Probehlý_zivot (delka_zivota, zpusob_smrti, ID_zivota)
VALUES
(5, 'Old Age', 1),
(3, 'Illness', 2);

INSERT INTO Kocka_Teritorium (ID_kocka, ID_teritoria)
VALUES
(1, 1),
(2, 2),
(1, 2);
