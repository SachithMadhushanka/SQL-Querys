--All Locations Have High Qty :- All locations are experiencing high sales, signaling good demand.
WITH SalesAndStockData AS (
    SELECT
        product.ProductCode,
        product.ProductName,
        department.DepartmentName,
        SUM(CASE WHEN sales.LocationID = 1 THEN sales.Qty ELSE 0 END) AS MahabageQty,
        SUM(CASE WHEN sales.LocationID = 6 THEN sales.Qty ELSE 0 END) AS ElpitiyaQty,
        SUM(CASE WHEN sales.LocationID = 7 THEN sales.Qty ELSE 0 END) AS RajagiriyaQty
    FROM
        dbo.InvProductMaster product
    INNER JOIN
        dbo.InvSales sales ON product.InvProductMasterID = sales.ProductID
    INNER JOIN
        dbo.InvDepartment department ON product.DepartmentID = department.InvDepartmentID
    WHERE
        sales.DocumentDate >= DATEADD(day, -{{NumberOfDays}}, CAST(GETDATE() AS date))
        AND sales.DocumentDate < CAST(GETDATE() AS date)
    GROUP BY
        product.ProductCode,
        product.ProductName,
        department.DepartmentName
)
SELECT *
FROM SalesAndStockData
WHERE 
    MahabageQty >= {{HighQtyThreshold}} 
    AND ElpitiyaQty >= {{HighQtyThreshold}} 
    AND RajagiriyaQty >= {{HighQtyThreshold}}
ORDER BY ProductCode;