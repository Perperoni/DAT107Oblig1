
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
    CONSTRAINT fk_eigar FOREIGN KEY (eigar_id) REFERENCES person(personnummer)
);

CREATE TABLE Passering (
    passering_id SERIAL PRIMARY KEY,
    skiltnummer VARCHAR(15),
    tidspunkt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    bompengebod VARCHAR(50) NOT NULL
);