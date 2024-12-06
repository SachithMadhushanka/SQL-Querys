--All Locations Having No Stock
WITH StockData AS (
    SELECT
        product.ProductCode,
        product.ProductName,
        department.DepartmentName,
        SUM(CASE WHEN stock.LocationID = 1 THEN stock.Stock ELSE 0 END) AS MahabageStock,
        SUM(CASE WHEN stock.LocationID = 6 THEN stock.Stock ELSE 0 END) AS ElpitiyaStock,
        SUM(CASE WHEN stock.LocationID = 7 THEN stock.Stock ELSE 0 END) AS RajagiriyaStock
    FROM
        dbo.InvProductMaster product
    INNER JOIN
        dbo.InvProductStockMaster stock 
        ON product.InvProductMasterID = stock.ProductID
    INNER JOIN
        dbo.InvDepartment department 
        ON product.DepartmentID = department.InvDepartmentID
    GROUP BY
        product.ProductCode,
        product.ProductName,
        department.DepartmentName
)
SELECT
    ProductCode,
    ProductName,
    DepartmentName,
    MahabageStock,
    ElpitiyaStock,
    RajagiriyaStock,
    CASE
        WHEN MahabageStock = 0 AND ElpitiyaStock = 0 AND RajagiriyaStock = 0 THEN 'No Stock at All Locations'
        ELSE 'Stock Available at One or More Locations'
    END AS StockStatus
FROM
    StockData
WHERE
    MahabageStock = 0 AND ElpitiyaStock = 0 AND RajagiriyaStock = 0
ORDER BY
    ProductCode;
