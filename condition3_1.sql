--If Mahabage’s qtys are higher than Elpitiya’s or Rajagiriya’s qtys, and Mahabage’s stock is less than Elpitiya’s or Rajagiriya’s stock.
WITH SalesAndStockData AS (
    SELECT
        product.ProductCode,
        product.ProductName,
        department.DepartmentName,
        SUM(CASE WHEN stock.LocationID = 1 THEN stock.Stock ELSE 0 END) AS MahabageStock,
        SUM(CASE WHEN stock.LocationID = 6 THEN stock.Stock ELSE 0 END) AS ElpitiyaStock,
        SUM(CASE WHEN stock.LocationID = 7 THEN stock.Stock ELSE 0 END) AS RajagiriyaStock,
        SUM(CASE WHEN sales.LocationID = 1 THEN sales.Qty ELSE 0 END) AS MahabageQty,
        SUM(CASE WHEN sales.LocationID = 6 THEN sales.Qty ELSE 0 END) AS ElpitiyaQty,
        SUM(CASE WHEN sales.LocationID = 7 THEN sales.Qty ELSE 0 END) AS RajagiriyaQty
    FROM
        dbo.InvProductMaster product
    INNER JOIN
        dbo.InvProductStockMaster stock ON product.InvProductMasterID = stock.ProductID
    INNER JOIN
        dbo.InvSales sales ON product.InvProductMasterID = sales.ProductID
    INNER JOIN
        dbo.InvDepartment department ON product.DepartmentID = department.InvDepartmentID
    WHERE
        sales.DocumentDate >= DATEADD(day, -30, CAST(GETDATE() AS date))
        AND sales.DocumentDate < CAST(GETDATE() AS date)
    GROUP BY
        product.ProductCode,
        product.ProductName,
        department.DepartmentName
)
SELECT *
FROM SalesAndStockData
WHERE 
    (MahabageQty > ElpitiyaQty OR MahabageQty > RajagiriyaQty)
    AND (MahabageStock < ElpitiyaStock OR MahabageStock < RajagiriyaStock)
ORDER BY ProductCode;
