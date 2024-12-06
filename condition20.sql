SELECT
  "source"."Location" AS "Location",
  "source"."ColorSizeName" AS "ColorSizeName",
  SUM("source"."Qty") AS "sum"
FROM
  (
    SELECT
      "dbo"."InvSales"."LocationCode" AS "LocationCode",
      "dbo"."InvSales"."Qty" AS "Qty",
      "dbo"."InvSales"."ColorSizeName" AS "ColorSizeName",
      CASE
        WHEN "dbo"."InvSales"."LocationCode" = 1 THEN 'Mahabage'
        WHEN "dbo"."InvSales"."LocationCode" = 6 THEN 'Elpitiya'
        WHEN "dbo"."InvSales"."LocationCode" = 7 THEN 'Rajagiriya'
      END AS "Location"
    FROM
      "dbo"."InvSales"
  ) AS "source"
GROUP BY
  "source"."Location",
  "source"."ColorSizeName"
ORDER BY
  "source"."Location" ASC,
  "source"."ColorSizeName" ASC