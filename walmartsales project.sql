create database walmart_sales;
USE walmart_sales;


# total sale per department and store 

create view total_sale_department_store as
SELECT 
    t.Store, t.Dept, SUM(t.Weekly_Sales) AS Total_Weekly_Sales
FROM
    train t
GROUP BY t.Store , t.Dept
ORDER BY Total_Weekly_Sales DESC;

# following query analyze sales trends by month to identify seasonal patterns.

create view monthly_sales_trend as 
SELECT 
    DATE_FORMAT(t.Date, '%Y-%m') AS YearMonth,
    SUM(t.Weekly_Sales) AS Total_Weekly_Sales
FROM
    train t
GROUP BY YearMonth
ORDER BY YearMonth;

#Compare average sales during holiday weeks versus non-holiday weeks.

create view avg_sale_during_holiday as
select t.Isholiday , avg(t.Weekly_Sales) as avgsales from train t
group by t.Isholiday ;

#Top 5 Stores by Average Sales

create view Top_stores_avg_salaary as
SELECT 
    t.Store, AVG(t.Weekly_Sales) AS Average_Weekly_Sales
FROM
    train t
GROUP BY t.Store
ORDER BY Average_Weekly_Sales DESC
LIMIT 5;

# the following quary examine the relationship between fuel prices and weekly sales.

create view fuelprice_weaklysales as 
SELECT 
    f.Fuel_Price, AVG(t.Weekly_Sales) AS Average_Weekly_Sales
FROM
    train t
        JOIN
    features f ON t.Store = f.Store AND t.Date = f.Date
GROUP BY f.Fuel_Price
ORDER BY f.Fuel_Price;

# analysis of sales by store type 

create view sale_by_store as 
SELECT 
    s.Type, SUM(t.Weekly_Sales) AS Total_Weekly_Sales
FROM
    train t
        JOIN
    stores s ON t.Store = s.Store
GROUP BY s.Type
ORDER BY Total_Weekly_Sales DESC;

# impact of unemployment on sales 

create view sale_vs_unemployment as
SELECT
    f.Unemployment,
    AVG(t.Weekly_Sales) AS Average_Weekly_Sales
FROM train t
JOIN features f ON t.Store = f.Store AND t.Date = f.Date
GROUP BY f.Unemployment
ORDER BY f.Unemployment;

# the effect of markdown on sales 

create view vw_MarkdownImpactOnSales as
SELECT 
    AVG(f.MarkDown1) AS Avg_MarkDown1,
    AVG(f.MarkDown2) AS Avg_MarkDown2,
    AVG(f.MarkDown3) AS Avg_MarkDown3,
    AVG(f.MarkDown4) AS Avg_MarkDown4,
    AVG(f.MarkDown5) AS Avg_MarkDown5,
    AVG(t.Weekly_Sales) AS Average_Weekly_Sales
FROM
    train t
        JOIN
    features f ON t.Store = f.Store AND t.Date = f.Date
GROUP BY f.MarkDown1 , f.MarkDown2 , f.MarkDown3 , f.MarkDown4 , f.MarkDown5
ORDER BY Average_Weekly_Sales DESC;

# the impact of store size on sales , this query finds it 

create view sales_Vs_Store_Size as 
SELECT
    s.Size,
    SUM(t.Weekly_Sales) AS Total_Weekly_Sales
FROM train t
JOIN stores s ON t.Store = s.Store
GROUP BY s.Size
ORDER BY s.Size DESC;

# the following query analyse  the avg sale per department

create view avgSale_by_department as
SELECT
    t.Dept,
    AVG(t.Weekly_Sales) AS Average_Weekly_Sales
FROM train t
GROUP BY t.Dept
ORDER BY Average_Weekly_Sales DESC;


#Calculate the annual growth rate in sales.

create view annual_sale_growth as
SELECT
    YEAR(t.Date) AS Year,
    SUM(t.Weekly_Sales) AS Total_Weekly_Sales,
    LAG(SUM(t.Weekly_Sales)) OVER (ORDER BY YEAR(t.Date)) AS Previous_Year_Sales,
    (SUM(t.Weekly_Sales) - LAG(SUM(t.Weekly_Sales)) OVER (ORDER BY YEAR(t.Date))) / LAG(SUM(t.Weekly_Sales)) OVER (ORDER BY YEAR(t.Date)) * 100 AS Yearly_Growth_Percentage
FROM train t
GROUP BY Year
ORDER BY Year;




