SELECT * FROM porterdb.porter_delivery_data;

# Delivery Performance Analysis
# Analyze the dataset to determine average delivery times, delays, and performance trends by region or delivery personnel.
SELECT 
    Booking_Status,
    AVG(Order_Delivery_Time - Order_Date) AS Average_Delivery_Duration,
    COUNT(*) AS Total_Deliveries
FROM porter_delivery_data
GROUP BY Booking_Status;

# Customer Insights
# Explore customer ordering behavior, such as most frequent customers, average order value, or delivery preferences.
SELECT 
    Customer_ID,
    COUNT(*) AS Total_Orders,
    AVG(Sub_Total) AS Average_Order_Value,
    MAX(Sub_Total) AS Max_Order_Value
FROM porter_delivery_data
GROUP BY Customer_ID
ORDER BY Total_Orders DESC
LIMIT 10;

# Geographical Trends
# Identify regions with the highest delivery density and compare delivery performance across regions.
SELECT 
    Location,
    COUNT(*) AS Total_Deliveries,
    AVG(Total_KM) AS Average_Distance,
    SUM(Revenue) AS Total_Revenue
FROM porter_delivery_data
GROUP BY Location
ORDER BY Total_Deliveries DESC;

# Driver Performance Metrics
# Calculate key performance indicators (KPIs) for drivers, such as on-time delivery percentage, average delivery time, and number of deliveries per day.
SELECT 
    Driver_Ratings,
    COUNT(*) AS Total_Deliveries,
    AVG(Total_KM) AS Average_Distance,
    SUM(Revenue) AS Total_Revenue
FROM porter_delivery_data
WHERE Booking_Status = 'Success'
GROUP BY Driver_Ratings
ORDER BY Driver_Ratings DESC;

# Order Value Trends
# Examine order value trends over time and analyze how factors like distance or time slot affect order value.
SELECT 
    COUNT(Booking_Date) AS Order_Date,
    AVG(Total_Outstanding_Orders) AS Average_Order_Value,
    SUM(Revenue) AS Total_Revenue
FROM porter_delivery_data
GROUP BY Order_Date
ORDER BY Order_Date LIMIT 15;

# Delivery Slot Optimization
# Investigate which time slots are most popular and identify patterns that could optimize resource allocation.
SELECT 
    Booking_Time,
    COUNT(*) AS Total_Bookings,
    AVG(Order_Delivery_Time - Booking_Time) AS Average_Delivery_Time
FROM porter_delivery_data
GROUP BY Booking_Time
ORDER BY Total_Bookings DESC LIMIT 15;

# Predictive Analysis Using SQL
# Use SQL to prepare data for machine learning models that predict delivery delays or customer churn.
SELECT 
    Total_Items,
    Sub_Total,
    Revenue,
    Total_KM,
    Driver_Ratings,
    Customer_Rating,
    CASE 
        WHEN Booking_Status = 'Success' THEN 1
        ELSE 0
    END AS Delivery_Status
FROM porter_delivery_data LIMIT 20;

SELECT
    SUM(CASE WHEN Booking_Status = 'Success' THEN 1 ELSE 0 END) AS Success_Count,
    SUM(CASE WHEN Booking_Status != 'Success' THEN 1 ELSE 0 END) AS Failed_Count
FROM
    porter_delivery_data;

# Profitability Analysis
# Explore the relationship between order value, delivery distance, and costs to identify the most profitable types of deliveries.
SELECT 
    Location,
    Vehicle_Category,
    AVG(Revenue - Fare_Charge) AS Average_Profit
FROM porter_delivery_data
GROUP BY Location, Vehicle_Category
ORDER BY Average_Profit DESC;

# Operational Efficiency
# Use the data to evaluate order preparation times and delivery person performance for operational efficiency.
SELECT 
    Vehicle_Category,
    AVG(Order_Delivery_Time) AS Average_Preparation_Time,
    AVG(Total_KM) AS Average_Distance,
    AVG(Order_Delivery_Time - Booking_Time) AS Average_Delivery_Time
