
CREATE TABLE Bil (
    bil_id SERIAL PRIMARY KEY,
    registreringsnummer VARCHAR(20) UNIQUE,
    navn VARCHAR(100) NOT NULL,
    adresse VARCHAR(100),
    epost VARCHAR(100)
);

CREATE TABLE Passering (
    passering_id SERIAL PRIMARY KEY,
    bil_id INTEGER,
    tidspunkt TIMESTAMP NOT NULL,
    bomstasjon VARCHAR(100) NOT NULL,
    CONSTRAING fk_bil
        FOREIGN KEY (bil_id)
        REFRENCES Bil(bil_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);



INSERT INTO Bil (
    registreringsnummer, navn, adresse, epost) 
VALUES
('TV90080', 'Arild Fosse', 'Det store huset', 'arild@test.no'),
('TV80420', 'Svein Fosse', 'Det lille huset', 'Svein@test.no');


ALTER TABLE Bil
DROP COLUMN telefonnummer;




