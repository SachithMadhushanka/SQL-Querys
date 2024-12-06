--To check if there are any negative values in the Qty field (quantity sold) for any of the locations.
WITH SalesData AS (
    SELECT
        sales.ProductCode,
        sales.ProductName,
        sales.SupplierName,
        sales.CategoryName,
        department.DepartmentName,
        SUM(CASE WHEN sales.LocationID = 1 THEN sales.Qty ELSE 0 END) AS MahabageQtySold,
        SUM(CASE WHEN sales.LocationID = 6 THEN sales.Qty ELSE 0 END) AS ElpitiyaQtySold,
        SUM(CASE WHEN sales.LocationID = 7 THEN sales.Qty ELSE 0 END) AS RajagiriyaQtySold
    FROM
        dbo.InvSales sales
    INNER JOIN
        dbo.InvProductMaster product ON sales.ProductID = product.InvProductMasterID
    INNER JOIN
        dbo.InvDepartment department ON product.DepartmentID = department.InvDepartmentID
    WHERE
        1 = 1
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
    ProductCode,
    ProductName,
    SupplierName,
    CategoryName,
    DepartmentName,
    MahabageQtySold,
    ElpitiyaQtySold,
    RajagiriyaQtySold,
    CASE
        WHEN MahabageQtySold < 0 THEN 'Negative Qty in Mahabage'
        WHEN ElpitiyaQtySold < 0 THEN 'Negative Qty in Elpitiya'
        WHEN RajagiriyaQtySold < 0 THEN 'Negative Qty in Rajagiriya'
        ELSE 'No Negative Qty'
    END AS QtyStatus
FROM
    SalesData
WHERE
    MahabageQtySold < 0
    OR ElpitiyaQtySold < 0
    OR RajagiriyaQtySold < 0
ORDER BY ProductCode;
