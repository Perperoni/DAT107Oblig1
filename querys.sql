-- A
CREATE TABLE person (
    personnummer CHAR(11) PRIMARY KEY NOT NULL,
    fornavn VARCHAR(100) NOT NULL,
    etternavn VARCHAR(100) NOT NULL,
    navn VARCHAR(200) GENERATED ALWAYS AS ( fornavn || etternavn ::text )STORED,
    epost VARCHAR(100),
    adresse VARCHAR(100),
    telefonnummer CHAR(8)
);

CREATE TABLE bil (
    registreringsbokstav CHAR(2) NOT NULL,
    registreringstall INTEGER NOT NULL,
    regnr CHAR(7) GENERATED ALWAYS AS (registreringsbokstav || registreringstall::text) STORED UNIQUE,
    skiltnummer VARCHAR(7), -- NULL betyr avskilta
    merke VARCHAR(50),
    modell VARCHAR(50),
    eigar_id CHAR(11) NOT NULL,

    PRIMARY KEY (regnr),
    CONSTRAINT ch_mellom CHECK (registreringstall BETWEEN 10000 AND 99999),
    CONSTRAINT ch_upper CHECK (registreringsbokstav ~ '^[A-Z]{2}$'),
    CONSTRAINT ch_lovlige_bokstavar CHECK (registreringsbokstav !~ '[GIMOQW]'),
    CONSTRAINT fk_eigar FOREIGN KEY (eigar_id) REFERENCES person(personnummer) ON UPDATE CASCADE
);

CREATE TABLE Passering (
    passering_id SERIAL PRIMARY KEY,
    skiltnummer VARCHAR(15),
    tidspunkt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    bompengebod VARCHAR(50) NOT NULL,
    regnrfk CHAR(7),
    CONSTRAINT fk_regnr FOREIGN KEY (regnrfk) REFERENCES bil(regnr)
);

-- B
INSERT INTO person VALUES
('12345678901','Ola','Nordmann',DEFAULT,'ola@mail.no'),
('10987654321','Kari','Nordmann',DEFAULT,'kari@mail.no');


INSERT INTO bil (registreringsbokstav, registreringstall, merke, modell, eigar_id)
VALUES
('AA',10000,'Toyota','Corolla','12345678901'),
('BB',20000,'Tesla','Model 3','10987654321');


INSERT INTO passering (regnr, bomstasjon)
VALUES
('AA10000','Bergen Nord'),
('AA10000','Bergen Sør'),
('BB20000','Bergen Nord'),
(NULL,'Bergen Sør'); -- skilt kunne ikkje lesast

-- C
ALTER TABLE person
DROP COLUMN telefonnummer;

-- E
SELECT
    p.passering_id,
    p.tidspunkt,
    p.bomstasjon,
    b.regnr,
    per.navn,
    per.epost
FROM passering p
LEFT JOIN bil b ON p.regnr = b.regnr
LEFT JOIN person per ON b.eigar_id = per.personnummer
ORDER BY p.tidspunkt;

-- F
SELECT
    p.passering_id,
    p.tidspunkt,
    p.bomstasjon,
    b.regnr,
    per.navn,
    per.epost
FROM passering p
JOIN bil b ON p.regnr = b.regnr
JOIN person per ON b.eigar_id = per.personnummer
ORDER BY p.tidspunkt;

-- H
SELECT regnr, COUNT(*) AS antall_passeringar
FROM passering
WHERE regnr IS NOT NULL
GROUP BY regnr;

-- I
SELECT *
FROM passering
WHERE regnr = 'AA10000'
ORDER BY tidspunkt DESC
LIMIT 1;

-- J
SELECT COUNT(*) AS antall_ukjente_passeringar
FROM passering
WHERE regnr IS NULL;

-- L 
CREATE TABLE bomstasjon (
    bom_id SERIAL PRIMARY KEY,
    navn VARCHAR(50),
    plassering VARCHAR(100)
);
