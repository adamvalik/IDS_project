-- KIS - Kitty Information System
-- autor: Adam Valik <xvalik05>
-- autor: Marek Effenberger <xeffen00>

DROP TABLE Kocka CASCADE CONSTRAINTS;
DROP TABLE Hostitel CASCADE CONSTRAINTS;
DROP TABLE Hracka CASCADE CONSTRAINTS;
DROP TABLE Teritorium CASCADE CONSTRAINTS;
DROP TABLE Smrt CASCADE CONSTRAINTS;
DROP TABLE Kocka_Teritorium CASCADE CONSTRAINTS;

CREATE TABLE Kocka (
    ID_kocky INT GENERATED BY DEFAULT AS IDENTITY,
    jmeno VARCHAR(50),
    rasa VARCHAR(50),

    PRIMARY KEY (ID_kocky)
);

CREATE TABLE Hostitel (
    ID_hostitele INT GENERATED BY DEFAULT AS IDENTITY,
    jmeno VARCHAR(50),
    vek INT,
    pohlavi VARCHAR(5) CHECK (pohlavi IN ('muž', 'žena')) NOT NULL,

    cislo_bankovniho_uctu VARCHAR(21) NOT NULL UNIQUE,
    CONSTRAINT check_bank CHECK (REGEXP_LIKE(cislo_bankovniho_uctu, '^([0-9]{6})?[0-9]{10}/[0-9]{4}$')),

    ID_kocky INT NOT NULL,

    PRIMARY KEY (ID_hostitele),
    FOREIGN KEY (ID_kocky) REFERENCES Kocka(ID_kocky) -- kazdy hostitel slouzi prave jedne kocce
);

CREATE TABLE Hracka (
    ID_hracky INT GENERATED BY DEFAULT AS IDENTITY,
    typ VARCHAR(50),
    barva VARCHAR(50),
    cena DECIMAL(10,2),

    ID_hostitele INT NOT NULL,

    PRIMARY KEY (ID_hracky),
    FOREIGN KEY (ID_hostitele) REFERENCES Hostitel(ID_hostitele) -- ktery hostitel koupil danou hracku
    -- ktera kocka vlastni danou hracku lze zjistit pres hostitele, ktery ji zakonite koupil sve kocce
);

CREATE TABLE Teritorium (
    ID_teritoria INT GENERATED BY DEFAULT AS IDENTITY,
    nazev VARCHAR(50),
    rozloha DECIMAL(10,2),

    -- verejne teritorium
    propaganda VARCHAR(100) NULL, -- reklamni slogany a propagace kocek v danem teritoriu
    rekreace VARCHAR(100) NULL, -- popis rekreacnich moznosti v danem teritoriu

    -- tajne teritorium
    heslo VARCHAR(50) NULL, -- heslo pro vstup do tajneho teritoria
    uroven_ochrany INT NULL, -- uroven ochrany tajneho teritoria

    PRIMARY KEY (ID_teritoria)
    -- tento postup jsme zvolili jelikoz specializace teritoria jsou disjunktni a totalni
);

CREATE TABLE Smrt (
    -- zaznam o ukoncenem zivotu kocky, kocka ma 0 az 9 smrti
    ID_smrti INTEGER GENERATED BY DEFAULT AS IDENTITY,
    ID_kocky INT NOT NULL,

    datum_narozeni DATE NOT NULL,
    datum_smrti DATE NOT NULL,

    zpusob_smrti VARCHAR(100),
    ID_teritoria INT NOT NULL,

    PRIMARY KEY (ID_smrti, ID_kocky),
    FOREIGN KEY (ID_kocky) REFERENCES Kocka(ID_kocky),
    FOREIGN KEY (ID_teritoria) REFERENCES Teritorium(ID_teritoria) -- kde kocka zemrela
);

CREATE TABLE Kocka_Teritorium (
    -- zaznam o tom, ktera kocka se pohybovala v kterych teritoriich
    ID_kocky INT NOT NULL,
    ID_teritoria INT NOT NULL,
    PRIMARY KEY (ID_kocky, ID_teritoria),
    FOREIGN KEY (ID_kocky) REFERENCES Kocka(ID_kocky),
    FOREIGN KEY (ID_teritoria) REFERENCES Teritorium(ID_teritoria)
);