FROM porter_delivery_data
GROUP BY Vehicle_Category;

SELECT 
    Vehicle_Type,
    AVG(Order_Delivery_Time) AS Average_Preparation_Time,
    AVG(Total_KM) AS Average_Distance,
    AVG(Order_Delivery_Time - Booking_Time) AS Average_Delivery_Time
FROM porter_delivery_data
GROUP BY Vehicle_Type;

# Revenue Segmentation by Customer Behavior
# Analyze how different customer types contribute to revenue:
SELECT
    `What_Describes_You_Best?` AS Customer_Type,
    COUNT(DISTINCT Customer_ID) AS Total_Customers, 
    COUNT(Booking_ID) AS Total_Bookings,
    SUM(Revenue) AS Total_Revenue,
    AVG(Revenue) AS Average_Revenue_Per_Booking,
    SUM(CASE WHEN Booking_Status = 'Success' THEN Revenue ELSE 0 END) / SUM(Revenue) * 100 AS Success_Rate
FROM
    porter_delivery_data
GROUP BY
    `What_Describes_You_Best?`
ORDER BY
    Total_Revenue DESC;
    
# Impact of Vehicle Type on Delivery Times
# Understand how different vehicle types affect operational efficiency:
SELECT 
    `Vehicle_Type`,
    COUNT(*) AS Total_Deliveries,
    -- Location to Pikup Customer Order KM Duration
    AVG(`Pickup_Location_KM`) AS Avg_Pickup_Estimated_Duration,
    -- Pickup to Drop Customer Order KM Duration
    AVG(`Pickup_Location_KM`) AS Avg_Drop_Estimated_Duration,
    AVG(`Order_Delivery_Time` - `Order_Date`) AS Avg_Actual_Delivery_Duration,
    AVG(`Order_Delivery_Time` - `Booking_Time`) AS Avg_Total_Duration
FROM porter_delivery_data
GROUP BY `Vehicle_Type`
ORDER BY Avg_Actual_Delivery_Duration;

# Cancellation Trends and Reasons
# Deep dive into order cancellations to reduce churn:
SELECT
    `Reason_for_Cancelling_by_Customer`,
    COUNT(*) AS Total_Cancelled_Orders,
    AVG(`Total_Outstanding_Orders`) AS Avg_Cancelled_Order_Value,
    -- Location to Pikup Customer Order KM Duration
    AVG(`Pickup_Location_KM`) AS Avg_Distance_For_Cancellations
FROM
    porter_delivery_data
WHERE
    `Cancelled_Order_by_Customer` = 1  -- Filter for cancelled orders
GROUP BY
    `Reason_for_Cancelling_by_Customer`
ORDER BY
    Total_Cancelled_Orders DESC;
    
# Delivery Bottleneck Analysis
# Identify operational bottlenecks based on Incomplete Order Reason:
SELECT
    `Incomplete_Order_Reason`,
    COUNT(*) AS Total_Incomplete_Orders,
    AVG(`Order_Delivery_Time` - `Booking_Time`) AS Avg_Delivery_Duration,
    AVG(`Order_Delivery_Time` - `Order_Date`) AS Avg_Delay,
    SUM(CASE WHEN `Booking_Status` = 'Failed' THEN 1 ELSE 0 END) AS Failed_Deliveries
FROM
    porter_delivery_data
WHERE
    `Booking_Status` = 'Failed'  -- Filter for failed orders only
GROUP BY
    `Incomplete_Order_Reason`
ORDER BY
    Avg_Delay DESC;    
    
