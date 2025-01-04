# Arcatron Mobility Data Analyst SQL Project
# Project By: PRASAD JADHAV

USE arcatronmobilitydb;

SELECT * FROM arcatron_mobility_data;

SET SQL_SAFE_UPDATES = 0;

UPDATE arcatron_mobility_data
SET Shipping_Method = CASE 
    WHEN Shipping_Method = 'Air' THEN 'FedEx'
    WHEN Shipping_Method = 'Road' THEN 'DHL'
    WHEN Shipping_Method = 'Sea' THEN 'TCIExpress'
    ELSE Shipping_Method
END;

SET SQL_SAFE_UPDATES = 1;

# Top-Selling Products
SELECT Product_ID, SUM(Quantity_Sold) AS Total_Quantity
FROM arcatron_mobility_data
GROUP BY Product_ID
ORDER BY Total_Quantity DESC
LIMIT 10;

#  Top 5 Products by Revenue
SELECT Product, SUM(Sales_Amount) AS Total_Revenue
FROM arcatron_mobility_data
GROUP BY Product
ORDER BY Total_Revenue DESC
LIMIT 5;

# Average Customer Rating by Region
SELECT Region, AVG(Customer_Rating) AS Avg_Rating
FROM arcatron_mobility_data
GROUP BY Region
ORDER BY Avg_Rating DESC;

# Shipping Costs by Method
SELECT Shipping_Method, AVG(Logistics_Cost) AS Avg_Shipping_Cost
FROM arcatron_mobility_data
GROUP BY Shipping_Method
ORDER BY Avg_Shipping_Cost DESC;

# Average Lead Time by Supplier
SELECT Supplier_ID, AVG(Lead_Time) AS Avg_Lead_Time
FROM arcatron_mobility_data
GROUP BY Supplier_ID
ORDER BY Avg_Lead_Time LIMIT 10;

# Production Cost Analysis
SELECT Category, AVG(Production_Cost) AS Avg_Production_Cost
FROM arcatron_mobility_data
GROUP BY Category
ORDER BY Avg_Production_Cost DESC;

# Top 5 Most Profitable Products
SELECT Product, SUM(Profit_Margin) AS Total_Profit
FROM arcatron_mobility_data
GROUP BY Product
ORDER BY Total_Profit DESC
LIMIT 5;

# Profitability by Region
SELECT Region, SUM(Profit_Margin) AS Total_Profit
FROM arcatron_mobility_data
GROUP BY Region
ORDER BY Total_Profit DESC;

# Delivery Satisfaction by Shipping Method
SELECT Shipping_Method, AVG(Delivery_Satisfaction) AS Avg_Satisfaction
FROM arcatron_mobility_data
GROUP BY Shipping_Method
ORDER BY Avg_Satisfaction DESC;

#  Most Common Customer Feedback
SELECT Customer_Feedback, COUNT(*) AS Feedback_Count
FROM arcatron_mobility_data
GROUP BY Customer_Feedback
ORDER BY Feedback_Count DESC
LIMIT 5;

# Products Below Reorder Level
SELECT Product_Code, Stock_Quantity, Reorder_Level
FROM arcatron_mobility_data
WHERE Stock_Quantity < Reorder_Level LIMIT 10;

# Stock Valuation by Warehouse
SELECT Warehouse_ID, SUM(Stock_Valuation) AS Total_Stock_Value
FROM arcatron_mobility_data
GROUP BY Warehouse_ID
ORDER BY Total_Stock_Value DESC LIMIT 10;

# Marketing Campaign Effectiveness
SELECT Marketing_Campaign, AVG(Profit_Margin) AS Avg_Profit
FROM arcatron_mobility_data
GROUP BY Marketing_Campaign
ORDER BY Avg_Profit DESC;

# Customer Retention Analysis
# Identify customers who placed multiple orders in a given period.
SELECT 
    Customer_ID, 
    COUNT(Order_ID) AS Total_Orders, 
    SUM(Sales_Amount) AS Total_Spent
FROM arcatron_mobility_data
WHERE Order_Date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY Customer_ID
HAVING Total_Orders > 3
ORDER BY Total_Spent DESC;

# Product Demand Forecasting
# Identify products with consistent sales growth over time.
SELECT 
    Product_ID, 
    MONTH(Order_Date) AS Month, 
    SUM(Quantity_Sold) AS Total_Sales
FROM arcatron_mobility_data
GROUP BY Product_ID, Month
ORDER BY Product_ID, Month LIMIT 10;

# Correlation Between Defect Flags and Lead Time
SELECT 
    Lead_Time, 
    COUNT(Defect_Flag) AS Total_Defects
FROM arcatron_mobility_data
WHERE Defect_Flag = 'Yes'
GROUP BY Lead_Time
ORDER BY Lead_Time ASC;

# Profitability by Region and Category
SELECT 
    Region, 
    Category, 
    SUM(Sales_Amount) AS Total_Sales, 
    SUM(Profit_Margin) AS Total_Profit
FROM arcatron_mobility_data
GROUP BY Region, Category
ORDER BY Total_Profit DESC;

# Seasonal Sales Trends
# Analyze how sales vary by season (grouped by quarters).
SELECT 
    QUARTER(Order_Date) AS Quarter, 
    Category, 
    SUM(Sales_Amount) AS Total_Sales
FROM arcatron_mobility_data
GROUP BY Quarter, Category
ORDER BY Quarter, Total_Sales DESC;

# Underperforming Products
# Identify products with high returns and low customer ratings.
SELECT 
    Product, 
    COUNT(Return_Flag) AS Total_Returns, 
    AVG(Customer_Rating) AS Avg_Rating
