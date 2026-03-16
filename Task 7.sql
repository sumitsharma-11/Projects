## 7.1: Average Delivery Delay per Region (Start_Location).
## Delay calculated as average transit time for orders marked as delayed/late
SELECT
    T2.Start_Location AS Region,
    AVG(DATEDIFF(T1.Actual_Delivery_Date, T1.Order_Date)) AS Average_Delay_Days
FROM Orders T1
JOIN Routes T2 ON T1.Route_ID = T2.Route_ID
WHERE T1.Status = 'Delayed' OR T1.Status = 'Late'
GROUP BY T2.Start_Location
ORDER BY Average_Delay_Days DESC;

## 7.2: Overall On-Time Delivery % = (Total On-Time Deliveries / Total Deliveries) * 100 (Overall)
SELECT
    (SUM(CASE WHEN Status = 'Delivered' THEN 1 ELSE 0 END) * 100.0 / COUNT(Order_ID)) AS Overall_On_Time_Delivery_Percentage
FROM Orders;

## 7.3: Average Traffic Delay per Route (using the cleaned data from Task 1)
SELECT
    Route_ID,
    Start_Location,
    End_Location,
    AVG(Traffic_Delay_Min) AS Average_Traffic_Delay_Minutes
FROM Routes
GROUP BY Route_ID, Start_Location, End_Location
ORDER BY Average_Traffic_Delay_Minutes DESC;