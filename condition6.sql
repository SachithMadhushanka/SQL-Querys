--All Sales Are Zero
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
),
SalesData AS (
    SELECT
        sales.ProductCode,
        sales.ProductName,
        sales.SupplierName,
        sales.CategoryName,
        department.DepartmentName,
        SUM(CASE WHEN sales.LocationID = 1 THEN sales.NetAmount ELSE 0 END) AS MahabageSales,
        SUM(CASE WHEN sales.LocationID = 6 THEN sales.NetAmount ELSE 0 END) AS ElpitiyaSales,
        SUM(CASE WHEN sales.LocationID = 7 THEN sales.NetAmount ELSE 0 END) AS RajagiriyaSales
    FROM
        dbo.InvSales sales
    INNER JOIN
        dbo.InvProductMaster product ON sales.ProductID = product.InvProductMasterID
    INNER JOIN
        dbo.InvDepartment department ON product.DepartmentID = department.InvDepartmentID
    WHERE
        sales.DocumentDate >= DATEADD(day, -{{NumberOfDays}}, CAST(GETDATE() AS date))
        AND sales.DocumentDate < CAST(GETDATE() AS date)
        [[ AND sales.ProductCode = {{ProductCode}} ]]
        [[ AND LOWER(sales.ProductName) LIKE LOWER('%' + {{ProductName}} + '%') ]]
        [[ AND sales.CategoryName = {{CategoryName}} ]]
        [[ AND department.DepartmentName = {{DepartmentName}} ]]
        [[ AND sales.SupplierName = {{SupplierName}} ]]
    GROUP BY
        sales.ProductCode,
        sales.ProductName,
        sales.SupplierName,
        sales.CategoryName,
        department.DepartmentName
)
SELECT 
    s.ProductCode,
    s.ProductName,
    sd.SupplierName,
    s.DepartmentName,
    sd.CategoryName,
    COALESCE(sd.MahabageSales, 0) AS MahabageSales,
    COALESCE(sd.ElpitiyaSales, 0) AS ElpitiyaSales,
    COALESCE(sd.RajagiriyaSales, 0) AS RajagiriyaSales
FROM 
    StockData s
INNER JOIN 
    SalesData sd ON s.ProductCode = sd.ProductCode AND s.DepartmentName = sd.DepartmentName
WHERE 
    COALESCE(sd.MahabageSales, 0) = 0 
    AND COALESCE(sd.ElpitiyaSales, 0) = 0 
    AND COALESCE(sd.RajagiriyaSales, 0) = 0
ORDER BY 
    s.ProductCode;
