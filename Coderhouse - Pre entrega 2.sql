-- ============================================================================
-- ENTREGABLE: BASE DE DATOS RETAIL_PROJECT
-- ============================================================================

-- 0. CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE retail_project;

-- Nota: Si estás ejecutando en PostgreSQL con la consola psql, usá: \c retail_project
-- Si estás en DBeaver/pgAdmin, asegurate de conectarte a 'retail_project' antes de continuar.


-- ----------------------------------------------------------------------------
-- 1. DDL: ESTRUCTURA DE TABLAS CON RESTRICCIONES
-- ----------------------------------------------------------------------------

-- Limpieza preventiva en orden inverso
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;

-- Tabla 1: Clientes
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    edad INT NOT NULL CHECK (edad >= 18),             -- Restricción CHECK #1: Mayoría de edad
    fecha_registro DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Tabla 2: Productos
CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0), -- Restricción CHECK #2: Precio positivo
    stock INT NOT NULL CHECK (stock >= 0)
);

-- Tabla 3: Ventas (Creada al final por las Foreign Keys)
CREATE TABLE ventas (
    id_venta SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),       -- Restricción CHECK #3: Cantidad vendida > 0
    precio_unitario DECIMAL(10, 2) NOT NULL,
    fecha_venta TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ventas_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE RESTRICT,
    CONSTRAINT fk_ventas_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE RESTRICT
);


-- ----------------------------------------------------------------------------
-- 2. DML: CARGA DE DATOS EN TRANSACCIÓN EXPLÍCITA
-- ----------------------------------------------------------------------------

BEGIN;

-- 5 Inserts en Clientes
INSERT INTO clientes (nombre, email, edad, fecha_registro) VALUES
('Laura Benítez', 'laura.benitez@email.com', 29, '2025-01-05'),
('Mateo Rossi', 'mateo.rossi@email.com', 42, '2025-01-12'),
('Camila Torres', 'camila.torres@email.com', 21, '2025-01-20'),
('Diego Fernández', 'diego.f@email.com', 37, '2025-02-01'),
('Elena Gómez', 'elena.gomez@email.com', 50, '2025-02-10');

-- 5 Inserts en Productos
INSERT INTO productos (nombre, categoria, precio, stock) VALUES
('Smartphone Galaxy A54', 'Electrónica', 350000.00, 15),
('Funda de Celular Silicone', 'Accesorios', 8500.00, 100),
('Cargador Carga Rápida 25W', 'Accesorios', 18000.00, 50),
('Auriculares Inalámbricos', 'Electrónica', 65000.00, 30),
('Protector de Pantalla Glass', 'Accesorios', 5000.00, 120);

-- 5 Inserts en Ventas
INSERT INTO ventas (id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES
(1, 1, 1, 350000.00, '2025-02-11 10:15:00'),
(2, 2, 2, 8500.00, '2025-02-11 11:30:00'),
(3, 3, 1, 18000.00, '2025-02-12 14:20:00'),
(4, 4, 1, 65000.00, '2025-02-13 16:45:00'),
(5, 5, 3, 5000.00, '2025-02-14 09:00:00');

COMMIT;


-- ----------------------------------------------------------------------------
-- 3. MANTENIMIENTO: UPDATE Y DELETE CON WHERE
-- ----------------------------------------------------------------------------

-- UPDATE: Modifica el precio incrementando un 10% a todos los productos de la categoría 'Accesorios'
UPDATE productos
SET precio = precio * 1.10
WHERE categoria = 'Accesorios';

-- DELETE: Elimina una venta específica filtrando de manera precisa por su id_venta
DELETE FROM ventas
WHERE id_venta = 5;


