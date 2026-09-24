
-- 1. Primera CTE: Agrupa las ventas mensuales por categoría
WITH ventas_mensuales AS (
    SELECT
        DATE_TRUNC('month', v.fecha_venta) AS mes,
        c.nombre AS categoria, 
        SUM(v.monto) AS venta_total    
    FROM ventas v
    JOIN productos p ON v.id_producto = p.id_producto 
    JOIN categorias c ON p.id_categoria = c.id_categoria
    GROUP BY 1, 2
),

-- 2. Segunda CTE: Aplica funciones de ventana para métricas y ranking
metricas_ventana AS (
    SELECT
        mes,
        categoria,
        venta_total,
        ROW_NUMBER() OVER (PARTITION BY mes ORDER BY venta_total DESC) AS rn, -- Implementado ROW_NUMBER().
        RANK() OVER (PARTITION BY mes ORDER BY venta_total DESC) AS ranking,
        SUM(venta_total) OVER (PARTITION BY categoria ORDER BY mes) AS acumulado,
        AVG(venta_total) OVER (PARTITION BY categoria) AS promedio_historico
    FROM ventas_mensuales
)
SELECT
    mes,
    categoria,
    venta_total,
    ranking,
    acumulado,
-- Justificación del umbral: Se evalúa si el rendimiento mensual es exitoso 
-- comparándolo contra el promedio histórico acumulado de la propia categoría.
    CASE 
        WHEN venta_total >= promedio_historico THEN 'Exitoso'
        ELSE 'Bajo el promedio'
    END AS comparativa
FROM metricas_ventana
WHERE rn = 1 -- Filtra correctamente usando el ROW_NUMBER() definido arriba
ORDER BY mes DESC, ranking ASC;


-- Fin
