--Demand is consistently low across all locations, indicating a broader market problem.
WITH SalesData AS (
    SELECT
        sales.ProductCode,
        sales.ProductName,
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
    GROUP BY
        sales.ProductCode,
        sales.ProductName,
        department.DepartmentName
)
SELECT
    ProductCode,
    ProductName,
    DepartmentName,
    MahabageQtySold,
    ElpitiyaQtySold,
    RajagiriyaQtySold,
    CASE
        WHEN MahabageQtySold < 50 AND ElpitiyaQtySold < 50 AND RajagiriyaQtySold < 50 THEN 'Low Demand Across All Locations'
        ELSE NULL
    END AS LowDemandStatus
FROM
    SalesData
WHERE
    MahabageQtySold < 50 AND ElpitiyaQtySold < 50 AND RajagiriyaQtySold < 50
ORDER BY
    ProductCode;
