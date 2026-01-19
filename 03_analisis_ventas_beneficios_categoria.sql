-- =====================================================
-- ANÁLISIS 1: VENTAS Y BENEFICIOS POR CATEGORÍA
-- =====================================================
-- Este análisis muestra las ventas totales y los beneficios por categoría de productos

-- Consulta principal: Ventas y beneficios por categoría
SELECT 
    c.categoria_nombre AS Categoria,
    COUNT(DISTINCT v.venta_id) AS Total_Transacciones,
    SUM(v.cantidad) AS Unidades_Vendidas,
    ROUND(SUM(v.cantidad * v.precio_venta), 2) AS Ventas_Totales,
    ROUND(SUM(v.costo_total), 2) AS Costos_Totales,
    ROUND(SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total), 2) AS Beneficio_Total,
    ROUND(((SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total)) / SUM(v.cantidad * v.precio_venta)) * 100, 2) AS Margen_Beneficio_Porcentaje
FROM 
    Ventas v
    INNER JOIN Productos p ON v.producto_id = p.producto_id
    INNER JOIN Categorias c ON p.categoria_id = c.categoria_id
GROUP BY 
    c.categoria_id, c.categoria_nombre
ORDER BY 
    Beneficio_Total DESC;

-- Consulta adicional: Top 5 productos más rentables por categoría
WITH ProductosRentables AS (
    SELECT 
        c.categoria_nombre,
        p.producto_nombre,
        SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total) AS beneficio_producto,
        ROW_NUMBER() OVER (PARTITION BY c.categoria_id ORDER BY SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total) DESC) AS ranking
    FROM 
        Ventas v
        INNER JOIN Productos p ON v.producto_id = p.producto_id
        INNER JOIN Categorias c ON p.categoria_id = c.categoria_id
    GROUP BY 
        c.categoria_id, c.categoria_nombre, p.producto_id, p.producto_nombre
)
SELECT 
    categoria_nombre AS Categoria,
    producto_nombre AS Producto,
    ROUND(beneficio_producto, 2) AS Beneficio
FROM 
    ProductosRentables
WHERE 
    ranking <= 5
ORDER BY 
    categoria_nombre, ranking;

-- Análisis de tendencia mensual por categoría
SELECT 
    c.categoria_nombre AS Categoria,
    YEAR(v.fecha_venta) AS Anio,
    MONTH(v.fecha_venta) AS Mes,
    SUM(v.cantidad) AS Unidades_Vendidas,
    ROUND(SUM(v.cantidad * v.precio_venta), 2) AS Ventas_Totales,
    ROUND(SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total), 2) AS Beneficio
FROM 
    Ventas v
    INNER JOIN Productos p ON v.producto_id = p.producto_id
    INNER JOIN Categorias c ON p.categoria_id = c.categoria_id
GROUP BY 
    c.categoria_id, c.categoria_nombre, YEAR(v.fecha_venta), MONTH(v.fecha_venta)
ORDER BY 
    c.categoria_nombre, Anio, Mes;
