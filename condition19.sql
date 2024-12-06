SELECT
  "source"."InvProductMaster - InvProductMasterID_ProductName" AS "InvProductMaster - InvProductMasterID_ProductName",
  "source"."ColorSizeCode" AS "ColorSizeCode",
  "source"."ColorSizeName" AS "ColorSizeName",
  "source"."InvProductMaster - InvProductMasterID_ProductCode" AS "InvProductMaster - InvProductMasterID_ProductCode",
  "source"."Location" AS "Location",
  SUM(
    "source"."InvProductColorSizeStockMaster - InvProductColorSiz_d9414ce4"
) AS "sum"
FROM
  (
    SELECT
      "dbo"."InvProductColorSize"."InvProductColorSizeID" AS "InvProductColorSizeID",
      "dbo"."InvProductColorSize"."InvProductMasterID" AS "InvProductMasterID",
      "dbo"."InvProductColorSize"."ColorSizeCode" AS "ColorSizeCode",
      "dbo"."InvProductColorSize"."ColorSizeName" AS "ColorSizeName",
      CASE
        WHEN "InvProductColorSizeStockMaster - InvProductColorSizeID"."LocationID" = 1 THEN 'Mahabage'
        WHEN "InvProductColorSizeStockMaster - InvProductColorSizeID"."LocationID" = 6 THEN 'Elpitiya'
        WHEN "InvProductColorSizeStockMaster - InvProductColorSizeID"."LocationID" = 7 THEN 'Rajagiriya'
      END AS "Location",
      "InvProductColorSizeStockMaster - InvProductColorSizeID"."Stock" AS "InvProductColorSizeStockMaster - InvProductColorSiz_d9414ce4",
      "InvProductMaster - InvProductMasterID"."ProductName" AS "InvProductMaster - InvProductMasterID__ProductName",
      "InvProductMaster - InvProductMasterID"."ProductCode" AS "InvProductMaster - InvProductMasterID__ProductCode",
      "InvProductColorSizeStockMaster - InvProductColorSizeID"."LocationID" AS "InvProductColorSizeStockMaster - InvProductColorSiz_c4b23f41",
      "InvProductMaster - InvProductMasterID"."InvProductMasterID" AS "InvProductMaster - InvProductMasterID__InvProductMasterID",
      "InvProductColorSizeStockMaster - InvProductColorSizeID"."InvProductColorSizeID" AS "InvProductColorSizeStockMaster - InvProductColorSiz_19ae45db"
    FROM
      "dbo"."InvProductColorSize"
     
LEFT JOIN "dbo"."InvProductMaster" AS "InvProductMaster - InvProductMasterID" ON "dbo"."InvProductColorSize"."InvProductMasterID" = "InvProductMaster - InvProductMasterID"."InvProductMasterID"
      LEFT JOIN "dbo"."InvProductColorSizeStockMaster" AS "InvProductColorSizeStockMaster - InvProductColorSizeID" ON "dbo"."InvProductColorSize"."InvProductColorSizeID" = "InvProductColorSizeStockMaster - InvProductColorSizeID"."InvProductColorSizeID"
   
WHERE
      (
        "InvProductColorSizeStockMaster - InvProductColorSizeID"."LocationID" = 1
      )
     
    OR (
        "InvProductColorSizeStockMaster - InvProductColorSizeID"."LocationID" = 6
      )
      OR (
        "InvProductColorSizeStockMaster - InvProductColorSizeID"."LocationID" = 7
      )
  ) AS "source"
GROUP BY
  "source"."InvProductMaster - InvProductMasterID__ProductName",
  "source"."ColorSizeCode",
  "source"."ColorSizeName",
  "source"."InvProductMaster - InvProductMasterID__ProductCode",
  "source"."Location"
ORDER BY
  "source"."InvProductMaster - InvProductMasterID__ProductName" ASC,
  "source"."ColorSizeCode" ASC,
  "source"."ColorSizeName" ASC,
  "source"."InvProductMaster - InvProductMasterID__ProductCode" ASC,
  "source"."Location" ASC