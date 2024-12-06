--Significant Drop in Qty at One Location
--i.Mahabage’s Qty are significantly lower compared to other locations, suggesting localized issues like competition or customer dissatisfaction.
--ii.Elpitiya’s Qty are significantly lower compared to other locations, suggesting localized issues like competition or customer dissatisfaction.
--iii.Rajagiriya’s Qty are significantly lower compared to other locations, suggesting localized issues like competition or customer.
WITH QtyData AS (
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
),
SignificantDrop AS (
    SELECT
        ProductCode,
        ProductName,
        DepartmentName,
        MahabageQty,
        ElpitiyaQty,
        RajagiriyaQty,
        CASE 
            WHEN MahabageQty < 0.5 * LEAST(ElpitiyaQty, RajagiriyaQty) THEN 'Mahabage'
            WHEN ElpitiyaQty < 0.5 * LEAST(MahabageQty, RajagiriyaQty) THEN 'Elpitiya'
            WHEN RajagiriyaQty < 0.5 * LEAST(MahabageQty, ElpitiyaQty) THEN 'Rajagiriya'
            ELSE NULL
        END AS LocationWithDrop
    FROM
        QtyData
)
SELECT 
    ProductCode,
    ProductName,
    DepartmentName,
    MahabageQty,
    ElpitiyaQty,
    RajagiriyaQty,
    LocationWithDrop
FROM SignificantDrop
WHERE LocationWithDrop IS NOT NULL
ORDER BY ProductCode;
