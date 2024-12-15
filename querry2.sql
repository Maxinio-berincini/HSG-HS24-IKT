SELECT q."QuartalID",
       SUM(p."ErzeugteMengeKWh") AS "GesamtErzeugungKWh"
FROM "Quartalsperioden" q
         JOIN "Abrechnungsperioden" ab
              ON ab."Startdatum" >= q."Startdatum"
                  AND ab."Enddatum" <= q."Enddatum"
         JOIN "Produktion" p ON p."AbrechnungsID" = ab."AbrechnungsID"
GROUP BY q."QuartalID"
ORDER BY q."QuartalID";
