--All Locations Have Low Stock:- All locations have low stock levels, indicating a potential risk of stockouts.
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
    s.ProductCode,
    s.ProductName,
    s.DepartmentName,
    s.MahabageStock,
    s.ElpitiyaStock,
    s.RajagiriyaStock
FROM 
    StockData s
WHERE 
    s.MahabageStock < 10 AND s.ElpitiyaStock < 10 AND s.RajagiriyaStock < 10
ORDER BY 
    s.ProductCode;
