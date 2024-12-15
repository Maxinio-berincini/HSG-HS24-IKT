INSERT INTO "Eigentümer" ("Name", "Adresse")
VALUES ('Johannes Schöning', 'Torstrasse 25'),
       ('Marcel Cahenzli', 'Rosenbergstrasse 30'),
       ('Manuel Ammann', 'Dufourstrasse 50'),
       ('Max Mustermann', 'Square'),
       ('Nico M.', 'SHSG Haus');

INSERT INTO "Dachflächen" ("Grösse", "Neigung", "Ausrichtung", "EigentümerID")
VALUES (100.0, 30.0, 'Süd', 1),
       (80.5, 25.0, 'West', 2),
       (120.0, 35.0, 'Ost', 3),
       (60.0, 20.0, 'Südwest', 4),
       (150.0, 15.0, 'Südost', 5);

INSERT INTO "PV-Anlagen" ("DachID", "Kapazität", "Ertrag", "Einspeisevergütung")
VALUES (1, 10.0, 9500.0, 0.50),
       (2, 8.0, 7600.0, 0.50),
       (3, 12.5, 11000.0, 0.50),
       (4, 5.0, 4200.0, 0.50),
       (5, 15.0, 13000.0, 0.50);

INSERT INTO "Verträge" ("DachID", "EigentümerID", "Startdatum", "Laufzeit", "Strompreis", "Mietpreis_Pro_Quartal")
VALUES (1, 1, '2024-01-01', 24, 0.28, 500),
       (2, 2, '2024-02-01', 36, 0.27, 400),
       (3, 3, '2024-01-01', 48, 0.30, 600),
       (4, 4, '2024-04-01', 12, 0.25, 300),
       (5, 5, '2024-01-01', 60, 0.26, 700);

INSERT INTO "Abrechnungsperioden" ("Startdatum", "Enddatum")
VALUES ('2024-01-01', '2024-01-31'),
       ('2024-02-01', '2024-02-29'),
       ('2024-03-01', '2024-03-31'),
       ('2024-04-01', '2024-04-30'),
       ('2024-05-01', '2024-05-31'),
       ('2024-06-01', '2024-06-30');

INSERT INTO "Produktion" ("AnlagenID", "AbrechnungsID", "ErzeugteMengeKWh")
VALUES
-- Q1
(1, 1, 800.5),
(2, 1, 600.0),
(3, 2, 900.0),
(4, 3, 350.0),
(5, 3, 1200.0),

-- Q2
(1, 4, 820.0),
(2, 4, 610.0),
(3, 5, 950.0),
(4, 6, 370.0),
(5, 6, 1250.0);

INSERT INTO "Verbrauch" ("EigentümerID", "AbrechnungsID", "VerbrauchteMengeKWh")
VALUES
-- Q1
(1, 1, 300.0),
(2, 1, 400.0),
(3, 2, 250.0),
(4, 3, 200.0),
(5, 3, 500.0),

-- Q2
(1, 4, 320.0),
(2, 4, 410.0),
(3, 5, 260.0),
(4, 6, 220.0),
(5, 6, 520.0);

INSERT INTO "Quartalsperioden" ("Startdatum", "Enddatum")
VALUES ('2024-01-01', '2024-03-31'),
       ('2024-04-01', '2024-06-30'),
       ('2024-07-01', '2024-09-30'),
       ('2024-10-01', '2024-12-31'),
       ('2025-01-01', '2025-03-31');