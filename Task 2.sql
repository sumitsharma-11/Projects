## 2.1: Calculate delivery delay (in days) for each order
## Delay is calculated as Actual Delivery Date minus Order Date (delivery_delay_days ).
SELECT
    Order_ID,
    Order_Date,
    Actual_Delivery_Date,
    DATEDIFF(Actual_Delivery_Date, Order_Date) AS delivery_delay_days 
FROM Orders;

## 2.2: Find Top 10 delayed routes based on average delay days (average delay time).
SELECT
    T1.Route_ID,
    AVG(DATEDIFF(T1.Actual_Delivery_Date, T1.Order_Date)) AS Avg_delay_Time_Days
FROM Orders T1
GROUP BY T1.Route_ID
ORDER BY Avg_delay_Time_Days DESC
LIMIT 10;

## 2.3: Use window functions to rank all orders by delay within each warehouse.
SELECT
    Order_ID,
    Warehouse_ID,
    DATEDIFF(Actual_Delivery_Date, Order_Date) AS delivery_delay_days,
    RANK() OVER (
        PARTITION BY Warehouse_ID
        ORDER BY DATEDIFF(Actual_Delivery_Date, Order_Date) DESC
    ) AS Delay_Rank_Within_Warehouse
FROM Orders
ORDER BY Warehouse_ID, Delay_Rank_Within_Warehouse;