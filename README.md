# Caso Práctico: Análisis de Datos Smart Desk con SQL

## 📋 Descripción del Proyecto

Este repositorio contiene un caso práctico completo de análisis de datos empresariales para **Smart Desk**, una empresa ficticia de venta de mobiliario de oficina. El proyecto incluye el diseño de base de datos, datos de ejemplo y múltiples análisis SQL que responden a preguntas clave de negocio.

## 🎯 Objetivos del Análisis

El caso práctico aborda los siguientes análisis:

1. **Análisis de ventas y beneficios por categoría**
2. **Comparación entre industrias por región (APAC, EMEA)**
3. **Clasificación de beneficios por industria (alto o normal)**
4. **Comparación de beneficios por años (2023 vs 2024)**
5. **Cálculo acumulado por trimestre e industria**
6. **Caso práctico libre con análisis exploratorio**

## 📁 Estructura del Proyecto

```
SQL/
├── README.md                                          # Este archivo
├── DOCUMENTACION_ANALISIS.md                         # Documentación detallada con hallazgos
├── REFLEXIONES_ESTRATEGICAS.md                       # Reflexiones de negocio basadas en datos
├── 01_schema_smart_desk.sql                          # Esquema de base de datos (DDL)
├── 02_datos_smart_desk.sql                           # Datos de ejemplo (DML)
├── 03_analisis_ventas_beneficios_categoria.sql      # Análisis 1
├── 04_comparacion_industrias_regiones.sql           # Análisis 2
├── 05_clasificacion_beneficios_industria.sql        # Análisis 3
├── 06_comparacion_beneficios_anios.sql              # Análisis 4
├── 07_calculo_acumulado_trimestre_industria.sql     # Análisis 5
└── 08_caso_practico_libre_exploratorio.sql          # Análisis 6
```

## 🗄️ Modelo de Datos

### Tablas Principales

- **Regiones**: Regiones geográficas (APAC, EMEA, LATAM, NA)
- **Industrias**: Sectores industriales de los clientes
- **Categorias**: Categorías de productos
- **Productos**: Catálogo de productos con precios y costos
- **Clientes**: Información de clientes vinculados a industrias y regiones
- **Ventas**: Transacciones de ventas con cantidades y valores

### Relaciones

```
Ventas → Clientes → Industrias
                 → Regiones
Ventas → Productos → Categorias
```

## 🚀 Cómo Usar Este Proyecto

### Paso 1: Crear la Base de Datos

```sql
-- Ejecutar el script de esquema
SOURCE 01_schema_smart_desk.sql;
```

### Paso 2: Cargar Datos de Ejemplo

```sql
-- Ejecutar el script de datos
SOURCE 02_datos_smart_desk.sql;
```

### Paso 3: Ejecutar Análisis

Puedes ejecutar cada archivo de análisis individualmente según tus necesidades:

```sql
-- Ejemplo: Análisis de ventas por categoría
SOURCE 03_analisis_ventas_beneficios_categoria.sql;
```

## 📊 Resumen de Análisis

### 1. Ventas y Beneficios por Categoría
Identifica las categorías más rentables y analiza tendencias mensuales de ventas.

**Métricas clave:**
- Ventas totales por categoría
- Beneficios y márgenes
- Top productos por categoría
- Tendencias mensuales

### 2. Comparación Industrias por Región (APAC vs EMEA)
Compara el rendimiento de diferentes industrias en las regiones clave.

**Métricas clave:**
- Ingresos y beneficios por región e industria
- Diferencias APAC vs EMEA
- Cuota de mercado
- Ticket promedio

### 3. Clasificación de Beneficios por Industria
Clasifica las industrias según su rentabilidad (ALTO, NORMAL, BAJO).

**Métricas clave:**
- Beneficio promedio por transacción
- Margen de beneficio porcentual
- Clasificación por umbral
- Análisis por región

### 4. Comparación de Beneficios por Años
Analiza el crecimiento año sobre año (2023 vs 2024).

**Métricas clave:**
- Beneficios totales por año
- Crecimiento absoluto y porcentual
- Análisis por categoría
- Análisis por industria
- Tendencias mensuales

### 5. Cálculo Acumulado por Trimestre e Industria
Calcula beneficios acumulados por trimestre para análisis de tendencias.

**Métricas clave:**
- Beneficio por trimestre
- Beneficio acumulado anual
- Beneficio acumulado total
- Crecimiento trimestral
- Vista por región, industria y trimestre

### 6. Caso Práctico Libre: Estrategia de Expansión
Análisis exploratorio completo para responder: **¿Qué productos y categorías priorizar por región para maximizar beneficios?**

**Componentes del análisis:**
1. Rendimiento de productos por región (Top 3)
2. Penetración de mercado por categoría
3. Oportunidades de cross-selling
4. Tendencias de crecimiento por categoría
5. Score de priorización ponderado

## 💡 Características Destacadas del SQL

- **Window Functions**: Para cálculos acumulados y rankings
- **CTEs (Common Table Expressions)**: Para consultas complejas y legibles
- **CASE Statements**: Para clasificaciones y segmentaciones
- **Agregaciones Avanzadas**: GROUP BY, ROLLUP para totales
- **Joins Múltiples**: Relaciones entre 5+ tablas
- **Análisis Temporal**: Por año, trimestre, mes
- **Análisis Pivote**: Comparaciones lado a lado

## 📈 Tecnologías y Conceptos

- **SQL Standard**: Compatible con MySQL, PostgreSQL, SQL Server
- **Análisis de Datos**: Métricas de negocio, KPIs
- **Modelado de Datos**: Diseño normalizado (3NF)
- **Business Intelligence**: Análisis exploratorio y descriptivo

## 📚 Casos de Uso

Este proyecto es ideal para:

- ✅ Aprendizaje de SQL avanzado
- ✅ Práctica de análisis de datos
- ✅ Portfolio de análisis de negocios
- ✅ Ejemplos de BI y reporting
- ✅ Preparación para entrevistas de analista de datos

## 🔍 Requisitos

- Sistema de gestión de base de datos SQL (MySQL 5.7+, PostgreSQL 9.6+, o similar)
- Cliente SQL o terminal para ejecutar scripts
- Conocimientos básicos de SQL

## 📖 Documentación Adicional

Para información detallada sobre los hallazgos y reflexiones estratégicas, consulta:

- **DOCUMENTACION_ANALISIS.md**: Resultados esperados y hallazgos de cada análisis
- **REFLEXIONES_ESTRATEGICAS.md**: Insights de negocio y recomendaciones estratégicas

## 👥 Autor

Este caso práctico fue desarrollado como proyecto educativo para demostrar habilidades en SQL y análisis de datos empresariales.

## 📝 Licencia

Este proyecto es de código abierto y está disponible para fines educativos.

---

**Nota**: Los datos utilizados en este proyecto son ficticios y fueron creados únicamente con fines educativos y de demostración. 
