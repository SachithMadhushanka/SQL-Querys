--Critical Stock Levels with High Demand
--i.	Mahabage’s stock is critically low, despite high Qty demand, necessitating immediate restocking.
--ii.	Elpitiya’s stock is critically low, despite high Qty demand, necessitating immediate restocking.
--iii.	Rajagiriya’s stock is critically low, despite high Qty demand, necessitating immediate restocking.
WITH StockAndDemand AS (
    SELECT
        product.ProductCode,
        product.ProductName,
        department.DepartmentName,
        SUM(CASE WHEN stock.LocationID = 1 THEN stock.Stock ELSE 0 END) AS MahabageStock,
        SUM(CASE WHEN sales.LocationID = 1 THEN sales.Qty ELSE 0 END) AS MahabageQty,
        SUM(CASE WHEN stock.LocationID = 6 THEN stock.Stock ELSE 0 END) AS ElpitiyaStock,
        SUM(CASE WHEN sales.LocationID = 6 THEN sales.Qty ELSE 0 END) AS ElpitiyaQty,
        SUM(CASE WHEN stock.LocationID = 7 THEN stock.Stock ELSE 0 END) AS RajagiriyaStock,
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
        sales.DocumentDate >= DATEADD(day, -{{NumberOfDays}}, CAST(GETDATE() AS date))
        AND sales.DocumentDate < CAST(GETDATE() AS date)
    GROUP BY
        product.ProductCode,
        product.ProductName,
        department.DepartmentName
),
CriticalStock AS (
    SELECT
        ProductCode,
        ProductName,
        DepartmentName,
        MahabageStock,
        MahabageQty,
        ElpitiyaStock,
        ElpitiyaQty,
        RajagiriyaStock,
        RajagiriyaQty,
        CASE
            WHEN MahabageStock < 10 AND MahabageQty > 50 THEN 'Mahabage'
            WHEN ElpitiyaStock < 10 AND ElpitiyaQty > 50 THEN 'Elpitiya'
            WHEN RajagiriyaStock < 10 AND RajagiriyaQty > 50 THEN 'Rajagiriya'
            ELSE NULL
        END AS LocationNeedingRestock
    FROM
        StockAndDemand
)
SELECT 
    ProductCode,
    ProductName,
    DepartmentName,
    MahabageStock,
    MahabageQty,
    ElpitiyaStock,
    ElpitiyaQty,
    RajagiriyaStock,
    RajagiriyaQty,
    LocationNeedingRestock
FROM CriticalStock
WHERE LocationNeedingRestock IS NOT NULL
ORDER BY ProductCode;
