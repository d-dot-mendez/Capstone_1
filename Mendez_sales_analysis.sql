-- Denae Mendez
-- Analysis for Colorado
-- 11/5/2026

USE sample_sales;
SELECT database(); 

-- Total Revenues in Colorado and the Start and End Time
/*Based off the results from the first query, the start time would be 
1/18/2022 and the end time would be 12/31/2025. 

Based off the results from the second query, the total revenue is 455,304.72
So from 1/18/2022 to 12/31/2025, Colorado has made $3,160,877.11 in total revenue. 
*/
SELECT
    MIN(Date) AS Earliest_Order_Date,
    MIN(Transaction_Date) AS Earliest_Transaction_Date,
    MAX(Date) AS Latest_Order_Date,
    MAX(Transaction_Date) AS Latest_Transaction_Date
FROM online_sales o
JOIN store_sales s
    ON o.id = s.id
WHERE ShiptoState = 'Colorado'
  AND Store_ID BETWEEN 701 AND 718;

SELECT SUM(SalesTotal + Sale_Amount) AS Total_Revenue
FROM online_sales o
JOIN store_sales s
    ON o.id = s.id
WHERE ShiptoState = 'Colorado'; 
	
/* I needed chatgpt's help to create a union all syntax. This is what my query was
looking like prior: 

SELECT MONTHNAME(Date), YEAR(Date), MONTHNAME(Transaction_Date),
YEAR(Transaction_Date),
SUM(SalesTotal + Sale_Amount) AS Total_Revenue
FROM online_sales o
JOIN store_sales s
    ON o.id = s.id
WHERE ShiptoState = 'Colorado'
  AND Store_ID BETWEEN 701 AND 718
GROUP BY MONTHNAME(Date), MONTHNAME(Transaction_Date) ; */

-- This shows the revenue breakdown by Month and Year
SELECT
    Month,
    Year,
    SUM(Revenue) AS Total_Revenue
FROM (
    SELECT
        MONTHNAME(Date) AS Month,
        YEAR(Date) AS Year,
        SalesTotal AS Revenue
    FROM online_sales
    WHERE ShiptoState = 'Colorado'

    UNION ALL

    SELECT
        MONTHNAME(Transaction_Date) AS Month,
        YEAR(Transaction_Date) AS Year,
        Sale_Amount AS Revenue
    FROM store_sales
    WHERE Store_ID BETWEEN 701 AND 718
) AS SalesData
GROUP BY Year, Month
ORDER BY Year;



-- Comapring Colorado's Total Revenue with other states
/* I needed some help with chatgpt for the union help. This is what I had prior.
SELECT SUM(SalesTotal), ShiptoState
FROM online_sales
GROUP BY ShiptoState;
*/
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
    MONTHNAME(o.Date)
ORDER BY
    MONTH(o.Date),
    o.ProdNum;

/*This was my query to find the average product and by how much. I need AI's help
with this question as well. 

SELECT MONTHNAME(Transaction_Date), AVG(Sale_Amount), Prod_Num, Subcategory
FROM store_sales 
JOIN inventory_subcategories ON Prod_Num = Subcategoryid
WHERE Store_ID BETWEEN 701 AND 718
GROUP BY MONTHNAME(Transaction_Date)
 */
 -- The number of transactions per month, as well as 
 -- the average transaction amount by product category
SELECT
    MONTHNAME(Transaction_Date) AS Month,
    COUNT(id) AS Transaction_Count,
    ROUND(AVG(Sale_Amount), 2) AS Avg_Transaction_Amount,
    Subcategory
FROM store_sales
LEFT JOIN products p
    ON Prod_Num = ProdNum
JOIN inventory_subcategories i
    ON p.Subcategoryid = i.Subcategoryid
WHERE Store_ID BETWEEN 701 AND 718
GROUP BY
    MONTH(Transaction_Date),
    MONTHNAME(Transaction_Date),
    Subcategory;
    
    
    
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


