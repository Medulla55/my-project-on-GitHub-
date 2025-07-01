--SELECT 
select *from [E-COMMERCE]


--DEVICE TYPE USED  BY CUSTOMER
SELECT  device_type FROM [E-COMMERCE] 


--PRODUCT CATEGORIES
select product from [E-COMMERCE]



--PRODUCT CATEGORIES SOLD TO WHOM
select gender,product,COUNT(*) as total_sales
from [E-COMMERCE]
group by Gender, Product
order by Gender,Product



--MOST PREFERRED LOGIN TYPE
select top 1 Customer_Login_type
from [E-COMMERCE]

  --PREFERRED LOGIN TYPE WHILE SHOPPING
  SELECT Customer_Login_type, COUNT (*) AS LOGIN_COUNT
  FROM [E-COMMERCE]
  GROUP BY Customer_Login_type
  ORDER BY Customer_Login_type DESC;


--HOW DOES DATE AND TIME AFFECT MY SALES?
SELECT Order_Date,Time AS SALE_MONTH,
SUM(Sales) AS TOTALSALES
FROM [E-COMMERCE]
GROUP BY Order_Date,Time
ORDER BY Sales


--MOST PROFIT PER UNIT
SELECT TOP 1 Product,Profit,Quantity as profitperunit
FROM [E-COMMERCE]
order by profitperunit desc


--DELIVERY SPEED AND ORDER PRIORITY
SELECT
    FORMAT(ORDER_DATE, 'yyyy-MM') AS OrderMonth,
    ORDER_PRIORITY,
    COUNT(*) AS TotalOrders,
    AVG(AGING) AS AvgDeliveryTime_Months,
    MIN(AGING) AS MinDeliveryTime_Months,
    MAX(AGING) AS MaxDeliveryTime_Months
FROM
    [E-COMMERCE]
WHERE
    AGING IS NOT NULL
GROUP BY
    FORMAT(ORDER_DATE, 'yyyy-MM'),
    ORDER_PRIORITY
ORDER BY
    OrderMonth,
    ORDER_PRIORITY;

-- TOTAL SALES PER MONTH 
SELECT
    FORMAT(ORDER_DATE, 'yyyy-MM') AS OrderMonth,
    SUM(SALES) AS TotalSales
FROM
    [E-COMMERCE]
WHERE
    SALES IS NOT NULL
GROUP BY
    FORMAT(ORDER_DATE, 'yyyy-MM')
ORDER BY
    OrderMonth;

   

-- MONTH WITH THE HIGHEST SALES USING WINDOW FUNCTION
WITH MonthlySales AS (
    SELECT
        FORMAT(ORDER_DATE, 'yyyy-MM') AS OrderMonth,
        SUM(SALES) AS TotalSales
    FROM
        [E-COMMERCE]
    WHERE
        SALES IS NOT NULL
    GROUP BY
        FORMAT(ORDER_DATE, 'yyyy-MM')
)
SELECT TOP 1 *
FROM MonthlySales
ORDER BY TotalSales DESC;


--TOP 5 SELLING PRODUCTS BASED ON QUANTITY
SELECT TOP 5
    PRODUCT,
    SUM(QUANTITY) AS TotalQuantitySold
FROM
    [E-COMMERCE]
WHERE
    QUANTITY IS NOT NULL
GROUP BY
    PRODUCT
ORDER BY
    TotalQuantitySold DESC;

--INSIGHT INTO XTICS OF THE TOP 5 PRODUCTS USING PROFIT
	WITH TopProducts AS (
    SELECT
        PRODUCT,
        SUM(QUANTITY) AS TotalQuantitySold
    FROM
        [E-COMMERCE]
    WHERE
        QUANTITY IS NOT NULL
    GROUP BY
        PRODUCT
)
SELECT TOP 5
    p.PRODUCT,
    p.Product_Category,
    MIN(p.Profit) AS MinProfit,
    MAX(p.Profit) AS MaxProfit,
    AVG(p.Profit) AS AvgProfit,
    t.TotalQuantitySold
FROM
    [E-COMMERCE] p
JOIN
    TopProducts t ON p.PRODUCT = t.PRODUCT
GROUP BY
    p.PRODUCT, Product_Category, t.TotalQuantitySold
ORDER BY
    t.TotalQuantitySold DESC;

--TOTAL SALES BY PRODUCT CATEGORY
SELECT
   Product_Category,
    SUM(SALES) AS TotalSales,
    COUNT(*) AS TotalOrders,
    AVG(SALES) AS AvgSalesPerOrder
FROM
    [E-COMMERCE]
WHERE
    SALES IS NOT NULL
GROUP BY
   Product_Category
ORDER BY
    TotalSales DESC;


--PERCENTAGE CONTRIBUTION TO SALES BY CATEGORY
SELECT
    Product_Category,
    SUM(SALES) AS TotalSales,
    ROUND(SUM(SALES) * 100.0 / (SELECT SUM(SALES) FROM [E-COMMERCE] WHERE SALES IS NOT NULL), 2) AS SalesPercentage
FROM
    [E-COMMERCE]
WHERE
    SALES IS NOT NULL
GROUP BY
    Product_Category
ORDER BY
    SalesPercentage DESC;


--avgsales per order
SELECT
    COUNT(*) AS TotalOrders,
    SUM(SALES) AS TotalSales,
    AVG(SALES) AS AvgSalesPerOrder
FROM
    [E-COMMERCE]
WHERE
    SALES IS NOT NULL;


--TOP 5 CUSTOMERS BY TOTAL SALES AMOUNT
WITH OrderTotals AS (
    SELECT
        Customer_Id,
        SUM(SALES) AS TotalOrderSales
    FROM
        [E-COMMERCE]
    WHERE
        SALES IS NOT NULL
    GROUP BY
        Customer_Id
)
SELECT TOP 5 *
FROM OrderTotals
ORDER BY TotalOrderSales DESC;












