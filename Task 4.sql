## 4.1: Find the top 3 warehouses with the highest average processing time.
SELECT
    Warehouse_ID,
    Warehouse_Name,
    Average_Processing_Time_Min
FROM Warehouses
ORDER BY Average_Processing_Time_Min DESC
LIMIT 3;

## 4.2: Calculate total vs. delayed shipments for each warehouse.
SELECT
    T1.Warehouse_ID,
    T2.Warehouse_Name,
    COUNT(T1.Order_ID) AS Total_Shipments,
    SUM(CASE WHEN T1.Status = 'Delayed' OR T1.Status = 'Late' THEN 1 ELSE 0 END) AS Delayed_Shipments
FROM Orders T1
JOIN Warehouses T2 ON T1.Warehouse_ID = T2.Warehouse_ID
GROUP BY T1.Warehouse_ID, T2.Warehouse_Name
ORDER BY Delayed_Shipments DESC;

## 4.3: Use CTEs to find bottleneck warehouses where processing time > global average.
WITH GlobalAvg AS (
    SELECT AVG(Average_Processing_Time_Min) AS Global_Average
    FROM Warehouses
)
SELECT
    W.Warehouse_ID,
    W.Warehouse_Name,
    W.Average_Processing_Time_Min,
    GA.Global_Average
FROM Warehouses W
CROSS JOIN GlobalAvg GA
WHERE W.Average_Processing_Time_Min > GA.Global_Average
ORDER BY W.Average_Processing_Time_Min DESC;

## 4.4: Rank warehouses based on on-time delivery percentage.
SELECT
    T1.Warehouse_ID,
    T2.Warehouse_Name,
    (SUM(CASE WHEN T1.Status = 'Delivered' THEN 1 ELSE 0 END) * 100.0 / COUNT(T1.Order_ID)) AS On_Time_Delivery_Percentage,
    RANK() OVER (
        ORDER BY (SUM(CASE WHEN T1.Status = 'Delivered' THEN 1 ELSE 0 END) * 100.0 / COUNT(T1.Order_ID)) DESC
    ) AS On_Time_Rank
FROM Orders T1
JOIN Warehouses T2 ON T1.Warehouse_ID = T2.Warehouse_ID
GROUP BY T1.Warehouse_ID, T2.Warehouse_Name
ORDER BY On_Time_Rank ASC;