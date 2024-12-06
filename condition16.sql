--Excess Stock at All Locations :- All locations have excess stock, which might lead to higher holding costs
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
        dbo.InvProductStockMaster stock ON product.InvProductMasterID = stock.ProductID
    INNER JOIN
        dbo.InvDepartment department ON product.DepartmentID = department.InvDepartmentID
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
        WHEN MahabageStock > 100 AND ElpitiyaStock > 100 AND RajagiriyaStock > 100 THEN 'Excess Stock at All Locations'
        ELSE NULL
    END AS ExcessStockStatus
FROM
    StockData
WHERE
    MahabageStock > 100 AND ElpitiyaStock > 100 AND RajagiriyaStock > 100
ORDER BY
    ProductCode;
