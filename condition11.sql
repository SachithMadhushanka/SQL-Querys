--Qty Proportions Between Locations
-- i.Mahabage’s Qty are greater than the combined Qty of Elpitiya and Rajagiriya, indicating it’s a key market
-- ii.Elpitiya’s Qty are greater than the combined 
-- iii.Rajagiriya’s Qty are greater than the combined Qty
WITH SalesData AS (
    SELECT
        product.ProductCode,
        product.ProductName,
        department.DepartmentName,
        SUM(CASE WHEN sales.LocationID = 1 THEN sales.Qty ELSE 0 END) AS MahabageQty,
        SUM(CASE WHEN sales.LocationID = 6 THEN sales.Qty ELSE 0 END) AS ElpitiyaQty,
        SUM(CASE WHEN sales.LocationID = 7 THEN sales.Qty ELSE 0 END) AS RajagiriyaQty
    FROM
        dbo.InvProductMaster product
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
)
SELECT 
    ProductCode,
    ProductName,
    DepartmentName,
    MahabageQty,
    ElpitiyaQty,
    RajagiriyaQty,
    CASE 
        WHEN MahabageQty > (ElpitiyaQty + RajagiriyaQty) THEN 'Mahabage is Key Market'
        WHEN ElpitiyaQty > (MahabageQty + RajagiriyaQty) THEN 'Elpitiya is Key Market'
        WHEN RajagiriyaQty > (MahabageQty + ElpitiyaQty) THEN 'Rajagiriya is Key Market'
        ELSE 'No Single Key Market'
    END AS QtyProportion
FROM SalesData
ORDER BY ProductCode;
