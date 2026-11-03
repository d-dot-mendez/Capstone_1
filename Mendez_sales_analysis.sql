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

-- Used ChatGPT for the UNION ALL syntax
SELECT MONTHNAME(Date) AS Month,
    YEAR(Date) AS Year,
    SalesTotal
FROM online_sales
UNION ALL 
SELECT 
	MONTHNAME(Transaction_Date) AS Month,
    YEAR(Transaction_Date) AS Year,
	Sale_Amount
FROM store_sales
WHERE Store_ID >= 701 AND Store_ID <= 718
GROUP BY Month, YEAR; 

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

-- Breakdown by Month, Year, and Total Revenue
SELECT MONTHNAME(Date) AS Month,
    YEAR(Date) AS Year,
    SUM(SalesTotal) AS Total_Revenue
FROM online_sales
GROUP BY YEAR (DATE), MONTHNAME (DATE)
UNION ALL 
SELECT MONTHNAME(Transaction_Date) AS Month,
    YEAR(Transaction_Date) AS Year,
	SUM(Sale_Amount) AS Total_Revenue
FROM store_sales
WHERE Store_ID >= 701 AND Store_ID <= 718
GROUP BY MONTHNAME(Transaction_Date), YEAR(Transaction_Date); 

-- Comapring Colorado's Total Revenue with other states

SELECT State,
       SUM(Revenue) AS Total_Revenue
FROM
(
    SELECT ShipToState AS State,
           SalesTotal AS Revenue
    FROM online_sales

    UNION ALL

    SELECT l.State,
           s.Sale_Amount AS Revenue
    FROM store_sales s
    JOIN store_locations l
        ON s.Store_ID = l.StoreID
) sales_data
GROUP BY State
ORDER BY Total_Revenue DESC; 

-- Number of Transactions per Month by product category
SELECT
    MONTHNAME(o.Date) AS Month,
    o.ProdNum AS Product_Category,
    COUNT(*) AS Transaction_Count,
    AVG(o.SalesTotal) AS Average_Transaction_Amount
FROM online_sales o
WHERE o.ShiptoState = 'Colorado'
GROUP BY
    MONTH(o.Date),
    MONTHNAME(o.Date),
    o.ProdNum
ORDER BY
    MONTH(o.Date),
    o.ProdNum;
    
-- Ranking of in-store sales by each store in Colorado 
SELECT StoreId, SUM(Sale_Amount) AS Total_Revenue
FROM store_locations
JOIN store_sales ON StoreId = Store_ID
WHERE State = 'Colorado'
GROUP BY StoreId
ORDER BY Total_Revenue DESC;

-- Recommendation 
SELECT Prod_Num, Sale_Amount, Product, p.Categoryid, Category
FROM store_sales s
LEFT JOIN products p ON s.Prod_Num = p.ProdNum
JOIN inventory_categories i ON p.Categoryid = i.Categoryid
WHERE Store_ID = 705
ORDER BY Sale_Amount DESC;

SELECT Prod_Num, Sale_Amount, Product, p.Categoryid, Category
FROM store_sales s
LEFT JOIN products p ON s.Prod_Num = p.ProdNum
JOIN inventory_categories i ON p.Categoryid = i.Categoryid
WHERE Store_ID = 715
ORDER BY Sale_Amount; 

/* For the next quarter, I recommend we focus our sales attention on Stationery
and Supplies. Our best selling store is Stoe 705 and their best selling category
is Technology and Accessories. It is like that for several stores, actually. Across
several stores, including the lowest selling store, store 715, the category that 
tends to sell the least is Stationery and Supplies. That can be due to several
reasons, one of which is that people may not feel the need to buy anything from
that department because we have technology. It is true that in many cases, techno-
logy often replaces an old way of doing something (for example, instead of writing
essays on papers, we type our essays on computers), but if we can convince the
consumers that they still need stationery supplies in conjunction with technology,
then they will be more inclined to buy stationery supplies, and that will increase
sales for both Technology and Accessories as well as Stationery and Supplies. In 
other words, the "accessories" that consumers need for their technology are the 
products in Stationery and Supplies. 
*