FROM arcatron_mobility_data
WHERE Return_Flag = 'Yes'
GROUP BY Product
HAVING Avg_Rating < 3
ORDER BY Total_Returns DESC;

# High-Cost Orders with Low Satisfaction
SELECT 
    Order_ID, 
    Customer_ID, 
    Sales_Amount, 
    Delivery_Satisfaction
FROM arcatron_mobility_data
WHERE Sales_Amount > 1000 AND Delivery_Satisfaction < 3
ORDER BY Sales_Amount DESC LIMIT 10;

# Customer Segmentation by Spending
SELECT 
    Customer_ID,
    CASE 
        WHEN SUM(Sales_Amount) < 500 THEN 'Low Spender'
        WHEN SUM(Sales_Amount) BETWEEN 500 AND 2000 THEN 'Mid Spender'
        ELSE 'High Spender'
    END AS Spending_Category,
    SUM(Sales_Amount) AS Total_Spent
FROM arcatron_mobility_data
GROUP BY Customer_ID
ORDER BY Total_Spent DESC LIMIT 10;

# Operational Cost vs. Profit Margin Analysis
SELECT 
    Region,
    AVG(Operational_Cost) AS Avg_Operational_Cost,
    AVG(Profit_Margin) AS Avg_Profit_Margin,
    (AVG(Profit_Margin) / AVG(Operational_Cost)) * 100 AS Profitability_Ratio
FROM arcatron_mobility_data
GROUP BY Region
ORDER BY Profitability_Ratio DESC;

# Impact of Warranty Period on Returns
SELECT 
    Warranty_Period, 
    COUNT(Return_Flag) AS Total_Returns
FROM arcatron_mobility_data
WHERE Return_Flag = 'Yes'
GROUP BY Warranty_Period
ORDER BY Warranty_Period ASC;

# Marketing Campaign Effectiveness by Region
SELECT 
    Marketing_Campaign,
    Region,
    SUM(Sales_Amount) AS Total_Sales,
    AVG(Profit_Margin) AS Avg_Profit_Margin
FROM arcatron_mobility_data
GROUP BY Marketing_Campaign, Region
ORDER BY Total_Sales DESC, Avg_Profit_Margin DESC;

# Delivery Delays by Region
SELECT 
    Region, 
    COUNT(*) AS Total_Delays,
    AVG(DATEDIFF(Delivery_Date, Shipping_Date)) AS Avg_Delay_Days
FROM arcatron_mobility_data
WHERE DATEDIFF(Delivery_Date, Shipping_Date) > 0
GROUP BY Region
ORDER BY Total_Delays DESC;

# Find Customers Who Spend More Than the Average Spending
SELECT Customer_ID, Total_Spent
FROM (
    SELECT 
        Customer_ID,
        SUM(Sales_Amount) AS Total_Spent
    FROM arcatron_mobility_data
    GROUP BY Customer_ID
) AS Customer_Spending
WHERE Total_Spent > (
    SELECT AVG(Total_Spent) 
    FROM (
        SELECT 
            Customer_ID,
            SUM(Sales_Amount) AS Total_Spent
        FROM arcatron_mobility_data
        GROUP BY Customer_ID
    ) AS Avg_Customer_Spending
)
ORDER BY Total_Spent DESC LIMIT 10;

# Find Customers Who Ordered Products from All Categories
SELECT Customer_ID
FROM arcatron_mobility_data
GROUP BY Customer_ID
HAVING COUNT(DISTINCT Category) = (
    SELECT COUNT(DISTINCT Category)
    FROM arcatron_mobility_data
) LIMIT 10;

# Detect Products with Below-Average Ratings in Their Category
SELECT Product, Category, Avg_Rating
FROM (
    SELECT 
        Product, 
        Category, 
        AVG(Customer_Rating) AS Avg_Rating
    FROM arcatron_mobility_data
    GROUP BY Product, Category
) AS Product_Ratings
WHERE Avg_Rating < (
    SELECT AVG(Customer_Rating)
    FROM arcatron_mobility_data
    WHERE Category = Product_Ratings.Category
);

# Average Sales by Top Regions Based on Total Profit
SELECT Region, Avg_Sales
FROM (
    SELECT 
        Region, 
        AVG(Sales_Amount) AS Avg_Sales, 
        RANK() OVER (ORDER BY SUM(Profit_Margin) DESC) AS Profit_Rank
    FROM arcatron_mobility_data
    GROUP BY Region
) AS Region_Stats
WHERE Profit_Rank <= 3;

# Find the Maximum Sales Difference Between Categories
SELECT MAX(Sales_Difference) AS Max_Sales_Difference
FROM (
    SELECT 
        Category, 
        MAX(Sales_Amount) - MIN(Sales_Amount) AS Sales_Difference
    FROM arcatron_mobility_data
    GROUP BY Category
) AS Category_Sales_Diff;

# Product Popularity Index
SELECT Product, Popularity_Index
FROM (
    SELECT 
        Product, 
        (SUM(Quantity_Sold) * AVG(Customer_Rating)) AS Popularity_Index
    FROM arcatron_mobility_data
    GROUP BY Product
) AS Product_Popularity
ORDER BY Popularity_Index DESC;

# More Advance Working Sonn..!
# Notebook Project By : PRASAD JADHAV (DA & ML-ENG)
# LinkedIn: linkedin.com/in/prasadmjadhav2 | Github: github.com/prasadmjadhav2 | Mail: prasadmjadhav6161@gmail.com