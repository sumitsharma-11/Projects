## 5.1: Rank agents (per route) by on-time delivery percentage (using the percentage from the Delivery_Agents table as proxy for per-route ranking)
SELECT
    Agent_ID,
    Route_ID,
    On_Time_Delivery_Percentage,
    RANK() OVER (
        PARTITION BY Route_ID
        ORDER BY On_Time_Delivery_Percentage DESC
    ) AS Agent_Rank_Per_Route
FROM Delivery_Agents
ORDER BY Route_ID, Agent_Rank_Per_Route;

## 5.2: Find agents with on-time % < 80% (Using On_Time_Delivery_Percentage from Delivery_Agents table)
SELECT
    Agent_ID,
    Agent_Name,
    On_Time_Delivery_Percentage
FROM Delivery_Agents
WHERE On_Time_Delivery_Percentage < 80.0
ORDER BY On_Time_Delivery_Percentage ASC;

## 5.3: Compare average speed of top 5 vs bottom 5 agents using subqueries. 
(SELECT
    'Top 5 Agents' AS Agent_Group,
    AVG(T1.Avg_Speed_KMPH) AS Group_Average_Speed
FROM (
    SELECT Avg_Speed_KMPH
    FROM Delivery_Agents
    ORDER BY Avg_Speed_KMPH DESC
    LIMIT 5               
) AS T1)
UNION ALL
(SELECT
     'Bottom 5 Agents' AS Agent_Group,
    AVG(T1.Avg_Speed_KMPH) AS Group_Average_Speed
FROM (
    SELECT Avg_Speed_KMPH
    FROM Delivery_Agents
    ORDER BY Avg_Speed_KMPH ASC
    LIMIT 5                
) AS T1);

## 5.4: Suggest training or workload balancing strategies for low performers (Conceptual)
/*
Recommendation: Agents identified in query 5.2 (On_Time_Delivery_Percentage < 80%) should be prioritized for:
1. Training: Targeted sessions on route optimization and time management.
2. Workload Balancing: Reviewing their assigned Route_ID (from 5.1) and potentially re-assigning them 
from high-delay/high-volume routes to less congested areas to reduce pressure and improve performance.
*/