-- kontrola poctu zaznamu smrti, kocka ma 0 az 9 zaznamu o smrti
CREATE OR REPLACE TRIGGER trg_check_death_limit BEFORE INSERT ON Smrt
    FOR EACH ROW
    DECLARE
        death_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO death_count FROM Smrt WHERE ID_kocky = :NEW.ID_kocky;

        IF death_count >= 9 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Kočka nemůže mít více než 9 záznamů o smrti.');
        END IF;
    END;
/

-- kontrola, zda je datum narozeni pred datem smrti
CREATE OR REPLACE TRIGGER trg_birth_before_death BEFORE INSERT ON Smrt
    FOR EACH ROW
    BEGIN
        IF :NEW.datum_narozeni > :NEW.datum_smrti THEN
            RAISE_APPLICATION_ERROR(-20002, 'Datum narození musí být před datem smrtí.');
        END IF;
    END;
/

INSERT INTO Kocka (jmeno, rasa) VALUES ('Amča', 'Korat');
INSERT INTO Kocka (jmeno, rasa) VALUES ('Mikeš', 'Domací');
INSERT INTO Kocka (jmeno, rasa) VALUES ('Micka', 'Egyptská');
INSERT INTO Kocka (jmeno, rasa) VALUES ('Mína', 'Bengálská');
INSERT INTO Kocka (jmeno, rasa) VALUES ('Mourek', 'Spynx');
INSERT INTO Kocka (jmeno, rasa) VALUES ('Cavo', 'Ostravská');
INSERT INTO Kocka (jmeno, rasa) VALUES ('DJKhaled', 'Music');
INSERT INTO Kocka (jmeno, rasa) VALUES ('Zrzek', 'Somálská');

INSERT INTO Hostitel (jmeno, vek, pohlavi, cislo_bankovniho_uctu, ID_kocky) VALUES ('Pepa', 20, 'muž', '1234567890/0111', 1);
INSERT INTO Hostitel (jmeno, vek, pohlavi, cislo_bankovniho_uctu, ID_kocky) VALUES ('Honza', 35, 'muž', '6487293817/1000', 1);
INSERT INTO Hostitel (jmeno, vek, pohlavi, cislo_bankovniho_uctu, ID_kocky) VALUES ('Lady Gaga', 45, 'žena', '9876125643/3433', 1);
INSERT INTO Hostitel (jmeno, vek, pohlavi, cislo_bankovniho_uctu, ID_kocky) VALUES ('Zlata', 55, 'žena', '1234876234/2222', 3);
INSERT INTO Hostitel (jmeno, vek, pohlavi, cislo_bankovniho_uctu, ID_kocky) VALUES ('Máňa', 65, 'žena', '7876273847/5432', 3);
INSERT INTO Hostitel (jmeno, vek, pohlavi, cislo_bankovniho_uctu, ID_kocky) VALUES ('Karolína', 75, 'žena', '1234716273/5432', 5);
INSERT INTO Hostitel (jmeno, vek, pohlavi, cislo_bankovniho_uctu, ID_kocky) VALUES ('Michal', 15, 'muž', '9182736453/5432', 6);
INSERT INTO Hostitel (jmeno, vek, pohlavi, cislo_bankovniho_uctu, ID_kocky) VALUES ('Jana', 90, 'žena', '3647086432/5432', 7);
INSERT INTO Hostitel (jmeno, vek, pohlavi, cislo_bankovniho_uctu, ID_kocky) VALUES ('Jirka', 22, 'muž', '5284957284/2222', 7);
INSERT INTO Hostitel (jmeno, vek, pohlavi, cislo_bankovniho_uctu, ID_kocky) VALUES ('Rytmus', 51, 'muž', '5294628502/0111', 7);

INSERT INTO Hracka (typ, barva, cena, ID_hostitele) VALUES ('Kulička', 'černá', 30.05, 1);
INSERT INTO Hracka (typ, barva, cena, ID_hostitele) VALUES ('Pelech', 'bílá', 100.00, 2);
INSERT INTO Hracka (typ, barva, cena, ID_hostitele) VALUES ('Myš', 'hnědá', 19.90, 3);
INSERT INTO Hracka (typ, barva, cena, ID_hostitele) VALUES ('Hůlka s pírkem', 'Vícebarevná', 7.50, 4);
INSERT INTO Hracka (typ, barva, cena, ID_hostitele) VALUES ('Míček', 'Zelená', 5.25, 5);
INSERT INTO Hracka (typ, barva, cena, ID_hostitele) VALUES ('Škrabadlo', 'Bežcová', 19.99, 8);
INSERT INTO Hracka (typ, barva, cena, ID_hostitele) VALUES ('Tunelová hračka', 'Modrá', 15.75, 9);
INSERT INTO Hracka (typ, barva, cena, ID_hostitele) VALUES ('Hračka s peřím', 'Červená', 8.99, 9);

