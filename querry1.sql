SELECT v."VertragsID",
       SUM(vb."VerbrauchteMengeKWh")                    AS "GesamtVerbrauchKWh",
       (SUM(vb."VerbrauchteMengeKWh") * v."Strompreis") AS Gesamtkosten
FROM "Verträge" v
         JOIN "Verbrauch" vb ON vb."EigentümerID" = v."EigentümerID"
GROUP BY v."VertragsID", v."Strompreis";
