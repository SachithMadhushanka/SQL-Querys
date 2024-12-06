--Imbalance Between Qty and Stock
--i.	Mahabage’s Qty are growing much faster than its stock replenishment rate, indicating a supply chain issue.
--ii.	Elpitiya’s Qty are growing much faster than its stock replenishment rate
--iii.	Rajagiriya’s Qty are growing much faster than its stock replenishment rate
WITH SalesAndStockData AS (
    SELECT
        product.ProductCode,
        product.ProductName,
        department.DepartmentName,
        SUM(CASE WHEN sales.LocationID = 1 THEN sales.Qty ELSE 0 END) AS MahabageQty,
        SUM(CASE WHEN sales.LocationID = 6 THEN sales.Qty ELSE 0 END) AS ElpitiyaQty,
        SUM(CASE WHEN sales.LocationID = 7 THEN sales.Qty ELSE 0 END) AS RajagiriyaQty,
        SUM(CASE WHEN stock.LocationID = 1 THEN stock.Stock ELSE 0 END) AS MahabageStock,
        SUM(CASE WHEN stock.LocationID = 6 THEN stock.Stock ELSE 0 END) AS ElpitiyaStock,
        SUM(CASE WHEN stock.LocationID = 7 THEN stock.Stock ELSE 0 END) AS RajagiriyaStock
    FROM
        dbo.InvProductMaster product
    INNER JOIN
        dbo.InvSales sales ON product.InvProductMasterID = sales.ProductID
    INNER JOIN
        dbo.InvProductStockMaster stock ON product.InvProductMasterID = stock.ProductID
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
ImbalanceData AS (
    SELECT
        ProductCode,
        ProductName,
        DepartmentName,
        MahabageQty,
        ElpitiyaQty,
        RajagiriyaQty,
        MahabageStock,
        ElpitiyaStock,
        RajagiriyaStock,
        CASE
            WHEN MahabageQty > (2 * MahabageStock) THEN 'Mahabage: Fast Sales Growth'
            WHEN ElpitiyaQty > (2 * ElpitiyaStock) THEN 'Elpitiya: Fast Sales Growth'
            WHEN RajagiriyaQty > (2 * RajagiriyaStock) THEN 'Rajagiriya: Fast Sales Growth'
            ELSE 'No Significant Imbalance'
        END AS ImbalanceIndicator
    FROM
        SalesAndStockData
)
SELECT 
    ProductCode,
    ProductName,
    DepartmentName,
    MahabageQty,
    MahabageStock,
    ElpitiyaQty,
    ElpitiyaStock,
    RajagiriyaQty,
    RajagiriyaStock,
    ImbalanceIndicator
FROM ImbalanceData
ORDER BY ProductCode;