INSERT INTO Teritorium (nazev, rozloha, propaganda, rekreace) VALUES ('Kočičí park', 1000.00, 'Připojte se k dokonalé komunitě!', 'Hřiště, trávnaté plochy');
INSERT INTO Teritorium (nazev, rozloha, propaganda, rekreace) VALUES ('Sluneční louky', 750.00, 'Nadčasové místo relaxace!', 'Místa na slunění, zahrady');
INSERT INTO Teritorium (nazev, rozloha, propaganda, rekreace) VALUES ('Doupě drápů', 1200.00, 'Domov nejmocnějších koček!', 'Škrabadla, stromy k lezení');
INSERT INTO Teritorium (nazev, rozloha, propaganda, rekreace) VALUES ('Lesy chlupů', 800.00, 'Objevte tajemství divočiny!', 'Přírodní stezky, skrýše');
INSERT INTO Teritorium (nazev, rozloha, heslo, uroven_ochrany) VALUES ('Tajná kobka', 500.00, 'mňau123', 5);
INSERT INTO Teritorium (nazev, rozloha, heslo, uroven_ochrany) VALUES ('Kočičí ráj', 1500.00, 'mňau456', 10);
INSERT INTO Teritorium (nazev, rozloha, heslo, uroven_ochrany) VALUES ('Kočičí koutek', 2000.00, 'mňau789', 15);

INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (1, TO_DATE('2010-05-15', 'YYYY-MM-DD'), TO_DATE('2022-08-20', 'YYYY-MM-DD'), 'Stáří', 1);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (2, TO_DATE('2012-10-20', 'YYYY-MM-DD'), TO_DATE('2023-01-10', 'YYYY-MM-DD'), 'Nemoc', 3);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (3, TO_DATE('2015-03-30', 'YYYY-MM-DD'), TO_DATE('2024-02-05', 'YYYY-MM-DD'), 'Nehoda', 4);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (4, TO_DATE('2011-01-20', 'YYYY-MM-DD'), TO_DATE('2023-03-15', 'YYYY-MM-DD'), 'Staroba', 2);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (2, TO_DATE('2013-04-10', 'YYYY-MM-DD'), TO_DATE('2024-05-12', 'YYYY-MM-DD'), 'Zranění', 1);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (3, TO_DATE('2016-08-05', 'YYYY-MM-DD'), TO_DATE('2022-10-30', 'YYYY-MM-DD'), 'Nemoc', 3);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (4, TO_DATE('2019-11-15', 'YYYY-MM-DD'), TO_DATE('2025-01-25', 'YYYY-MM-DD'), 'Neštěstí', 4);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (1, TO_DATE('2012-03-10', 'YYYY-MM-DD'), TO_DATE('2021-07-20', 'YYYY-MM-DD'), 'Stáří', 1);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (2, TO_DATE('2014-06-25', 'YYYY-MM-DD'), TO_DATE('2022-11-05', 'YYYY-MM-DD'), 'Nemoc', 5);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (3, TO_DATE('2017-09-15', 'YYYY-MM-DD'), TO_DATE('2021-12-30', 'YYYY-MM-DD'), 'Úraz', 2);

INSERT INTO Kocka_Teritorium (ID_kocky, ID_teritoria) VALUES (1, 1);
INSERT INTO Kocka_Teritorium (ID_kocky, ID_teritoria) VALUES (1, 2);
INSERT INTO Kocka_Teritorium (ID_kocky, ID_teritoria) VALUES (1, 3);
INSERT INTO Kocka_Teritorium (ID_kocky, ID_teritoria) VALUES (2, 1);
INSERT INTO Kocka_Teritorium (ID_kocky, ID_teritoria) VALUES (2, 3);
INSERT INTO Kocka_Teritorium (ID_kocky, ID_teritoria) VALUES (2, 5);
INSERT INTO Kocka_Teritorium (ID_kocky, ID_teritoria) VALUES (3, 3);
INSERT INTO Kocka_Teritorium (ID_kocky, ID_teritoria) VALUES (3, 4);
INSERT INTO Kocka_Teritorium (ID_kocky, ID_teritoria) VALUES (4, 2);
INSERT INTO Kocka_Teritorium (ID_kocky, ID_teritoria) VALUES (5, 5);
INSERT INTO Kocka_Teritorium (ID_kocky, ID_teritoria) VALUES (6, 5);
INSERT INTO Kocka_Teritorium (ID_kocky, ID_teritoria) VALUES (6, 6);
INSERT INTO Kocka_Teritorium (ID_kocky, ID_teritoria) VALUES (7, 6);
INSERT INTO Kocka_Teritorium (ID_kocky, ID_teritoria) VALUES (8, 7);

