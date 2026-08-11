-- Ejercicio

--Propósito del ejercicio
--Este ejercicio tiene como objetivo que apliques tus conocimientos sobre CTEs para resolver un problema de análisis de ventas real,
--transformando una consulta que habitualmente sería difícil de leer en una estructura modular y profesional.

--Qué construir
--Vas a extender el repositorio que creaste en el Módulo 4 ("Análisis Agregado Multicapa"). Deberás crear un nuevo script llamado analisis_ctes.sql
--donde realices un informe de rendimiento regional. OKK

--Pasos sugeridos
--Conexión y Contexto: Asegúrate de estar conectado a tu base de datos de PostgreSQL donde tienes las tablas de ventas, regiones y productos
--(creadas en módulos anteriores).

-- CREATE TABLE REGIONES--

CREATE TABLE regiones (
	id_region SERIAL PRIMARY KEY ,
	nombre_region VARCHAR(100) UNIQUE NOT NULL ,
	nombre_provincia VARCHAR(100) UNIQUE NOT NULL ,
	nombre_localidad VARCHAR (100) UNIQUE NOT NULL
);

--Definición de la CTE: Crea una CTE llamada ventas_por_region. Dentro de ella, debes unir las tablas necesarias para obtener el nombre de la región y
-- la suma total de las ventas (SUM(monto)).
--Consulta Principal: Utiliza la CTE creada en una sentencia SELECT final. En este paso final, filtra los resultados para mostrar solo las regiones
--cuyo gran total de ventas sea superior al promedio general de todas las ventas (puedes usar una subconsulta simple dentro del WHERE para este
-- promedio). Ordenamiento: Asegúrate de que el resultado final esté ordenado de mayor a menor venta.

WITH ventas_por_region AS (
	SELECT
		r.nombre_region,
		SUM(v.monto) AS total_ventas -- Sin coma al final
	FROM ventas v
	INNER JOIN regiones r ON v.region_id = r.id
	GROUP BY r.nombre_region
)
SELECT
	nombre_region, -- Falta de coma corregida acá
	total_ventas
FROM ventas_por_region 
WHERE total_ventas > (SELECT AVG(monto) FROM ventas)
ORDER BY total_ventas DESC;

--Criterios de aceptación--
--El script debe utilizar obligatoriamente la cláusula WITH.
--La lógica debe estar dividida: la agregación (SUM) debe ocurrir dentro de la CTE y el filtrado/ordenamiento en la consulta principal.
--El código debe estar debidamente indentado y comentado siguiendo las buenas prácticas vistas en clase.
--El archivo debe subirse al mismo repositorio del proyecto final, en una carpeta llamada modulo_5/.

-- Formulación de Script --
--Errores comunes a evitar
--No poner alias a las columnas calculadas dentro de la CTE (esto hará que no puedas llamarlas en la consulta principal).
--Olvidar cerrar el paréntesis de la definición de la CTE antes de iniciar el SELECT final.
--Intentar usar WITH más de una vez para definir varias CTEs (recuerda que solo se usa una vez al principio y las CTEs se separan por comas).