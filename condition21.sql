DECLARE @NumberOfDays INT = 30;  -- Set the NumberOfDays parameter value here

WITH StockData AS (
    SELECT
        product.ProductCode,
        product.ProductName,
        department.DepartmentName,
        colorSize.ColorSizeName,  -- Added ColorSizeName to the selection
        SUM(CASE WHEN stock.LocationID = 1 THEN stock.Stock ELSE 0 END) AS MahabageStock,
        SUM(CASE WHEN stock.LocationID = 6 THEN stock.Stock ELSE 0 END) AS ElpitiyaStock,
        SUM(CASE WHEN stock.LocationID = 7 THEN stock.Stock ELSE 0 END) AS RajagiriyaStock
    FROM
        dbo.InvProductMaster product
    INNER JOIN
        dbo.InvProductStockMaster stock ON product.InvProductMasterID = stock.ProductID
    INNER JOIN
        dbo.InvDepartment department ON product.DepartmentID = department.InvDepartmentID
    INNER JOIN
        dbo.InvProductColorSize colorSize ON product.InvProductMasterID = colorSize.InvProductMasterID  -- Assuming this table exists and relates products to color/size
    WHERE
        1 = 1
        [[ AND product.ProductCode = {{ProductCode}} ]]  
        [[ AND department.DepartmentName = {{DepartmentName}} ]]  
    GROUP BY
        product.ProductCode,
        product.ProductName,
        department.DepartmentName,
        colorSize.ColorSizeName  -- Grouped by ColorSizeName
),
SalesData AS (
    SELECT
        sales.ProductCode,
        sales.ProductName,
        department.DepartmentName,
        colorSize.ColorSizeName,  -- Added ColorSizeName to the selection
        SUM(CASE WHEN sales.LocationID = 1 THEN sales.NetAmount ELSE 0 END) AS MahabageSales,
        SUM(CASE WHEN sales.LocationID = 1 THEN sales.Qty ELSE 0 END) AS MahabageQtySold,
        SUM(CASE WHEN sales.LocationID = 6 THEN sales.NetAmount ELSE 0 END) AS ElpitiyaSales,
        SUM(CASE WHEN sales.LocationID = 6 THEN sales.Qty ELSE 0 END) AS ElpitiyaQtySold,
        SUM(CASE WHEN sales.LocationID = 7 THEN sales.NetAmount ELSE 0 END) AS RajagiriyaSales,
        SUM(CASE WHEN sales.LocationID = 7 THEN sales.Qty ELSE 0 END) AS RajagiriyaQtySold
    FROM
        dbo.InvSales sales
    INNER JOIN
        dbo.InvProductMaster product ON sales.ProductID = product.InvProductMasterID
    INNER JOIN
        dbo.InvDepartment department ON product.DepartmentID = department.InvDepartmentID
    INNER JOIN
        dbo.InvProductColorSize colorSize ON product.InvProductMasterID = colorSize.InvProductMasterID  -- Assuming this table exists and relates products to color/size
    WHERE
        sales.DocumentDate >= DATEADD(day, -@NumberOfDays, CAST(GETDATE() AS date))  -- Using the declared parameter
        AND sales.DocumentDate < CAST(GETDATE() AS date)
        [[ AND sales.ProductCode = {{ProductCode}} ]]  
        [[ AND department.DepartmentName = {{DepartmentName}} ]]  
        [[ AND sales.DocumentDate BETWEEN {{StartDate}} AND {{EndDate}} ]]
    GROUP BY
        sales.ProductCode,
        sales.ProductName,
        department.DepartmentName,
        colorSize.ColorSizeName  -- Grouped by ColorSizeName
)
SELECT
    s.ProductCode,
    s.ProductName,
    s.DepartmentName,
    s.ColorSizeName,  -- Added ColorSizeName to the final output
    COALESCE(s.MahabageStock, 0) AS MahabageStock,
    COALESCE(s.ElpitiyaStock, 0) AS ElpitiyaStock,
    COALESCE(s.RajagiriyaStock, 0) AS RajagiriyaStock,
    COALESCE(sd.MahabageQtySold, 0) AS MahabageQtySold,
    COALESCE(sd.ElpitiyaQtySold, 0) AS ElpitiyaQtySold,
    COALESCE(sd.RajagiriyaQtySold, 0) AS RajagiriyaQtySold
FROM
    StockData s
INNER JOIN
    SalesData sd ON s.ProductCode = sd.ProductCode AND s.DepartmentName = sd.DepartmentName AND s.ColorSizeName = sd.ColorSizeName  -- Join on ColorSizeName as well
ORDER BY
    s.ProductCode;