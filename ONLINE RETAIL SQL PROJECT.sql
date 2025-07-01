


--SELECT *
SELECT *FROM [Online Retail]


--PURCHASE FREQUENCY
SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS PurchaseCount,
    CASE 
        WHEN COUNT(DISTINCT InvoiceNo) = 1 THEN 'One-time Buyer'
        WHEN COUNT(DISTINCT InvoiceNo) BETWEEN 2 AND 4 THEN 'Repeat Buyer'
        WHEN COUNT(DISTINCT InvoiceNo) >= 5 THEN 'High-frequency Buyer'
    END AS CustomerSegment
FROM 
    [Online Retail]
WHERE 
    CustomerID IS NOT NULL
GROUP BY 
    CustomerID;



--REVENUE GENERATED FROM EACH SEGMENT
WITH CustomerSegments AS (
    SELECT 
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS PurchaseCount,
        SUM(Quantity * UnitPrice) AS TotalRevenue,
        CASE 
            WHEN COUNT(DISTINCT InvoiceNo) = 1 THEN 'One-time Buyer'
            WHEN COUNT(DISTINCT InvoiceNo) BETWEEN 2 AND 4 THEN 'Repeat Buyer'
            WHEN COUNT(DISTINCT InvoiceNo) >= 5 THEN 'High-frequency Buyer'
        END AS CustomerSegment
    FROM 
        [Online Retail]
    WHERE 
        CustomerID IS NOT NULL 
        AND Quantity > 0 
        AND UnitPrice > 0
    GROUP BY 
        CustomerID
)

SELECT 
    CustomerSegment,
    COUNT(*) AS NumberOfCustomers,
    SUM(TotalRevenue) AS TotalRevenue,
    AVG(TotalRevenue) AS AvgRevenuePerCustomer
FROM 
    CustomerSegments
GROUP BY 
    CustomerSegment
ORDER BY 
    TotalRevenue DESC;



--TOP 10 MOST PURCHASED PRODUCT BASED ON QUANTITY SOLD
	SELECT TOP 10
    StockCode,Country
    Description,
    SUM(Quantity) AS TotalQuantitySold
FROM 
    [Online Retail]
WHERE 
    Quantity > 0  -- Exclude returns or negative sales
    AND Description IS NOT NULL
GROUP BY 
    StockCode,Country,
    Description
ORDER BY 
    TotalQuantitySold DESC



--COUNTRIES THAT PURCHASE THESE PRODUCTS THE MOST
	-- Step 1: Get Top 10 Products by Quantity Sold
WITH TopProducts AS (
    SELECT TOP 10
        StockCode,
        Description,
        SUM(Quantity) AS TotalQuantitySold
    FROM 
        [Online Retail]
    WHERE 
        Quantity > 0
        AND Description IS NOT NULL
    GROUP BY 
        StockCode, Description
    ORDER BY 
        TotalQuantitySold DESC
),

-- Step 2: Get Quantity Sold by Country for Each of the Top 10 Products
ProductCountryBreakdown AS (
    SELECT 
        o.StockCode,
        o.Description,
        o.Country,
        SUM(o.Quantity) AS QuantitySold
    FROM 
        [Online Retail] o
    INNER JOIN 
        TopProducts tp ON o.StockCode = tp.StockCode
    WHERE 
        o.Quantity > 0
        AND o.Description IS NOT NULL
    GROUP BY 
        o.StockCode, o.Description, o.Country
)

-- Final Output: Sorted Breakdown
SELECT 
    StockCode,
    Description,
    Country,
    QuantitySold
FROM 
    ProductCountryBreakdown
ORDER BY 
    StockCode,
    QuantitySold DESC;



--TOTAL SALES REVENUE FOR EACH COUNTRIES, IDENTIFYING TOP 5 COUNTRIES THAT CONTRIBUTED MOST
	SELECT TOP 5
    Country,
    SUM(Quantity * UnitPrice) AS TotalSalesRevenue
FROM 
    [Online Retail]
WHERE 
    Quantity > 0 
    AND UnitPrice > 0 
    AND Country IS NOT NULL
GROUP BY 
    Country
ORDER BY 
    TotalSalesRevenue DESC;


--CUSTOMER LIFETIME VALUE ANALYSIS
-- Step 1: Identify Repeat Customers
WITH CustomerPurchases AS (
    SELECT 
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS PurchaseCount,
        SUM(Quantity * UnitPrice) AS TotalRevenue
    FROM 
        [Online Retail]
    WHERE 
        Quantity > 0 
        AND UnitPrice > 0 
        AND CustomerID IS NOT NULL
    GROUP BY 
        CustomerID
),
-- Step 2: Filter Repeat Customers (More than 1 Purchase)
RepeatCustomers AS (
    SELECT 
        CustomerID,
        PurchaseCount,
        TotalRevenue AS CustomerLifetimeValue
    FROM 
        CustomerPurchases
    WHERE 
        PurchaseCount > 1
)

-- Step 3: Output CLV per Repeat Customer
SELECT 
    CustomerID,
    PurchaseCount,
    CustomerLifetimeValue
FROM 
    RepeatCustomers
ORDER BY 
    CustomerLifetimeValue DESC;





--TOP 5 CUSTOMERS BASED ON TOTAL SALES VALUE
	WITH CustomerSales AS (
    SELECT 
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS PurchaseFrequency,
        SUM(Quantity * UnitPrice) AS TotalRevenue
    FROM 
        [Online Retail]
    WHERE 
        Quantity > 0 
        AND UnitPrice > 0 
        AND CustomerID IS NOT NULL
    GROUP BY 
        CustomerID
)

SELECT TOP 5 *
FROM CustomerSales
ORDER BY TotalRevenue DESC;



--PRODUCT PERFORMANCE BY CATEGORY
-- Step 1: Create Derived Categories Based on Description Keywords
WITH CategorizedProducts AS (
    SELECT 
        *,
        CASE 
            WHEN Description LIKE '%MUG%' THEN 'Mugs'
            WHEN Description LIKE '%LANTERN%' THEN 'Lanterns'
            WHEN Description LIKE '%CUSHION%' THEN 'Cushions'
            WHEN Description LIKE '%BAG%' THEN 'Bags'
            WHEN Description LIKE '%CLOCK%' THEN 'Clocks'
            WHEN Description LIKE '%LIGHT%' OR Description LIKE '%LAMP%' THEN 'Lighting'
            WHEN Description LIKE '%BOTTLE%' THEN 'Bottles'
            WHEN Description LIKE '%FRAME%' THEN 'Frames'
            WHEN Description LIKE '%CANDLE%' THEN 'Candles'
            WHEN Description LIKE '%BOX%' THEN 'Boxes'
            ELSE 'Other'
        END AS ProductCategory
    FROM 
        [Online Retail]
    WHERE 
        Quantity > 0 
        AND UnitPrice > 0 
        AND Description IS NOT NULL
)

-- Step 2: Sum Sales Revenue by Category
SELECT 
    ProductCategory,
    SUM(Quantity * UnitPrice) AS TotalRevenue,
    COUNT(DISTINCT StockCode) AS UniqueProducts,
    COUNT(*) AS TotalTransactions
FROM 
    CategorizedProducts
GROUP BY 
    ProductCategory
ORDER BY 
    TotalRevenue DESC;














