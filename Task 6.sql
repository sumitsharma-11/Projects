## 6.1: For each order, list the last checkpoint and time.
WITH LastCheckpoint AS (
    SELECT
        Order_ID,
        Checkpoint,
        Checkpoint_Time,
        ROW_NUMBER() OVER(PARTITION BY Order_ID ORDER BY Checkpoint_Time DESC) as rn
    FROM Shipment_Tracking
)
SELECT
    Order_ID,
    Checkpoint AS Last_Checkpoint,
    Checkpoint_Time AS Last_Checkpoint_Time
FROM LastCheckpoint
WHERE rn = 1
ORDER BY Order_ID;

## 6.2: Find the most common delay reasons (excluding None).
SELECT
    Delay_Reason,
    COUNT(*) AS Reason_Count
FROM Shipment_Tracking
WHERE Delay_Reason IS NOT NULL AND Delay_Reason != 'None' AND TRIM(Delay_Reason) != ''
GROUP BY Delay_Reason
ORDER BY Reason_Count DESC
LIMIT 10;

## 6.3: Identify orders with >2 delayed checkpoints.
## Assuming a delayed checkpoint is one with a non-empty/non-None Delay_Reason.
SELECT
    Order_ID,
    COUNT(*) AS Delayed_Checkpoint_Count
FROM Shipment_Tracking
WHERE Delay_Reason IS NOT NULL AND Delay_Reason != 'None' AND TRIM(Delay_Reason) != ''
GROUP BY Order_ID
HAVING Delayed_Checkpoint_Count > 2
ORDER BY Delayed_Checkpoint_Count DESC;