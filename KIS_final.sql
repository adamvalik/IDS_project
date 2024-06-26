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
    zije INT DEFAULT 1 NOT NULL CHECK (zije IN (0, 1)),

    PRIMARY KEY (ID_kocky)
);

CREATE TABLE Hostitel (
    ID_hostitele INT GENERATED BY DEFAULT AS IDENTITY,
    jmeno VARCHAR(50),
    vek INT,
    pohlavi VARCHAR(5) CHECK (pohlavi IN ('muž', 'žena')) NOT NULL,

    cislo_bankovniho_uctu VARCHAR(21) NOT NULL UNIQUE,
    CONSTRAINT check_bank CHECK (REGEXP_LIKE(cislo_bankovniho_uctu, '^([0-9]{6})?[0-9]{10}/[0-9]{4}$')),

    ID_kocky INT NULL,

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

INSERT INTO Kocka (jmeno, rasa) VALUES ('Amča', 'Korat');
INSERT INTO Kocka (jmeno, rasa) VALUES ('Mikeš', 'Domací');
INSERT INTO Kocka (jmeno, rasa) VALUES ('Micka', 'Egyptská');
INSERT INTO Kocka (jmeno, rasa) VALUES ('Mína', 'Bengálská');
INSERT INTO Kocka (jmeno, rasa) VALUES ('Mourek', 'Sphynx');
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
INSERT INTO Hracka (typ, barva, cena, ID_hostitele) VALUES ('Míček', 'Zelená', 29.90, 5);
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
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (2, TO_DATE('2012-10-20', 'YYYY-MM-DD'), TO_DATE('2014-06-25', 'YYYY-MM-DD'), 'Nemoc', 3);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (3, TO_DATE('2015-03-30', 'YYYY-MM-DD'), TO_DATE('2024-02-05', 'YYYY-MM-DD'), 'Nehoda', 4);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (4, TO_DATE('2011-01-20', 'YYYY-MM-DD'), TO_DATE('2023-03-15', 'YYYY-MM-DD'), 'Staroba', 2);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (2, TO_DATE('2013-04-10', 'YYYY-MM-DD'), TO_DATE('2024-05-12', 'YYYY-MM-DD'), 'Zranění', 1);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (3, TO_DATE('2016-08-05', 'YYYY-MM-DD'), TO_DATE('2022-10-30', 'YYYY-MM-DD'), 'Nemoc', 3);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (4, TO_DATE('2019-11-15', 'YYYY-MM-DD'), TO_DATE('2025-01-25', 'YYYY-MM-DD'), 'Neštěstí', 4);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (1, TO_DATE('2012-03-10', 'YYYY-MM-DD'), TO_DATE('2021-07-20', 'YYYY-MM-DD'), 'Stáří', 1);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (2, TO_DATE('2014-06-25', 'YYYY-MM-DD'), TO_DATE('2022-11-05', 'YYYY-MM-DD'), 'Nemoc', 5);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (2, TO_DATE('2022-11-05', 'YYYY-MM-DD'), TO_DATE('2023-04-23', 'YYYY-MM-DD'), 'Nemoc', 5);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (5, TO_DATE('2011-09-14', 'YYYY-MM-DD'), TO_DATE('2012-09-14', 'YYYY-MM-DD'), 'Úraz', 1);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (5, TO_DATE('2012-09-14', 'YYYY-MM-DD'), TO_DATE('2013-09-14', 'YYYY-MM-DD'), 'Nemoc', 2);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (5, TO_DATE('2013-09-14', 'YYYY-MM-DD'), TO_DATE('2014-09-14', 'YYYY-MM-DD'), 'Zranění', 3);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (5, TO_DATE('2014-09-14', 'YYYY-MM-DD'), TO_DATE('2015-09-14', 'YYYY-MM-DD'), 'Nehoda', 4);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (5, TO_DATE('2015-09-14', 'YYYY-MM-DD'), TO_DATE('2016-09-14', 'YYYY-MM-DD'), 'Nemoc', 1);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (5, TO_DATE('2016-09-14', 'YYYY-MM-DD'), TO_DATE('2017-09-14', 'YYYY-MM-DD'), 'Neštěstí', 2);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (5, TO_DATE('2017-09-14', 'YYYY-MM-DD'), TO_DATE('2018-09-14', 'YYYY-MM-DD'), 'Úraz', 3);
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (5, TO_DATE('2018-09-14', 'YYYY-MM-DD'), TO_DATE('2019-09-14', 'YYYY-MM-DD'), 'Úraz', 4);

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

-- kontrola poctu zaznamu smrti, kocka ma 0 az 9 zaznamu o smrti
CREATE OR REPLACE TRIGGER trg_check_smrt BEFORE INSERT ON Smrt
    FOR EACH ROW
    DECLARE
        v_zije Kocka.zije%TYPE;
        death_count NUMBER;
    BEGIN
        SELECT zije INTO v_zije FROM Kocka WHERE ID_kocky = :NEW.ID_kocky;

        IF v_zije = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Kocka uz je mrtva mrtva a neni mozne pridat dalsi zaznam o smrti.');
        END IF;

        SELECT COUNT(*) INTO death_count FROM Smrt WHERE ID_kocky = :NEW.ID_kocky;

        -- vlozena smrt bude posledni (devata)
        IF death_count = 8 THEN
            -- kocka zemrela po devate a je s ni konec
            UPDATE Kocka SET zije = 0 WHERE ID_kocky = :NEW.ID_kocky;
            -- vynuluj zaznamy o kockach u hostitelu
            UPDATE Hostitel SET ID_kocky = NULL WHERE ID_kocky = :NEW.ID_kocky;
        END IF;
    END;
/

-- 9 smrt kocku ukonci
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (5, TO_DATE('2019-09-14', 'YYYY-MM-DD'), TO_DATE('2020-09-14', 'YYYY-MM-DD'), 'Úraz', 2);
-- pokus o vlozeni dalsi smrti kocky vede k chybe
--INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (5, TO_DATE('2020-09-14', 'YYYY-MM-DD'), TO_DATE('2021-09-14', 'YYYY-MM-DD'), 'Úraz', 2);



-- kontrola, zda je datum narozeni pred datem smrti
CREATE OR REPLACE TRIGGER trg_narozeni_pred_smrti BEFORE INSERT ON Smrt
    FOR EACH ROW
    DECLARE
        last_death_date DATE;
    BEGIN
        SELECT MAX(datum_smrti) INTO last_death_date FROM Smrt WHERE ID_kocky = :NEW.ID_kocky;

        -- kocka se ihned ozivi po umrti - datum narozeni musi byt stejne jako datum posledni smrti
        IF last_death_date IS NOT NULL AND last_death_date != :NEW.datum_narozeni THEN
            RAISE_APPLICATION_ERROR(-20002, 'Nove datum narozeni musi byt ihned po posledni smrti.');
        END IF;

        -- datum smrti musi byt vetsi nez datum narozeni
        IF :NEW.datum_narozeni > :NEW.datum_smrti THEN
            RAISE_APPLICATION_ERROR(-20003, 'Datum smrti musi byt pozdejsi nez datum narozeni v danem zaznamu.');
        END IF;
    END;
/

INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (6, TO_DATE('2021-09-15', 'YYYY-MM-DD'), TO_DATE('2022-09-14', 'YYYY-MM-DD'), 'Úraz', 2);
-- kocka se ihned ozivila
INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (6, TO_DATE('2022-09-14', 'YYYY-MM-DD'), TO_DATE('2023-09-14', 'YYYY-MM-DD'), 'Úraz', 2);

-- ERROR kocka se ihned neozivila
--INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (6, TO_DATE('2023-09-16', 'YYYY-MM-DD'), TO_DATE('2023-10-14', 'YYYY-MM-DD'), 'Úraz', 2);
-- ERROR kocka se narodila pred posledni smrti
--INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (6, TO_DATE('2022-09-14', 'YYYY-MM-DD'), TO_DATE('2023-12-14', 'YYYY-MM-DD'), 'Úraz', 2);
-- ERROR kocka ma drivejsi datum smrti nez narozeni
--INSERT INTO Smrt (ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (6, TO_DATE('2023-09-14', 'YYYY-MM-DD'), TO_DATE('2022-12-14', 'YYYY-MM-DD'), 'Úraz', 2);



-- procedura, ktera pro daneho hostitele zkontroluje, zda slouzi nejake kocce, pokud ne, prideli mu kocku, ktera ma nejmene hostitelu
CREATE OR REPLACE PROCEDURE prideleni_kocky (p_ID_hostitele Hostitel.ID_hostitele%TYPE) IS
        v_ID_kocky Kocka.ID_kocky%TYPE;
        v_max_ID_hostitele Hostitel.ID_hostitele%TYPE;
        invalid_ID EXCEPTION;
    BEGIN
        SELECT MAX(ID_hostitele) INTO v_max_ID_hostitele FROM Hostitel;

        IF p_ID_hostitele IS NULL OR p_ID_hostitele < 1 OR p_ID_hostitele > v_max_ID_hostitele THEN
            RAISE invalid_ID;
        END IF;

        SELECT ID_kocky INTO v_ID_kocky FROM Hostitel WHERE ID_hostitele = p_ID_hostitele;
        -- pokud je NULL, hostitel aktualne neslouzi zadne kocce, pridel mu kocku s nejmensim poctem hostitelu
        IF v_ID_kocky IS NULL THEN
            SELECT ID_kocky INTO v_ID_kocky
            FROM (
                SELECT ID_kocky, COUNT(ID_hostitele) AS pocet_hostitelu
                FROM Hostitel GROUP BY ID_kocky ORDER BY pocet_hostitelu ASC
            ) WHERE ROWNUM = 1; -- vyber kocku s nejmensim poctem hostitelu
            UPDATE Hostitel SET ID_kocky = v_ID_kocky WHERE ID_hostitele = p_ID_hostitele;
        END IF;

        EXCEPTION
            WHEN invalid_ID THEN
                DBMS_OUTPUT.PUT_LINE('Procedura nedostala validni ID hostitele.');
    END;
/

UPDATE Hostitel SET ID_kocky = NULL WHERE ID_hostitele = 6;
BEGIN
    prideleni_kocky(6); -- hostiteli 6 zemrela kocka
    prideleni_kocky(7); -- hostitel 7 jiz slouzi kocce, nic se nestane
    prideleni_kocky(-1); -- nevalidni ID
    prideleni_kocky(999); -- nevalidni ID
END;
/



-- udrzba hesel, procedura pro pravidelnou zmenu vsech hesel tajnych teritorii
CREATE OR REPLACE PROCEDURE udrzba_hesel IS
    -- pouze tajna teritoria
    CURSOR tajna_teritoria IS
        SELECT ID_teritoria FROM Teritorium WHERE heslo IS NOT NULL;

    new_password VARCHAR2(10);
    BEGIN
        FOR rec IN tajna_teritoria LOOP
            -- generuj nove nahodne heslo
            SELECT DBMS_RANDOM.STRING('x', 10) INTO new_password FROM dual;
            UPDATE Teritorium SET heslo = new_password WHERE ID_teritoria = rec.ID_teritoria;
        END LOOP;
        COMMIT;
    END;
/

BEGIN
    udrzba_hesel;
END;
/


-- projdi vsechny hracky a pokud nejaka hracka ma cenu NULL, pravdepodobne je kradena
CREATE OR REPLACE PROCEDURE ukradene_hracky IS
    v_ID_hracky Hracka.ID_hracky%TYPE;

    BEGIN
        FOR rec IN (SELECT ID_hracky FROM Hracka WHERE cena IS NULL) LOOP
            SELECT ID_hracky INTO v_ID_hracky FROM Hracka WHERE ID_hracky = rec.ID_hracky;
            DBMS_OUTPUT.PUT_LINE('Hracka s ID ' || v_ID_hracky || ' je pravdepodobne kradena, nebylo za ni nic zaplaceno.');
        END LOOP;
END;
/

UPDATE Hracka SET cena = NULL WHERE ID_hracky = 1;
UPDATE Hracka SET cena = NULL WHERE ID_hracky = 2;
BEGIN
    ukradene_hracky;
END;


--DROP INDEX idx_smrt_id_teritoria;

EXPLAIN PLAN FOR
-- najdi pocet smrti kocek v jednotlivych teritoriich
SELECT nazev, COUNT(ID_kocky) AS pocet_smrti FROM Smrt NATURAL JOIN Teritorium GROUP BY nazev;
SELECT * FROM table(DBMS_XPLAN.DISPLAY);

-- index na ID_teritoria jako FK v tabulce Smrti pro rychlejsi vyhledavani
CREATE INDEX idx_smrt_id_teritoria ON Smrt(ID_teritoria);

EXPLAIN PLAN FOR
SELECT nazev, COUNT(ID_kocky) AS pocet_smrti FROM Smrt NATURAL JOIN Teritorium GROUP BY nazev;
SELECT * FROM table(DBMS_XPLAN.DISPLAY);

-- uklid
REVOKE ALL ON Smrt FROM xeffen00;
REVOKE ALL ON Teritorium FROM xeffen00;
DROP MATERIALIZED VIEW mv_smrti_v_teritoriich;
DELETE FROM Smrt WHERE ID_kocky = 7;

-- prideleni prava na select
GRANT SELECT ON Smrt TO xeffen00;
GRANT SELECT ON Teritorium TO xeffen00;

-- materializovany pohled na pocet smrti kocek v jednotlivych teritoriich
CREATE MATERIALIZED VIEW mv_smrti_v_teritoriich REFRESH ON DEMAND AS
SELECT nazev, COUNT(ID_kocky) AS pocet_smrti FROM Smrt NATURAL JOIN Teritorium GROUP BY nazev;
-- prideleni prava na materializovany pohled
GRANT ALL ON Smrt TO xeffen00;
GRANT ALL ON mv_smrti_v_teritoriich TO xeffen00;
SELECT * FROM mv_smrti_v_teritoriich;
-- pridani nove smrti
INSERT INTO Smrt(ID_kocky, datum_narozeni, datum_smrti, zpusob_smrti, ID_teritoria) VALUES (7, TO_DATE('2021-09-15', 'YYYY-MM-DD'), TO_DATE('2022-09-14', 'YYYY-MM-DD'), 'Omylem', 6);
BEGIN
    DBMS_MVIEW.REFRESH('mv_smrti_v_teritoriich'); -- aktualizace materializovaneho pohledu
END;
-- materializovany pohled byl aktualizovan
SELECT * FROM mv_smrti_v_teritoriich;


-- zjisti kolik smrti zaznamenala ktera rasa a prirad jim status podle poctu smrti
WITH status_rasy_smrti AS (
    SELECT rasa, COUNT(*) AS pocet_smrti FROM Kocka NATURAL JOIN Smrt
    GROUP BY rasa
)
SELECT rasa, pocet_smrti,
    CASE
        WHEN pocet_smrti < 4 THEN 'ještě málo smrtí'
        WHEN pocet_smrti = 9 THEN 'mrtvá mrtvá'
        WHEN pocet_smrti > 4 THEN 'už hodně smrtí'
        ELSE 'zatím středně smrtí'
    END AS status
FROM status_rasy_smrti
ORDER BY rasa, pocet_smrti;

