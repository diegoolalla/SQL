USE WAREHOUSE CAMEL_WH;
USE ROLE training_role;
USE DATABASE camel_db;
USE SCHEMA SMART_DESK;


-- EJERCICIOS

-- EJERICICIO 1
SELECT  
    CATEGORY, 
    SUM(PRODUCT) AS T_PRODUCTO,
    SUM(MAINTENANCE) AS T_MANTENIMIENTO, 
    SUM(SUPPORT) AS T_SOPORTE, 
    SUM(PARTS) AS T_REPUESTOS, 
    SUM(UNITS_SOLD) AS T_UNIDADES_VENDIDAS, 
    SUM(TOTAL) AS T_INGRESOS,
    SUM(PROFIT) AS T_BENEFICIO
FROM SALES 
WHERE YEAR =2020 AND ACCOUNT = 'Adabs Entertainment'
GROUP BY CATEGORY;



-- EJERCICIO 2

SELECT 
    A.INDUSTRY, 
    A.COUNTRY, 
    SUM(S.PRODUCT) AS T_PRODUCTO, 
    SUM(S.UNITS_SOLD) AS T_UNIDADES_VENDIDAS, 
    SUM(S.PROFIT) AS T_BENEFICIO, 
    AVG(S.PROFIT) AS PROMEDIO_BENEFICIO
FROM  Sales S
INNER JOIN  Accounts A
ON S.ACCOUNT = A.ACCOUNT
WHERE A.REGION IN ('APAC', 'EMEA')
GROUP BY A.INDUSTRY, A.COUNTRY
ORDER BY A.INDUSTRY,A.COUNTRY;


-- EJERCICIO 3
SELECT A.INDUSTRY, SUM(S.PROFIT) AS T_BENEFICIO, 
CASE
    WHEN SUM(S.PROFIT) > 1000000 THEN 'Alto'
    ELSE 'Normal'
END AS TIPO_BENEFICIO
FROM SALES S
INNER JOIN ACCOUNTS A
ON A.ACCOUNT = S.ACCOUNT
WHERE A.ACCOUNT IN (
    SELECT F.ACCOUNT
    FROM FORECASTS F
    WHERE YEAR = 2022
    GROUP BY F.ACCOUNT
    HAVING SUM(FORECAST) > 500000
)
GROUP BY A.INDUSTRY
ORDER BY T_BENEFICIO DESC;

-- EJERCICIO 4

SELECT 
    COALESCE(S.CATEGORY, F.CATEGORY) AS CATEGORIAS,
    SUM(S.PROFIT) AS Total_Profit_overall,
    SUM(F.FORECAST) AS Total_Forecast,
    MAX(F.OPPORTUNITY_AGE) AS OLD_OPPORTUNITY,
    MIN(F.OPPORTUNITY_AGE) AS YOUNG_OPPORTUNITY
FROM SALES AS S
FULL OUTER JOIN FORECASTS AS F 
ON S.CATEGORY = F.CATEGORY AND S.YEAR = F.YEAR
WHERE 
    S.QUARTER in('2020 Q1', '2021 Q3') 
    OR F.YEAR = 2022
GROUP BY CATEGORIAS;



-- EJERCICIO 5

SELECT
    cs.Industry,
    cs.Quarter,
    SUM(cs.Total_Profit) AS Total_Profit_Per_Quarter,
    SUM(SUM(cs.Total_Profit)) OVER (PARTITION BY cs.Industry ORDER BY Quarter) AS Accumulated_Profit,
    SUM(SUM(cf.Total_Forecast)) OVER (PARTITION BY cs.Industry) AS Accumulated_Forecast
FROM
    (SELECT
        s.Account,
        a.Industry,
        s.Quarter,
        SUM(s.Profit) AS Total_Profit
     FROM Sales AS s
     JOIN Accounts AS a ON s.Account = a.Account
     GROUP BY s.Account, a.Industry, s.Quarter) AS cs
INNER JOIN
    (SELECT
        f.Account,
        a.Industry,
        SUM(f.Forecast) AS Total_Forecast
     FROM Forecasts AS f
     JOIN Accounts AS a ON f.Account = a.Account
     GROUP BY f.Account, a.Industry) AS cf
ON cs.Account = cf.Account
GROUP BY cs.Industry, cs.Quarter
ORDER BY cs.Industry, cs.Quarter;


-- CASO PRÁCTICO

-- ¿Qué industrias generan el mayor beneficio y cuáles tienen un alto volumen de ventas pero bajos márgenes?

-- Analisis explorativo 
SELECT 
    a.INDUSTRY,
    SUM(s.TOTAL) AS TOTAL_SALES,
    SUM(s.PROFIT) AS TOTAL_PROFIT,
    SUM(s.UNITS_SOLD) AS TOTAL_UNITS,
    (SUM(s.PROFIT) / SUM(s.TOTAL)) * 100 AS PROFIT_MARGIN,
    (SUM(s.PROFIT) / SUM(s.UNITS_SOLD)) AS PROFIT_PER_UNIT
FROM Sales s
JOIN Accounts a ON s.ACCOUNT = a.ACCOUNT
GROUP BY a.INDUSTRY
ORDER BY TOTAL_PROFIT DESC;

-- Desarrollo del analisis

WITH Industry_Summary AS (
    SELECT
        a.INDUSTRY,
        s.YEAR,
        COUNT(*) AS Total_Sales,
        SUM(s.PROFIT) AS Total_Profit,
        SUM(s.UNITS_SOLD) AS Total_Units_Sold,
        CASE 
            WHEN SUM(s.UNITS_SOLD) > 0 THEN SUM(s.PROFIT) / SUM(s.UNITS_SOLD)
            ELSE 0 
        END AS Profit_Per_Unit
    FROM
        Sales s
    JOIN Accounts a ON s.ACCOUNT = a.ACCOUNT
    GROUP BY
        a.INDUSTRY, s.YEAR
)
SELECT
    i.INDUSTRY,
    i.YEAR,
    i.Total_Sales,
    i.Total_Profit,
    i.Total_Units_Sold,
    i.Profit_Per_Unit,
    RANK() OVER (PARTITION BY i.YEAR ORDER BY i.Total_Profit DESC) AS Profit_Rank,
    RANK() OVER (PARTITION BY i.YEAR ORDER BY i.Profit_Per_Unit DESC) AS Profit_Per_Unit_Rank,
    CASE
        WHEN i.Total_Units_Sold > (SELECT AVG(Total_Units_Sold) 
                                   FROM Industry_Summary 
                                   WHERE YEAR = i.YEAR)
             AND i.Profit_Per_Unit < (SELECT AVG(Profit_Per_Unit) 
                                      FROM Industry_Summary 
                                      WHERE YEAR = i.YEAR)
        THEN 'High Volume, Low Margin'
        ELSE 'Normal'
    END AS Volume_Margin_Category
FROM
    Industry_Summary i
ORDER BY
    i.YEAR, Profit_Rank;
