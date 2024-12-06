--Stock and Qty Match :- Stock and Qty are perfectly balanced at all locations, indicating optimal stock management
WITH StockAndQtyData AS (
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
        sales.DocumentDate >= DATEADD(day, -{{NumberOfDays}}, CAST(GETDATE() AS date))
        AND sales.DocumentDate < CAST(GETDATE() AS date)
    GROUP BY
        product.ProductCode,
        product.ProductName,
        department.DepartmentName
),
BalancedData AS (
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
            WHEN 
                MahabageStock = MahabageQty AND 
                ElpitiyaStock = ElpitiyaQty AND 
                RajagiriyaStock = RajagiriyaQty THEN 1
            ELSE 0
        END AS PerfectlyBalanced
    FROM
        StockAndQtyData
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
    PerfectlyBalanced
FROM BalancedData
WHERE PerfectlyBalanced = 1
ORDER BY ProductCode;
