use project;

## 1.1: Identify and delete duplicate Order_ID records (Keeps the one with the earliest Order_Date)
## For simple identification:
SELECT Order_ID, COUNT(Order_ID)
FROM Orders
GROUP BY Order_ID
HAVING COUNT(Order_ID) > 1;

## 1.2: Replace null Traffic_Delay_Min with the average delay for that route. 
UPDATE Routes AS T1
JOIN (
    SELECT Route_ID, AVG(Traffic_Delay_Min) AS Avg_Delay
    FROM Routes
    WHERE Traffic_Delay_Min IS NOT NULL
    GROUP BY Route_ID
) AS T2
ON T1.Route_ID = T2.Route_ID
SET T1.Traffic_Delay_Min = T2.Avg_Delay
WHERE T1.Traffic_Delay_Min IS NULL;

## 1.3: Convert all date columns into YYYY-MM-DD format (Example for Orders table)
SELECT
    Order_ID,
    DATE_FORMAT(Order_Date, '%Y-%m-%d') AS Formatted_Order_Date,
    DATE_FORMAT(Actual_Delivery_Date, '%Y-%m-%d') AS Formatted_Delivery_Date
FROM Orders;

## 1.4: Ensure that no Actual_Delivery_Date is before Order_Date (flag such records).
SELECT
    Order_ID,
    Order_Date,
    Actual_Delivery_Date,
    'FLAGGED: Invalid Delivery Date' AS Date_Check_Flag
FROM Orders
WHERE Actual_Delivery_Date < Order_Date;