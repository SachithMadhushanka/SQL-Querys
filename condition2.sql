--If any one of the three locations has no stock 
WITH StockData AS (
    SELECT
        product.ProductCode,
        product.ProductName,
        department.DepartmentName,
        SUM(CASE WHEN stock.LocationID = 1 THEN CAST(stock.Stock AS INT) ELSE 0 END) AS MahabageStock,
        SUM(CASE WHEN stock.LocationID = 6 THEN CAST(stock.Stock AS INT) ELSE 0 END) AS ElpitiyaStock,
        SUM(CASE WHEN stock.LocationID = 7 THEN CAST(stock.Stock AS INT) ELSE 0 END) AS RajagiriyaStock
    FROM
        dbo.InvProductMaster product
    INNER JOIN
        dbo.InvProductStockMaster stock ON product.InvProductMasterID = stock.ProductID
    INNER JOIN
        dbo.InvDepartment department ON product.DepartmentID = department.InvDepartmentID
    WHERE
        1=1
        [[ AND product.ProductCode = {{ProductCode}} ]]
        [[ AND LOWER(product.ProductName) LIKE LOWER('%' + {{ProductName}} + '%') ]]
        [[ AND department.DepartmentName = {{DepartmentName}} ]]
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
    RajagiriyaStock
FROM
    StockData
WHERE
    MahabageStock = 0
    OR ElpitiyaStock = 0
    OR RajagiriyaStock = 0
ORDER BY ProductCode;
