-- Denae Mendez
-- Analysis for Colorado
-- 11/5/2026

USE sample_sales;
SELECT database(); 

-- Total Revenues in Colorado and the Start and End Time
SELECT SUM(SalesTotaL + Sale_Amount) AS Total_Revenue
FROM online_sales o
LEFT JOIN store_sales s
	ON o.id = s.id
WHERE Store_ID >= 701 AND Store_ID <= 718;


SELECT 
	MIN(o.Date), 
    MAX(o.Date),
    MAX(s.Transaction_Date),
    MIN(s.Transaction_Date)
FROM online_sales o
LEFT JOIN store_sales s
	ON o.id = s.id
WHERE Store_ID >= 701 AND Store_ID <= 718;
/*
Based off this results, Between January 1st, 2022 and 
December 31st 2025, Colorado made a total of
11,366,948.80 in Total_Revenue. */




