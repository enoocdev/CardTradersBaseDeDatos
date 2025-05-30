# CardTraders - Proyecto Base de Datos


**Autor:** Enooc Domínguez Quiroga
**Curso:** 1º DAM - Bases de Datos - Proyecto Final 24/25


## 1. Introducción

CardTraders funciona como un intermediario de confianza en el mundo de las transacciones de cartas coleccionables. Nos encargamos de verificar la autenticidad de las cartas premium y de asegurar que las transacciones entre usuarios sean seguras. La plataforma también gestiona las transacciones para protegerlas, ofrece herramientas como valoraciones de otros usuarios, un catálogo que se actualiza en tiempo real con los precios del mercado y un servicio para resolver disputas. Mi misión es simple: conectar a coleccionistas y jugadores de todo el mundo, haciendo que cada intercambio sea fácil y seguro. Nuestros ingresos vendrán de una comisión del 5% por cada transacción exitosa y de algunos servicios premium, como verificaciones especializadas o la posibilidad de destacar listados de cartas.

Con este proyecto, abordo varios problemas comunes en el mercado de TCG: la dificultad para encontrar compradores o vendedores específicos, la falta de plataformas centralizadas que ofrezcan seguridad (lo que aumenta el riesgo de fraude), los problemas para verificar la autenticidad y el estado de las cartas, y la ausencia de un sistema claro para resolver disputas. CardTraders operará principalmente online, y contaremos con un equipo dedicado a la atención al cliente y a la resolución de conflictos.

## 2. Requisitos Funcionales y Procesos Clave Soportados por la Base de Datos

He diseñado la base de datos para que soporte las siguientes funcionalidades y procesos clave, basándome tanto en la memoria del proyecto como en los requisitos que definiría un cliente:

* **RF01: Gestión de Usuarios:**
    * Permitir que nuevos usuarios se registren con sus datos personales y de contacto.
    * Gestionar el inicio y cierre de sesión.
    * Almacenar y permitir que los usuarios actualicen sus perfiles, incluyendo información sobre su colección personal y su reputación en la plataforma.
    * Implementar un sistema para que los usuarios puedan valorarse entre sí y construir una reputación.

* **RF02: Gestión de Cartas y Catálogo:**
    * Permitir a los usuarios listar sus cartas para la venta o intercambio.
    * Mantener un catálogo detallado de cartas: nombre, juego al que pertenece, edición, rareza, estado de conservación, descripción textual e imágenes. Este catálogo se actualizará con los precios del mercado en tiempo real.
    * Facilitar la búsqueda y el filtrado avanzado de cartas.
    * Incluir un sistema de alertas de precio para que los usuarios estén al tanto de las variaciones.

* **RF03: Autenticación de Cartas:**
    * Soportar un proceso para validar la autenticidad de las cartas "premium" o de alto valor, registrando el resultado de esta validación.

* **RF04: Gestión de Transacciones (Proceso de Compra y Venta):**
    * **Proceso de Venta:**
        * El vendedor crea un listado para su carta, sube fotos, establece el precio y el estado, y define las condiciones de envío.
        * Cuando se produce una venta, el vendedor recibe una notificación.
        * El vendedor tiene 48 horas para confirmar la venta y enviar la carta.
        * Luego, sube el número de seguimiento (tracking number) del envío.
        * El vendedor recibe el pago (menos nuestra comisión del 5%) cuando el comprador confirma que ha recibido la carta.
    * **Proceso de Compra:**
        * El comprador busca la carta que desea, revisa las fotos, la descripción y verifica la reputación del vendedor.
        * Selecciona el método de envío y realiza el pago.
        * Los envíos podrán ser asegurados a través de empresas con las que colaboremos.
    * **Sistema de Garantía y Transacciones:**
        * El dinero de la transacción quedará retenido por la plataforma (un sistema de garantía o escrow).
        * El pago se liberará al vendedor una vez que el comprador confirme que ha recibido la carta satisfactoriamente.
        * El comprador dispondrá de 72 horas tras la recepción para realizar cualquier reclamación.
        * Se registrarán todas las operaciones de compra, venta e intercambio.
        * Se almacenarán los detalles de cada transacción: partes involucradas, cartas, precios acordados y fechas.
        * Se gestionará el estado de las transacciones (por ejemplo: iniciada, en proceso, completada, cancelada).

* **RF05: Sistema de Valoraciones y Reputación:**
    * Permitir a los usuarios valorar las transacciones que han completado y a otros usuarios con los que han interactuado.
    * Calcular y actualizar la reputación de los usuarios basándose en las valoraciones recibidas.

* **RF06: Comunicación y Resolución de Disputas:**
    * Facilitar la comunicación mediante un chat interno entre usuarios.
    * Soportar un sistema para que los usuarios puedan iniciar disputas relacionadas con las transacciones.
    * Registrar la información relevante de cada disputa: partes, motivo, evidencias presentadas y resolución final. Ofreceremos mediación si surgen problemas.

