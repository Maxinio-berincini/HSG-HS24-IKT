CREATE TABLE "Eigentümer"
(
    "EigentümerID" BIGSERIAL PRIMARY KEY,
    "Name"         VARCHAR(255),
    "Adresse"      VARCHAR(255)
);

CREATE TABLE "Dachflächen"
(
    "DachID"       BIGSERIAL PRIMARY KEY,
    "Grösse"       NUMERIC,
    "Neigung"      NUMERIC,
    "Ausrichtung"  VARCHAR(50),
    "EigentümerID" INT REFERENCES "Eigentümer" ("EigentümerID")
);

CREATE TABLE "PV-Anlagen"
(
    "AnlagenID"          BIGSERIAL PRIMARY KEY,
    "DachID"             INT REFERENCES "Dachflächen" ("DachID"),
    "Kapazität"          NUMERIC,
    "Ertrag"             NUMERIC,
    "Einspeisevergütung" NUMERIC
);

CREATE TABLE "Verträge"
(
    "VertragsID"            BIGSERIAL PRIMARY KEY,
    "DachID"                INT REFERENCES "Dachflächen" ("DachID"),
    "EigentümerID"          INT REFERENCES "Eigentümer" ("EigentümerID"),
    "Startdatum"            DATE,
    "Laufzeit"              INT,
    "Strompreis"            NUMERIC,
    "Mietpreis_Pro_Quartal" NUMERIC
);


CREATE TABLE "Abrechnungsperioden"
(
    "AbrechnungsID" BIGSERIAL PRIMARY KEY,
    "Startdatum"    DATE NOT NULL,
    "Enddatum"      DATE NOT NULL
);

CREATE TABLE "Produktion"
(
    "ProduktionID"     BIGSERIAL PRIMARY KEY,
    "AnlagenID"        INT REFERENCES "PV-Anlagen" ("AnlagenID"),
    "AbrechnungsID"    INT REFERENCES "Abrechnungsperioden" ("AbrechnungsID"),
    "ErzeugteMengeKWh" NUMERIC
);

CREATE TABLE "Verbrauch"
(
    "VerbrauchID"         BIGSERIAL PRIMARY KEY,
    "EigentümerID"        INT REFERENCES "Eigentümer" ("EigentümerID"),
    "AbrechnungsID"       INT REFERENCES "Abrechnungsperioden" ("AbrechnungsID"),
    "VerbrauchteMengeKWh" NUMERIC
);

CREATE TABLE "Quartalsperioden"
(
    "QuartalID"  BIGSERIAL PRIMARY KEY,
    "Startdatum" DATE NOT NULL,
    "Enddatum"   DATE NOT NULL
);