# SQL
TAREA SQL 
Tarea: Evaluación Práctica en SQL sobre el Caso de Smart Desk
Introducción:
Smart Desk es una empresa global dedicada a la fabricación y distribución de mobiliario
de oficina, especializada en soluciones ergonómicas y tecnológicamente avanzadas. En
los últimos años, Smart Desk ha expandido sus operaciones a nivel global, lo que ha
generado la necesidad de analizar datos para ajustar sus estrategias de ventas,
optimizar sus pronósticos y maximizar el beneficio en sus operaciones.
Tu tarea será analizar los datos de Smart Desk utilizando SQL para extraer insights
relevantes, con un enfoque especial en el cálculo de beneficio y la interpretación de las
ventas, que apoyen la toma de decisiones estratégicas en diferentes regiones e
industrias.
Instrucciones Generales:
1. Uso de la plataforma: Deberás realizar esta tarea utilizando la plataforma
Snowflake, donde se cargará y gestionará la base de datos de Smart Desk por
parte del profesor. Si no estás familiarizado con Snowflake, asegúrate de
consultar el material de apoyo proporcionado en el Campus Virtual.
2. Tablas: A continuación, se describen los tres archivos para realizar el análisis.
Estos ya están cargados en Snowflake en el Database de UCM el Schema
SMART_DESK aunque se aportan los .csv por si deseas cargarlo en tu
DATABASE.
Page 2 of 12
IMPORTANTE:
No modifiques el SCHEMA SMART_DESK común de la DATABASE de la
UCM común, ya que es de uso para toda la clase. Recordad que cualquier
modificación que realices puede afectar el trabajo de todos los
compañeros, así que asegúrate de modificar exclusivamente en vuestro
propio entorno.
○ Sales: Contiene datos de ventas reales por cuenta, categoría de producto,
año, trimestre y unidades vendidas.
■ Account (VARCHAR): Identificador único de la cuenta o cliente.
Representa a la empresa que ha comprado productos o servicios.
■ Category (VARCHAR): Categoría del producto vendido.
■ Quarter (VARCHAR): Trimestre en que se realizó la venta.
■ Quarter of Year (VARCHAR): Trimestre del año.
■ Year(NUMBER): El año en el que se realizó la venta.
■ Maintenance ($) (NUMBER): Ingreso generado por servicios de
mantenimiento.
■ Parts ($) (NUMBER): Ingreso generado por la venta de partes o
repuestos.
■ Product ($) (NUMBER): Ingreso generado por la venta de
productos principales.
■ Profit ($) (NUMBER): Beneficio obtenido de la venta, después de
deducir los costes.
■ Support ($) (NUMBER): Ingreso por servicios de soporte técnico o
post-venta.
■ Total ($) (NUMBER): Total de ingresos generados por una
combinación de mantenimiento, partes, producto y soporte. Total de
Ventas
■ Units Sold (NUMBER): Cantidad de unidades vendidas durante la
transacción.
○ Accounts: Esta tabla contiene detalles sobre las cuentas de clientes,
Page 3 of 12
como su ubicación, industria y los contactos relevantes.
■ Account (VARCHAR): Identificador único de la cuenta o cliente.
■ Account Executive (VARCHAR): Nombre del ejecutivo de cuentas
que gestiona la relación con el cliente.
■ Account Level (VARCHAR): Clasificación de la cuenta en función
de su importancia.
■ Contact Email (VARCHAR): Dirección de correo electrónico del
contacto principal de la cuenta.
■ Country (VARCHAR): País en el que se encuentra el cliente.
■ Industry (VARCHAR): Industria a la que pertenece el cliente.
■ Region (VARCHAR): Región geográfica.
○ Forecasts: Proporciona pronósticos de beneficios y oportunidades
comerciales futuras.
■ Account (VARCHAR): Identificador único de la cuenta o cliente.
■ Category (VARCHAR): Categoría de productos o servicios
pronosticados.
■ Prediction Category (VARCHAR): Clasificación del pronóstico.
Pipeline (oportunidades iniciales), Best Case (potenciales
optimistas) y Committed (ventas casi seguras).
■ Forecast ($) (NUMBER): Valor en dólares proyectado como
beneficio futuro.
■ Opportunity Age (NUMBER): Edad de la oportunidad, en días, que
mide cuánto tiempo ha estado abierta la oportunidad de venta. Las
oportunidades son procesos de venta no finalizados.
■ Year(NUMBER): Año del pronóstico
3. Importante: Asegúrate de seleccionar tu contexto correctamente estos archivos
en la plataforma antes de iniciar las consultas. Si tienes problemas con el acceso
a los archivos o con la compresión de los datos, ponte en contacto con el
profesor antes de proceder
4. Especificaciones de las consultas:
○ Evita consultas excesivamente complejas. Se valora más la claridad y
Page 4 of 12
precisión en el código, así como la capacidad para responder con
precisión a lo solicitado.
○ Utiliza funciones de agregación, subconsultas, joins y funciones de
ventana según lo requerido en cada ejercicio.
5. Reflexiones:
○ En cada ejercicio, además de presentar el código SQL, deberás
documentar una reflexión sobre los resultados obtenidos. Estas
reflexiones deben analizar qué información proporcionan los datos, cómo
impactan en la estrategia de la empresa y posibles recomendaciones
basadas en los insights obtenidos.
○ Las reflexiones se entregarán en formato PDF, junto con el Caso Práctico
desarrollado al final del trabajo.
Preguntas a Resolver:
1. Análisis de Ventas y Beneficio por Categoría de Producto para Adabs
Entertainment en 2020
Enunciado: Analiza las ventas y el beneficio total por categoría de producto solo para
los datos de la cuenta Adabs Entertainment durante el año 2020. Debes calcular:
● Ventas
○ Mantenimiento
○ Producto
○ Partes
○ Soporte
○ Totales
● Númerodeunidades vendidas.
● Beneficio total.
Guía:
● Paso1:Selecciona las columnas relevantes.
Page 5 of 12
● Paso 2: Agrupa los resultados por categoría de producto para obtener la suma
de ventas, unidades vendidas, y el beneficio.
● Paso 3: Filtra los resultados para incluir sólo los datos de "Adabs Entertainment"
y del año 2020.
2. Comparación de Ventas, Unidades Vendidas y Beneficio entre Industrias en las
Regiones APAC y EMEA
Enunciado: Compara el rendimiento de ventas entre diferentes industrias en los países
de las regiones APAC y EMEA. Debes calcular agrupando para industria y país:
● Ingreso total por producto.
● Númerodeunidades vendidas.
● Beneficio total.
● Beneficio promedio.
Guía:
● Paso 1: Selecciona los campos que contengan información sobre ventas,
unidades vendidas y beneficios para cada industria.
● Paso 2: Agrupa los resultados por industria y país dentro de las regiones APAC y
EMEA.
● Paso3:Filtra los datos para que solo incluyan las regiones APAC y EMEA.
3. Clasificación de Beneficio por Tipo de Empresa
Enunciado: Calcula el beneficio total por industria y clasifícalo como "Alto" o "Normal"
en función de si supera o no los $1,000,000. Hazlo solo para los datos de las cuentas
cuyo pronóstico total de beneficios en el año 2022 sea superior a $500,000.
Guía:
● Paso 1: Utiliza una subconsulta en la cláusula WHERE para filtrar las cuentas
cuyo pronóstico total sea superior a $500,000.
● Paso2:Agrupa los resultados por industria y calcula el beneficio total.
Page 6 of 12
● Paso 3: Clasifica las industrias en dos categorías de beneficio: "Alto" si el
beneficio supera los $1,000,000, y "Normal" si no lo hace.
4. Comparación de Beneficios para Diferentes Años
Enunciado: Calcula el pronóstico de beneficio para el año 2022 y el beneficio real para
el primer trimestre de 2020 y el tercer trimestre de 2021, agrupando los resultados por
categoría de producto. Además, queremos identificar la oportunidad más antigua y la
más reciente dentro de cada categoría.
Guía:
● Paso 1: Haz un JOIN entre las tablas de ventas y pronósticos utilizando la
categoría de producto y el año.
● Paso 2: Utiliza funciones de agregación para calcular el pronóstico total y el
beneficio. Usa las funciones MIN() y MAX() para identificar la oportunidad más
reciente y la más antigua dentro de cada categoría.
● Paso3:Filtra los datos para que solo incluyan los años y trimestres requeridos.
Pista: Utiliza un tipo de JOIN adecuado por Categoría y País y maneja los valores nulos
según sea necesario para evitar duplicados.
5. Cálculo del Beneficio Acumulado por Trimestre y por Industria
Enunciado: Calcula el beneficio acumulado por trimestre para cada industria, tanto el
beneficio real como el pronosticado. Además, muestra el beneficio total y promedio
también por trimestre e industria junto con los valores acumulados.
Guía:
● Paso 1: Utiliza una función de ventana (OVER) para calcular el beneficio
acumulado real y pronosticado. Asegúrate de utilizar PARTITION BY industry y
ORDERBYtrimestre.
○ Pista: Puedes utilizar la vista Industry Quarter Window como referencia
para estructurar tu consulta.
Page 7 of 12
● Paso 2: Calcula el beneficio total y beneficio promedio por trimestre e industria.
Asegúrate de mostrar estos resultados junto con el beneficio acumulado.
Caso Práctico: Análisis Libre
Como analista de datos en Smart Desk, tu tarea es identificar un insight interesante
utilizando los datos proporcionados. Deberás formular una pregunta de negocio
relevante para mejorar la estrategia de ventas, pronósticos, beneficio o gestión de las
unidades vendidas. Utiliza consultas SQL para justificar tu análisis mostrando los
resultados obtenidos.
Estructura del Caso Práctico:
1. Introducción y análisis exploratorio: Comienza con una breve introducción que
explique la pregunta de negocio (solo debes de desarrollar una) que vas a
abordar y realiza un análisis exploratorio que justifique la relevancia de este
análisis. El análisis exploratorio debe ayudarte a entender la naturaleza de los
datos y a identificar patrones o discrepancias que justifican la pregunta de
negocio.
2. Análisis SQL: Presenta y ejecuta las consultas SQL que respalden tu análisis.
Asegúrate de incluir cálculos de ventas, unidades vendidas y beneficio, o
cualquier otra métrica clave relacionada con la pregunta de negocio que hayas
planteado. Documenta cada consulta SQL con explicaciones claras.
3. Reflexión y sugerencia de estrategias: Con base en los resultados del análisis
SQL, formula una reflexión sobre los insights obtenidos y cómo estos pueden
influir en la estrategia de Smart Desk. Finalmente, sugiere estrategias que la
empresa podría implementar en base a esas conclusiones
Ejemplos de Casos de Uso y Preguntas de Negocio:
1. Crecimiento por región:
○ Pregunta de negocio: ¿Qué región ha experimentado el mayor
crecimiento en ventas y beneficios en 2020 y 2021?
Page 8 of 12
○ Sugerencia: Compara las ventas y el beneficio por región, y analiza si el
crecimiento está impulsado por productos o servicios. Recomienda
estrategias para enfocar recursos en la región con mayor crecimiento.
2. Industrias más rentables:
○ Pregunta de negocio: ¿Qué industrias generan el mayor beneficio y
cuáles tienen un alto volumen de ventas pero bajos márgenes?
○ Sugerencia: Evalúa las ventas y beneficios por industria, identificando
sectores con alto beneficio por transacción. Proponer ajustes de precios o
enfoque en productos de alto margen en esas industrias.
3. Eficiencia del equipo de ventas:
○ Pregunta de negocio: ¿Cuáles son los ejecutivos de cuentas que
gestionan las cuentas más rentables? ¿Hay relación entre el número de
cuentas y el beneficio generado?
○ Sugerencia: Analiza las cuentas gestionadas por cada ejecutivo y el
beneficio generado. Recomienda estrategias para mejorar la distribución
de cuentas o replicar las tácticas de los ejecutivos más exitosos.
4. Caso de Uso libre a elección del alumno: Tienes la oportunidad de formular
una hipótesis propia basada en los datos de Smart Desk. Elige un tema que te
interese: puede ser sobre ventas, beneficios, clientes o regiones. Utiliza SQL
para explorar los datos y justificar tu hipótesis con los resultados obtenidos. Al
final, reflexiona sobre los insights que descubras y cómo podrían aplicarse en la
estrategia de la empresa.
Entrega y Evaluación:
1. Formato de entrega:
○ Archivo .sql o .txt: Este archivo debe contener todas las consultas SQL
realizadas para responder a cada una de las preguntas planteadas.
■ Asegúrate de que cada consulta esté bien organizada y separada
por secciones para facilitar su lectura y corrección.
Page 9 of 12
■ El archivo .sql o .txt debe ser funcional, es decir, las consultas
deben ejecutarse sin errores en Snowflake. Recuerda que puedes
crear un .txt con un bloc de notas pegando tus queries.
○ Documento en formato PDF: Este documento incluirá las reflexiones
sobre los resultados obtenidos en cada ejercicio. Las reflexiones deben
ser claras, concisas y fundamentadas en los datos analizados. El Caso
Práctico también debe desarrollarse dentro de este PDF, en el cual
detallarás tus hipótesis y el análisis basado en los resultados obtenidos
mediante consultas SQL.
■ El PDF debe estar bien estructurado, con una introducción al caso
práctico, desarrollo de las reflexiones y una conclusión final con tus
recomendaciones para Smart Desk.
2. Plataforma de entrega: La entrega de ambos archivos se realizará
exclusivamente a través del Campus Virtual. No se aceptarán entregas por
otros medios como correo electrónico u otras plataformas. Asegúrate de subir
tanto el archivo .sql o .txt como el PDF en la sección correspondiente dentro del
plazo indicado.
3. Plazo de entrega: La fecha límite para la entrega de la tarea está indicada en el
campus virtual . No se admitirán entregas fuera de plazo, salvo que existan
motivos justificados debidamente acreditados y aprobados previamente por el
profesor.
4. Criterios de evaluación:
○ Calidad del código SQL (50%):
■ Se evaluará la corrección y eficiencia de las consultas. Las
consultas deben cumplir con lo solicitado en cada ejercicio y no
presentar errores.
■ Se valorará el uso correcto de funciones de agregación,
subconsultas, joins y funciones de ventana cuando sea necesario.
■ También se considerará la claridad y legibilidad del código.
Page 10 of 12
○ Reflexiones e insights (30%):
■ Las reflexiones deben demostrar una capacidad crítica para
interpretar los resultados obtenidos mediante las consultas SQL. No
basta con describir los datos; es necesario extraer insights y
proponer recomendaciones basadas en el análisis.
■ Se valorará la capacidad de conectar los resultados con la
estrategia empresarial de Smart Desk, así como la profundidad de
las conclusiones.
○ CasoPráctico (20%):
■ Se evaluará la claridad de la pregunta de negocio planteada y la
justificación mediante el análisis exploratorio.
■ Se valorará la implementación correcta del análisis SQL para
sustentar la hipótesis y la capacidad de formular estrategias
basadas en los resultados.
5. Recomendaciones adicionales:
● Revísalo todo antes de entregar: Asegúrate de ejecutar todas las consultas
para verificar que no haya errores. Revisa también que el archivo PDF esté bien
redactado y estructurado.
● Claridad en la documentación: Los comentarios y explicaciones en el código
son tan importantes como el código mismo. Asegúrate de explicar por qué has
tomado ciertas decisiones y qué esperas obtener de cada consulta.
● Consulta con tiempo: Si tienes alguna duda sobre los ejercicios o el uso de la
plataforma Snowflake, asegúrate de plantear con suficiente antelación. No dejes
las consultas y problemas técnicos para el último día.