-- kolik jednotlivi hostitele utratili za hracky, serazeno dle utraty sestupne
SELECT jmeno, SUM(cena) AS utrata FROM Hostitel NATURAL JOIN Hracka
GROUP BY jmeno
ORDER BY utrata DESC;

-- seznam vsech kocek (ktere maji hostitele) a jejich vlastnictvi
SELECT Kocka.jmeno, LISTAGG(Hracka.barva || ' ' || Hracka.typ, ', ') WITHIN GROUP (ORDER BY Hracka.typ) AS vlastene_hracky
FROM Kocka JOIN Hostitel ON Kocka.ID_kocky = Hostitel.ID_kocky
LEFT JOIN Hracka ON Hostitel.ID_hostitele = Hracka.ID_hostitele
GROUP BY Kocka.jmeno;

-- kteremu pohlavi umrelo kolik kocek
SELECT pohlavi, COUNT(*) AS pocet_mrtvych FROM Hostitel NATURAL JOIN Smrt
GROUP BY pohlavi;

-- kolik kazda kocka jiz prozila zivotu (zobraz ty minimalne s jednou smrti)
SELECT jmeno, COUNT(*) AS prozitych_zivotu FROM Kocka NATURAL JOIN Smrt
GROUP BY jmeno
ORDER BY prozitych_zivotu DESC;

-- prumerna delka zivota kocek
SELECT ID_kocky AS ID, jmeno, ROUND(AVG(datum_smrti - datum_narozeni) / 365, 2) AS prumerna_delka_zivota FROM Kocka NATURAL JOIN Smrt
GROUP BY ID_kocky, jmeno;

-- kocky ktere vlastni hracku mys
SELECT jmeno, rasa FROM Kocka
WHERE ID_kocky IN (
    SELECT Hostitel.ID_kocky
    FROM Hostitel
    JOIN Hracka ON Hostitel.ID_hostitele = Hracka.ID_hostitele
    WHERE Hracka.typ = 'Myš'
);

-- teritoria ve kterych nezemrela zadna kocka
SELECT nazev AS teritoria_bez_smrti FROM Teritorium
WHERE NOT EXISTS(
    SELECT * FROM Smrt
    WHERE Smrt.ID_teritoria = Teritorium.ID_teritoria
);

-- list tajnych teritorii vcetne kocek, ktere k nim maji pristup
SELECT ID_teritoria AS ID, nazev, heslo, uroven_ochrany, LISTAGG(jmeno, ', ') WITHIN GROUP (ORDER BY jmeno) AS navstevnici
FROM Teritorium NATURAL JOIN Kocka_Teritorium NATURAL JOIN Kocka
WHERE heslo IS NOT NULL and uroven_ochrany IS NOT NULL
GROUP BY ID_teritoria, nazev, heslo, uroven_ochrany;

-- ktere kocky znaji ktera hesla
SELECT jmeno, rasa, LISTAGG(heslo, ', ') WITHIN GROUP (ORDER BY heslo) AS hesla
FROM Kocka NATURAL JOIN Kocka_Teritorium NATURAL JOIN Teritorium
WHERE heslo IS NOT NULL and uroven_ochrany IS NOT NULL
GROUP BY jmeno, rasa;

-- list kocek vcetne teritorii, ve kterych se kdy nachazeli
SELECT ID_kocky AS ID, jmeno, LISTAGG(nazev, ', ') WITHIN GROUP (ORDER BY nazev) AS navstivena_teritoria
FROM Kocka NATURAL JOIN Kocka_Teritorium NATURAL JOIN Teritorium
GROUP BY ID_kocky, jmeno;

-- popularita teritorii (dle navstevnosti)
SELECT nazev AS nazev_teritoria, COUNT(*) AS pocet_navstev
FROM Teritorium NATURAL JOIN Kocka_Teritorium
GROUP BY nazev
ORDER BY pocet_navstev DESC;
