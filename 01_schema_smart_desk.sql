-- =====================================================
-- SMART DESK DATABASE SCHEMA
-- =====================================================
-- Este script crea el esquema de base de datos para Smart Desk
-- que incluye información de ventas, productos, clientes e industrias

-- Tabla de Regiones
CREATE TABLE Regiones (
    region_id INT PRIMARY KEY,
    region_nombre VARCHAR(50) NOT NULL
);

-- Tabla de Industrias
CREATE TABLE Industrias (
    industria_id INT PRIMARY KEY,
    industria_nombre VARCHAR(100) NOT NULL
);

-- Tabla de Categorías de Productos
CREATE TABLE Categorias (
    categoria_id INT PRIMARY KEY,
    categoria_nombre VARCHAR(100) NOT NULL
);

-- Tabla de Productos
CREATE TABLE Productos (
    producto_id INT PRIMARY KEY,
    producto_nombre VARCHAR(200) NOT NULL,
    categoria_id INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    costo_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (categoria_id) REFERENCES Categorias(categoria_id)
);

-- Tabla de Clientes
CREATE TABLE Clientes (
    cliente_id INT PRIMARY KEY,
    cliente_nombre VARCHAR(200) NOT NULL,
    industria_id INT NOT NULL,
    region_id INT NOT NULL,
    FOREIGN KEY (industria_id) REFERENCES Industrias(industria_id),
    FOREIGN KEY (region_id) REFERENCES Regiones(region_id)
);

-- Tabla de Ventas
CREATE TABLE Ventas (
    venta_id INT PRIMARY KEY,
    fecha_venta DATE NOT NULL,
    cliente_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_venta DECIMAL(10, 2) NOT NULL,
    costo_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id),
    FOREIGN KEY (producto_id) REFERENCES Productos(producto_id)
);

-- Índices para mejorar el rendimiento de consultas
CREATE INDEX idx_ventas_fecha ON Ventas(fecha_venta);
CREATE INDEX idx_ventas_cliente ON Ventas(cliente_id);
CREATE INDEX idx_ventas_producto ON Ventas(producto_id);
CREATE INDEX idx_clientes_region ON Clientes(region_id);
CREATE INDEX idx_clientes_industria ON Clientes(industria_id);
