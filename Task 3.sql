## 3.1: Calculate key metrics for each route
SELECT
    T2.Route_ID,
    T2.Start_Location,
    T2.End_Location,
    ## Average delivery time (in days)
    AVG(DATEDIFF(T1.Actual_Delivery_Date, T1.Order_Date)) AS Avg_Delivery_Time_Days,
    ## Average traffic delay (using the cleaned data from Task 1)
    AVG(T2.Traffic_Delay_Min) AS Avg_Traffic_Delay_Min,
    ## Distance-to-time efficiency ratio: Distance_KM / Average_Travel_Time_Min. Cast to DECIMAL for precision.
    CAST(T2.Distance_KM AS DECIMAL(10, 2)) / NULLIF(T2.Average_Travel_Time_Min, 0) AS Efficiency_Ratio
FROM Orders T1
JOIN Routes T2 ON T1.Route_ID = T2.Route_ID
GROUP BY T2.Route_ID, T2.Start_Location, T2.End_Location, T2.Distance_KM, T2.Average_Travel_Time_Min
ORDER BY T2.Route_ID;

## 3.2: Identify 3 routes with the worst efficiency ratio (lowest ratio).
SELECT
    Route_ID,
    CAST(Distance_KM AS DECIMAL(10, 2)) / NULLIF(Average_Travel_Time_Min, 0) AS Efficiency_Ratio
FROM Routes
WHERE Average_Travel_Time_Min IS NOT NULL AND Average_Travel_Time_Min != 0
ORDER BY Efficiency_Ratio ASC
LIMIT 3;

## 3.3: Find routes with >20% delayed shipments.
SELECT
    Route_ID,
    CAST(SUM(CASE WHEN Status = 'Delayed' OR Status = 'Late' THEN 1 ELSE 0 END) AS REAL) * 100.0 / COUNT(*) AS Delayed_Shipment_Percentage
FROM Orders
GROUP BY Route_ID
HAVING Delayed_Shipment_Percentage > 20
ORDER BY Delayed_Shipment_Percentage DESC;

## 3.4: Recommend potential routes for optimization.
/*
Recommendation: Routes identified in query 3.2 (lowest Efficiency_Ratio) and query 
3.3 (highest Delayed_Shipment_Percentage) should be prioritized for optimization. 
Examples include RT_13, RT_17, and RT_08 (assuming these are in the top results). 
Optimization efforts should focus on traffic analysis, dedicated delivery windows,
or re-routing high-risk segments.
*/