SELECT
    `Incomplete_Order_Reason`,
    COUNT(*) AS Total_Incomplete_Orders,
    AVG(CASE WHEN `Booking_Status` != 'Failed' THEN `Order_Delivery_Time` - `Booking_Time` END) AS Avg_Delivery_Duration,
    AVG(CASE WHEN `Booking_Status` != 'Failed' THEN `Order_Delivery_Time` - `Order_Date` END) AS Avg_Delay,
    SUM(CASE WHEN `Booking_Status` = 'Failed' THEN 1 ELSE 0 END) AS Failed_Deliveries
FROM
    porter_delivery_data
WHERE
    `Booking_Status` IN ('Failed', 'Canceled by Driver', 'Canceled by Customer')
GROUP BY
    `Incomplete_Order_Reason`
ORDER BY
    Avg_Delay DESC;    
    
# Driver Efficiency Metrics
# Evaluate driver performance based on ratings and delivery times:
SELECT 
    `Driver_Ratings`,
    COUNT(*) AS Total_Deliveries,
    AVG(`Order_Delivery_Time` - `Booking_Time`) AS Avg_Delivery_Duration,
    AVG(`Revenue`) AS Avg_Revenue_Per_Delivery,
    SUM(CASE WHEN `Booking_Status` = 'Success' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Success_Rate
FROM porter_delivery_data
GROUP BY `Driver_Ratings`
ORDER BY Driver_Ratings DESC;
    
# Revenue Leak Analysis
# Identify gaps where revenue might be leaking (e.g., incomplete orders, cancellations):
SELECT 
    `Booking_Status`,
    COUNT(*) AS Total_Bookings,
    SUM(`Revenue`) AS Total_Revenue,
    AVG(`Revenue`) AS Avg_Revenue_Per_Booking,
    SUM(CASE WHEN `Booking_Status` = 'Failed' THEN `Revenue` ELSE 0 END) AS Lost_Revenue
FROM porter_delivery_data
GROUP BY `Booking_Status`
ORDER BY Lost_Revenue DESC;
    
# Profitability of Vehicle Categories by Route
# Analyze which vehicle categories are more profitable for specific routes:
SELECT 
    `Vehicle_Category`,
    `Location`,
    AVG(`Revenue` - `Fare_Charge`) AS Avg_Profit,
    COUNT(*) AS Total_Trips,
    AVG(`Total_KM`) AS Avg_Distance
FROM porter_delivery_data
WHERE `Fare_Charge` IS NOT NULL
GROUP BY `Vehicle_Category`, `Location`
ORDER BY Avg_Profit DESC;
 
# Dynamic Pricing Opportunities
# Analyze how pricing varies across delivery times and locations:
SELECT 
    `Booking_Time`,
    `Location`,
    AVG(`Revenue`) AS Avg_Revenue,
    COUNT(*) AS Total_Bookings
FROM porter_delivery_data
GROUP BY `Booking_Time`, `Location`
ORDER BY Avg_Revenue DESC LIMIT 20;

# Driver Retention Analysis
# Understand what factors might affect driver retention and satisfaction:
SELECT 
    `Driver_Ratings`,
    AVG(`Booking_Value`) AS Avg_Booking_Value,
    AVG(`Total_KM`) AS Avg_Distance,
    SUM(CASE WHEN `Booking_Status` = 'Success' THEN 1 ELSE 0 END) AS Successful_Trips,
    AVG(`Fare_Charge`) AS Avg_Fare_Per_Trip
FROM porter_delivery_data
GROUP BY `Driver_Ratings`
ORDER BY Avg_Fare_Per_Trip DESC;

# Insights & Actions
-- Use Customer Retention Analysis to identify loyal customers and design loyalty programs.
-- Optimize routes and vehicle usage by analyzing Profitability of Vehicle Categories by Route.
-- Address operational inefficiencies from Cancellation Trends and Reasons.
-- Implement dynamic pricing based on Revenue Segmentation by Time and Location.

# Project By : PRASAD JADHAV (DA & ML-ENG)
# LinkedIn: linkedin.com/in/prasadmjadhav2 | Github: github.com/prasadmjadhav2 | Mail: prasadmjadhav6161@gmail.com