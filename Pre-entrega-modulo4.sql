-- ---------------------------------------------------------------------
-- 1. Rentabilidad por categoría
-- ---------------------------------------------------------------------
-- Problema de negocio que resuelve: 
-- Permite identificar cuáles son las categorías de productos más rentables 
-- y con mayor volumen de ventas, filtrando aquellas que superan un umbral 
-- mínimo de ingresos totales para enfocar los esfuerzos comerciales y de stock.
-- ---------------------------------------------------------------------
SELECT 
    cat.nombre AS categoria,
    SUM(dv.cantidad) AS unidades_vendidas,
    SUM(dv.cantidad * dv.precio_unitario) AS ingreso_total
FROM 
    categorias cat
JOIN 
    productos p ON cat.nombre = p.categoria -- Se une por nombre de categoría
JOIN 
    ventas dv ON p.id_producto = dv.id_producto 
GROUP BY 
    cat.id, cat.nombre
HAVING 
    SUM(dv.cantidad * dv.precio_unitario) > 50000
ORDER BY 
    ingreso_total DESC;

-- ---------------------------------------------------------------------
-- 2. Clientes sin compras
-- ---------------------------------------------------------------------
-- Problema de negocio que resuelve: 
-- Detecta aquellos clientes registrados que nunca han realizado una transacción 
-- en el sistema. Esto es clave para el área de marketing, permitiendo diseñar 
-- campañas de reactivación o bienvenida dirigidas exclusivamente a este segmento.
-- ---------------------------------------------------------------------

SELECT 
    c.id_cliente AS id_cliente,
    c.nombre AS nombre,
    c.email,
    COALESCE(COUNT(v.id_venta), 0) AS total_compras
FROM 
    clientes c
LEFT JOIN 
    ventas v ON c.id_cliente = c.id_cliente 
GROUP BY 
    c.id_cliente, c.nombre, c.email
HAVING 
    COUNT(v.id_venta) = 0;

-- ---------------------------------------------------------------------
-- 3. Top de compras por cliente (Producto favorito y última transacción)
-- ---------------------------------------------------------------------
-- Problema de negocio que resuelve: 
-- Analiza el comportamiento de compra histórico de cada cliente activo, 
-- identificando cuál es el producto que más veces ha adquirido y la fecha 
-- exacta de su última compra para personalizar la experiencia del usuario.
-- ---------------------------------------------------------------------

SELECT 
    c.nombre AS cliente_nombre,
    p.nombre AS producto_favorito,
    MAX(v.fecha_venta) AS ultima_transaccion
FROM 
    clientes c
JOIN 
    ventas v ON c.id_cliente = v.id_cliente
JOIN 
    productos p ON v.id_producto = p.id_producto 
GROUP BY 
    c.id_cliente, c.nombre, p.id_producto, p.nombre
ORDER BY 
    cliente_nombre, ultima_transaccion DESC;