## 3. Diseño de la Base de Datos

He seguido un proceso de normalización para el diseño de la base de datos, buscando asegurar su robustez, eficiencia e integridad:

* **Primera Forma Normal (1NF):** Cada tabla tiene una clave primaria única y todos los atributos contienen valores atómicos. Un ejemplo es la tabla de unión `pedidos_inventarios`, que maneja los múltiples artículos de un pedido.
* **Segunda Forma Normal (2NF):** Los atributos no clave dependen completamente de la clave primaria, algo crucial en tablas con claves compuestas como `cartas_ediciones`.
* **Tercera Forma Normal (3NF):** He eliminado dependencias transitivas mediante tablas de consulta (o "lookup tables") como `rarezas`, `estados_cartas`, `estado_inventarios`, `estado_envio` y `tipos_envios`.

Las relaciones muchos a muchos (N:M) las he resuelto con tablas asociativas, como `cartas_ediciones` (que relaciona cartas y ediciones) y `pedidos_inventarios` (que relaciona pedidos y artículos de inventario). La entidad `mensajes` gestiona la comunicación bidireccional entre usuarios.

También he refinado algunas entidades conceptuales: `Clientes` pasó a ser `usuarios`, `Colecciones` se concretó como `ediciones`, y `Catalogos` evolucionó a `inventarios`. Además, introduje la entidad `direcciones` para normalizar cómo se gestionan las direcciones postales.

### Modelos
* **Modelo Conceptual:** Lo describo en la página 4 de la memoria original (PDF).
* **Modelo Relacional:** Está detallado en la página 5 de la memoria original (PDF).

### Tablas Principales
La base de datos `CardTraders` incluye, entre otras, las siguientes tablas:
`usuarios`, `mensajes`, `direcciones`, `juegos`, `ediciones`, `cartas`, `rarezas`, `cartas_ediciones`, `estados_cartas`, `estado_inventarios`, `inventarios`, `tipos_envios`, `estado_envios`, `pedidos` y `pedidos_inventarios`.

## 4. Script de Creación y Carga de Datos

* **Script de Creación:** El script SQL para crear toda la estructura de la base de datos (tablas, columnas, tipos de datos, claves, restricciones, índices, etc.) se encuentra a partir de la página 7 de la memoria original (PDF).
* **Carga de Datos Inicial:** Muestro ejemplos de cómo cargar datos iniciales en la página 15 del mismo documento.

## 5. Lógica de Negocio en la Base de Datos

He implementado varios objetos en la base de datos para encapsular parte de la lógica de negocio y asegurar la integridad de los datos:

### Funciones Almacenadas
* `totalDeCartas(usuario_id INT) RETURNS INT`: Devuelve el número total de cartas que un usuario tiene en su inventario.
* `totalDeVentas(usuario_id INT) RETURNS INT`: Devuelve el número total de ventas de un usuario (artículos marcados como vendidos en su inventario).
* `valorInventarioDisponible(usuario_id INT) RETURNS DECIMAL(30,2)`: Devuelve el valor total del inventario disponible de un usuario.

### Procedimientos Almacenados
* `ObtenerInventarioUsuarioDisponible(IN p_id_usuario INT)`: Lista los artículos que un usuario específico tiene disponibles en su inventario.
* `BuscarCartasDisponiblesEnInventario(IN p_nombre_carta_parcial VARCHAR(100))`: Busca cartas disponibles en todos los inventarios usando un nombre parcial.
* (Además, en la sección de Casos de Prueba de la memoria PDF, detallo pruebas para un procedimiento llamado `RegistrarPedido`).

### Triggers
* `calcularMediaDeVenta` (se ejecuta ANTES DE INSERTAR en `pedidos_inventarios`): Actualiza el precio medio de una carta en la tabla `cartas` cada vez que se registra una venta de un ítem de inventario.
* `evitarMensajesPropios` (se ejecuta ANTES DE INSERTAR en `mensajes`): Impide que un usuario se envíe mensajes a sí mismo.
* `actualizarValoracionUsuario` (se ejecuta ANTES DE INSERTAR en `pedidos`): Recalcula la valoración media de un usuario cuando se inserta una nueva valoración en un pedido.

## 6. Consultas SQL de Ejemplo

En la memoria original (PDF, páginas 18-21) incluyo varios ejemplos de consultas SQL para extraer información útil, como:
* Listado de artículos disponibles para la venta, con detalles del vendedor, carta, juego, edición, rareza y condición.
* Vendedores con más artículos disponibles.
* Precio medio de cartas por rareza para un juego específico.
* Total gastado por los compradores.
* Cartas que tienen múltiples vendedores.
* Último mensaje recibido por cada usuario.
* Pedidos que contienen al menos un artículo "foil".
* Vendedores cuya valoración media es superior al promedio de todos los vendedores.
* El juego con la mayor cantidad de cartas distintas disponibles.
* Artículos en inventario cuyo precio de venta supera significativamente el precio medio registrado para esa carta.


