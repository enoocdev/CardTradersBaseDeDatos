DROP DATABASE IF EXISTS CardTraders;
CREATE DATABASE IF NOT EXISTS CardTraders;


USE CardTraders;

CREATE TABLE IF NOT EXISTS usuarios(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(50) UNIQUE,
    dni VARCHAR(50) UNIQUE,
    vendedor BOOLEAN DEFAULT FALSE,
    valoracionMedia INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS mensajes(
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario_enviador INT,
    id_usuario_receptor INT,
    contenido TEXT,
    leido BOOLEAN,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FOREIGN KEY (id_usuario_enviador) REFERENCES usuarios(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FOREIGN KEY (id_usuario_receptor) REFERENCES usuarios(id) ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE IF NOT EXISTS direcciones(
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    pais VARCHAR(50),
    ciudad VARCHAR(50),
    calle VARCHAR(50),
    piso VARCHAR(50),
    codigo_postal INT,
    CONSTRAINT FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS juegos(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    logo VARCHAR(100)

);

CREATE TABLE IF NOT EXISTS ediciones(
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_juego INT,
    nombre_edicion VARCHAR(100),
    fecha_lanzamiento DATE,
    codigo_edicion VARCHAR(50),
    CONSTRAINT FOREIGN KEY (id_juego) REFERENCES juegos(id) ON UPDATE CASCADE ON DELETE RESTRICT

);

CREATE TABLE IF NOT EXISTS cartas(
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    imagen VARCHAR(100),
    precio_medio DECIMAL(30,2) DEFAULT 0
);

CREATE TABLE IF NOT EXISTS rarezas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_rareza VARCHAR(100) UNIQUE, 
    descripcion TEXT
);



CREATE TABLE IF NOT EXISTS cartas_ediciones(
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_carta BIGINT,
    id_edicion INT,
    id_rareza INT,
    CONSTRAINT FOREIGN KEY (id_carta) REFERENCES cartas(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FOREIGN KEY (id_edicion) REFERENCES ediciones(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FOREIGN KEY (id_rareza) REFERENCES rarezas(id) ON UPDATE CASCADE ON DELETE RESTRICT

);

CREATE TABLE IF NOT EXISTS estados_cartas(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_estado VARCHAR(100),
    descripcion TEXT
);

CREATE TABLE IF NOT EXISTS estado_inventarios(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_estado VARCHAR(100),
    descripcion TEXT
);


CREATE TABLE IF NOT EXISTS inventarios(
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    id_carta BIGINT,
    id_estado_carta INT,
    id_estado_en_inventario INT,
    foil BOOLEAN NOT NULL,
    comentario TEXT,
    precio DECIMAL(30,2) CHECK (precio > 0),
    imagen VARCHAR(50),
    CONSTRAINT FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FOREIGN KEY (id_carta) REFERENCES cartas(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FOREIGN KEY (id_estado_carta) REFERENCES estados_cartas(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FOREIGN KEY (id_estado_en_inventario) REFERENCES estado_inventarios(id) ON UPDATE CASCADE ON DELETE RESTRICT
);



CREATE TABLE IF NOT EXISTS tipos_envios(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    descripcion TEXT,
    precio DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS estado_envios(
    id INT PRIMARY KEY AUTO_INCREMENT,
    estado VARCHAR(100),
    descripcion TEXT
);

CREATE TABLE IF NOT EXISTS pedidos(
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    id_direccion_envio INT,
    id_tipo_envio INT,
    id_estado_envio INT,
    comentario TEXT,
    valoracion INT CHECK(valoracion > 0 AND valoracion <= 5),
    CONSTRAINT FOREIGN KEY (id_direccion_envio) REFERENCES direcciones(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FOREIGN KEY (id_tipo_envio) REFERENCES tipos_envios(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FOREIGN KEY (id_estado_envio) REFERENCES estado_envios(id) ON UPDATE CASCADE ON DELETE RESTRICT

);


CREATE TABLE IF NOT EXISTS pedidos_inventarios(
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    id_inventario INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FOREIGN KEY (id_pedido) REFERENCES pedidos(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FOREIGN KEY (id_inventario) REFERENCES inventarios(id) ON UPDATE CASCADE ON DELETE CASCADE
);






-- Insertar datos en la tabla usuarios
INSERT INTO usuarios (nombre, email, telefono, dni, vendedor, valoracionMedia) VALUES
('Juan Perez', 'juan.perez@email.com', '600111222', '12345678A', TRUE, 4),
('Ana Lopez', 'ana.lopez@email.com', '600333444', '87654321B', FALSE, 0),
('Carlos Garcia', 'carlos.garcia@email.com', '600555666', '11223344C', TRUE, 5),
('Laura Martinez', 'laura.martinez@email.com', '600777888', '44556677D', TRUE, 3),
('Pedro Sanchez', 'pedro.sanchez@email.com', '600999000', '99887766E', FALSE, 0);

-- Insertar datos en la tabla juegos
INSERT INTO juegos (nombre, logo) VALUES
('Magic: The Gathering', 'mtg_logo.png'),
('Pokémon TCG', 'pokemon_logo.png'),
('Yu-Gi-Oh!', 'yugioh_logo.png');

-- Insertar datos en la tabla ediciones
INSERT INTO ediciones (id_juego, nombre_edicion, fecha_lanzamiento, codigo_edicion) VALUES
(1, 'Dominaria United', '2022-09-09', 'DMU'),
(1, 'The Brothers'' War', '2022-11-18', 'BRO'),
(2, 'Scarlet & Violet', '2023-03-31', 'SVI'),
(2, 'Paldea Evolved', '2023-06-09', 'PAL'),
(3, 'Power of the Elements', '2022-08-05', 'POTE'),
(3, 'Darkwing Blast', '2022-10-21', 'DABL');

-- Insertar datos en la tabla cartas
INSERT INTO cartas (nombre, imagen, precio_medio) VALUES
('Sheoldred, the Apocalypse', 'sheoldred_apocalypse.png', 75.50),
('Ledger Shredder', 'ledger_shredder.png', 15.25),
('Pikachu VMAX', 'pikachu_vmax.png', 25.00),
('Charizard ex', 'charizard_ex_svi.png', 40.75),
('Spright Blue', 'spright_blue.png', 5.50),
('Tearlaments Kitkallos', 'tearlaments_kitkallos.png', 8.90),
('Sol Ring', 'sol_ring_cmd.png', 1.50),
('Arcane Signet', 'arcane_signet_cmd.png', 0.75),
('Mew VMAX', 'mew_vmax_fs.png', 30.00),
('Blue-Eyes White Dragon', 'blue_eyes_lob.png', 20.00),
('Fable of the Mirror-Breaker', 'fable_mirror_breaker.png', 20.00),
('Ragavan, Nimble Pilferer', 'ragavan_nimble_pilferer.png', 45.00),
('Boseiju, Who Endures', 'boseiju_who_endures.png', 30.00);

-- Insertar datos en la NUEVA tabla rarezas
INSERT INTO rarezas (nombre_rareza, descripcion) VALUES
('Mythic Rare', 'Una de las rarezas más altas en Magic: The Gathering.'),
('Rare', 'Rareza alta, comúnmente encontrada en Magic: The Gathering y otros TCGs.'),
('VMAX', 'Tipo especial de carta Ultra Rara en Pokémon TCG.'),
('Double Rare', 'Una rareza en Pokémon TCG, usualmente indicada con dos estrellas negras.'),
('Super Rare', 'Rareza común en Yu-Gi-Oh! con arte foil.'),
('Ultra Rare', 'Rareza alta en varios TCGs, a menudo con arte y nombre foil.'),
('Uncommon', 'Rareza común, más frecuente que Rara pero menos que Común.'),
('Common', 'La rareza más básica y frecuente en la mayoría de TCGs.');

-- Insertar datos en la tabla cartas_ediciones

INSERT INTO cartas_ediciones (id_carta, id_edicion, id_rareza) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 3, 3),
(4, 3, 4),
(5, 5, 5),
(6, 5, 6),
(7, 1, 7),
(8, 2, 8),
(9, 4, 3), 
(10, 5, 6),
(11, 1, 2),
(12, 2, 1),
(13, 1, 2);


-- Insertar datos en la tabla estados_cartas
INSERT INTO estados_cartas (nombre_estado, descripcion) VALUES
('Mint', 'Perfecto estado, como recién salida del sobre.'),
('Near Mint', 'Mínimas imperfecciones, casi nueva.'),
('Lightly Played', 'Ligero desgaste, pequeños arañazos o bordes algo blancos.'),
('Moderately Played', 'Desgaste notable, algunas dobleces o blanqueamiento.'),
('Heavily Played', 'Desgaste significativo, dobleces, pequeños rotos.'),
('Damaged', 'Daño importante, roturas, dobleces grandes, daño por agua.');

-- Insertar datos en la tabla estado_inventarios
INSERT INTO estado_inventarios (nombre_estado, descripcion) VALUES
('Disponible', 'El artículo está disponible para la venta.'),
('Reservado', 'El artículo está reservado para un comprador.'),
('Vendido', 'El artículo ha sido vendido.'),
('Intercambiado', 'El artículo ha sido intercambiado.'),
('Retirado', 'El vendedor ha retirado el artículo de la venta.');

-- Insertar datos en la tabla inventarios
INSERT INTO inventarios (id_usuario, id_carta, id_estado_carta, id_estado_en_inventario, foil, comentario, precio, imagen) VALUES
(1, 1, 1, 1, FALSE, 'Sheoldred en perfecto estado, ideal para Commander.', 80.00, 'sheoldred_juan_1.png'),
(1, 7, 2, 1, FALSE, 'Sol Ring Near Mint, staple de Commander.', 1.25, 'solring_juan_1.png'),
(3, 4, 1, 1, TRUE, 'Charizard ex foil, directo del sobre a la funda.', 55.00, 'charizard_carlos_1.png'),
(3, 10, 3, 1, FALSE, 'Blue-Eyes White Dragon LOB, Lightly Played.', 18.50, 'blueeyes_carlos_1.png'),
(4, 5, 2, 1, FALSE, 'Spright Blue NM, clave para mazos Spright.', 6.00, 'spright_laura_1.png'),
(1, 11, 2, 1, FALSE, 'Fable of the Mirror-Breaker, Near Mint.', 22.00, 'fable_juan_1.png'),
(3, 12, 1, 1, TRUE, 'Ragavan, Nimble Pilferer, Mint, foil!', 50.00, 'ragavan_carlos_1.png');

-- Insertar datos en la tabla direcciones
INSERT INTO direcciones (id_usuario, pais, ciudad, calle, piso, codigo_postal) VALUES
(1, 'España', 'Madrid', 'Calle Falsa 123', '3A', '28001'),
(2, 'España', 'Barcelona', 'Avenida Diagonal 456', '2B', '08001'),
(3, 'España', 'Valencia', 'Plaza del Ayuntamiento 7', '1C', '46001'),
(4, 'España', 'Sevilla', 'Calle Sierpes 89', 'Bajo', '41001'),
(5, 'España', 'Zaragoza', 'Paseo Independencia 10', '5D', '50001');

-- Insertar datos en la tabla mensajes
INSERT INTO mensajes (id_usuario_enviador, id_usuario_receptor, contenido, fecha, leido) VALUES
(2, 1, 'Hola Juan, ¿está disponible la Sheoldred?', '2023-10-01 10:00:00', TRUE),
(1, 2, 'Hola Ana, sí, sigue disponible.', '2023-10-01 10:05:00', TRUE),
(4, 3, 'Buenas Carlos, ¿aceptarías cambios por el Charizard?', '2023-10-02 15:30:00', FALSE),
(3, 4, 'Hola Laura, de momento solo venta, gracias.', '2023-10-02 15:35:00', FALSE);

-- Insertar datos en la tabla tipos_envios
INSERT INTO tipos_envios (nombre, descripcion, precio) VALUES
('Ordinario', 'Envío estándar sin seguimiento.', 2.50),
('Certificado', 'Envío con número de seguimiento.', 5.50),
('Urgente', 'Envío rápido con seguimiento.', 8.00),
('Punto de Recogida', 'Envío a un punto de recogida cercano.', 4.00);

-- Insertar datos en la tabla estado_envios
INSERT INTO estado_envios (estado, descripcion) VALUES
('Pendiente de Pago', 'Esperando la confirmación del pago.'),
('En Preparación', 'El vendedor está preparando el pedido.'),
('Enviado', 'El pedido ha sido enviado.'),
('En Tránsito', 'El pedido está de camino.'),
('Entregado', 'El pedido ha sido entregado al comprador.'),
('Cancelado', 'El pedido ha sido cancelado.'),
('Devuelto', 'El pedido ha sido devuelto al vendedor.');

-- Insertar datos en la tabla pedidos

INSERT INTO pedidos (id_usuario, id_direccion_envio, id_tipo_envio, id_estado_envio, comentario, valoracion) VALUES
(2, 2, 2, 5, 'Todo perfecto, carta bien protegida.', 5 ), 
(5, 5, 1, 3, 'Esperando el envío.', NULL),                                                                  
(1, 1, 3, 2, NULL, NULL);                                                                                    

-- Insertar datos en la tabla pedidos_inventarios

UPDATE inventarios SET id_estado_en_inventario = 3 WHERE id IN (1, 3, 5); 

INSERT INTO pedidos_inventarios (id_pedido, id_inventario,fecha) VALUES
(1, 1, curdate()),
(2, 3,curdate()),
(3, 5, curdate()); 


DELIMITER //

CREATE TRIGGER calcularMediaDeVenta
BEFORE INSERT ON pedidos_inventarios
FOR EACH ROW
BEGIN
    
    DECLARE v_id_carta_actual BIGINT;
    DECLARE v_precio_venta_actual DECIMAL(30,2);
    DECLARE v_precio_medio_anterior_carta DECIMAL(30,2);
    DECLARE v_cantidad_ventas_anteriores BIGINT;

    SELECT id_carta, precio INTO v_id_carta_actual, v_precio_venta_actual FROM inventarios WHERE id = NEW.id_inventario;
    

        SELECT coalesce(precio_medio, 0.00) INTO v_precio_medio_anterior_carta FROM cartas WHERE id = v_id_carta_actual;

        SELECT count(pi.id) INTO v_cantidad_ventas_anteriores FROM pedidos_inventarios pi JOIN inventarios inv ON pi.id_inventario = inv.id WHERE inv.id_carta = v_id_carta_actual;

        UPDATE cartas SET precio_medio = ( (v_precio_medio_anterior_carta * v_cantidad_ventas_anteriores) + v_precio_venta_actual ) / (v_cantidad_ventas_anteriores + 1) WHERE cartas.id = v_id_carta_actual;


END //

DELIMITER ;


DELIMITER //
CREATE TRIGGER evitarMensajesPropios
BEFORE INSERT ON mensajes
FOR EACH ROW
BEGIN
    IF NEW.id_usuario_enviador = NEW.id_usuario_receptor THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Un usuario no puede enviarse mensajes a si mismo.';
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER actualizarValoracionUsuario
BEFORE INSERT ON pedidos
FOR EACH ROW
BEGIN

    UPDATE usuarios SET valoracion = ((SELECT sum(valoracion) FROM pedidos WHERE id_usuario = new.id_usuario)/(SELECT count(*) FROM pedidos WHERE id_usuario = new.id_usuario)) WHERE id = new.id_usuario;

END;
//
DELIMITER ;


DELIMITER //
CREATE FUNCTION totalDeCartas(usuario_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT count(id) FROM inventarios WHERE id_usuario = usuario_id);
END;
//

DELIMITER //
CREATE FUNCTION totalDeVentas(usuario_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT count(id) FROM inventarios WHERE id_usuario = usuario_id AND id_estado_en_inventario = 3);
END;
//
DELIMITER ;


DELIMITER //
CREATE FUNCTION valorInventario(usuario_id INT)
RETURNS DECIMAL(30,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(30,2) DEFAULT(SELECT SUM(precio) FROM inventarios WHERE id_usuario = usuario_id);
    RETURN IFNULL(total, 0);
END;
//
DELIMITER ;


DROP PROCEDURE IF EXISTS ObtenerInventarioUsuarioDisponible;
DELIMITER //
CREATE PROCEDURE ObtenerInventarioUsuarioDisponible(
    IN p_id_usuario INT
)
BEGIN
    DECLARE v_id_estado_disponible INT DEFAULT 1;

    SELECT i.id  id_inventario, c.nombre  nombre_carta, c.imagen  imagen_carta_generica, i.imagen  imagen_inventario_especifica, e.nombre_edicion, j.nombre  nombre_juego, r.nombre_rareza, ec.nombre_estado  condicion_carta, i.foil, i.precio, i.comentario
    FROM inventarios i
    JOIN cartas c ON i.id_carta = c.id
    JOIN estados_cartas ec ON i.id_estado_carta = ec.id
    JOIN cartas_ediciones ce ON c.id = ce.id_carta 
    JOIN ediciones e ON ce.id_edicion = e.id
    JOIN juegos j ON e.id_juego = j.id
    JOIN rarezas r ON ce.id_rareza = r.id
    WHERE i.id_usuario = p_id_usuario AND i.id_estado_en_inventario = v_id_estado_disponible;

END //
DELIMITER ;

DROP PROCEDURE IF EXISTS BuscarCartasDisponiblesEnInventario;
DELIMITER //

CREATE PROCEDURE BuscarCartasDisponiblesEnInventario( IN p_nombre_carta_parcial VARCHAR(100) )
BEGIN
    DECLARE v_id_estado_disponible INT DEFAULT (SELECT id FROM estado_inventarios WHERE nombre_estado = 'Disponible' LIMIT 1);
    
    

    SELECT i.id  id_inventario, u.nombre  nombre_vendedor, c.nombre  nombre_carta, j.nombre  nombre_juego, e.nombre_edicion, r.nombre_rareza, esc.nombre_estado  condicion_carta, i.foil  es_foil, i.precio  precio_inventario, i.comentario  comentario_inventario, i.imagen  imagen_especifica_inventario
    FROM inventarios i
    JOIN usuarios u ON i.id_usuario = u.id
    JOIN cartas c ON i.id_carta = c.id
    JOIN estados_cartas esc ON i.id_estado_carta = esc.id
    LEFT JOIN ( SELECT ca_ed.id_carta, min(ca_ed.id) edicion_car_id FROM cartas_ediciones ca_ed GROUP BY ca_ed.id_carta)  edicion_car ON c.id = edicion_car.id_carta
    LEFT JOIN cartas_ediciones edicion ON edicion_car.edicion_car_id = edicion.id
    LEFT JOIN ediciones e ON edicion.id_edicion = e.id
    LEFT JOIN juegos j ON e.id_juego = j.id
    LEFT JOIN rarezas r ON edicion.id_rareza = r.id
    WHERE i.id_estado_en_inventario = v_id_estado_disponible AND (p_nombre_carta_parcial IS NULL OR c.nombre LIKE concat('%', p_nombre_carta_parcial, '%')) ORDER BY c.nombre ASC, i.precio ASC;

END //
DELIMITER ;



CALL ObtenerInventarioUsuarioDisponible(1);
CALL BuscarCartasDisponiblesEnInventario('Blue-Eyes');



-- Usar la base de datos CardTraders
USE CardTraders;
SELECT
    i.id  id_inventario,
    u.nombre  nombre_vendedor,
    c.nombre  nombre_carta,
    j.nombre  nombre_juego,
    e.nombre_edicion,
    r.nombre_rareza,
    esc.nombre_estado  condicion_carta,
    i.foil,
    i.precio  precio_venta,
    i.comentario
FROM inventarios i
JOIN usuarios u ON i.id_usuario = u.id
JOIN cartas c ON i.id_carta = c.id
JOIN estados_cartas esc ON i.id_estado_carta = esc.id
JOIN estado_inventarios esi ON i.id_estado_en_inventario = esi.id
LEFT JOIN cartas_ediciones ce ON c.id = ce.id_carta
LEFT JOIN ediciones e ON ce.id_edicion = e.id
LEFT JOIN juegos j ON e.id_juego = j.id 
LEFT JOIN rarezas r ON ce.id_rareza = r.id 
WHERE esi.nombre_estado = 'Disponible'
ORDER BY u.nombre, c.nombre;


SELECT
    u.nombre  nombre_vendedor,
    COUNT(i.id)  cantidad_articulos_disponibles
FROM usuarios u
JOIN inventarios i ON u.id = i.id_usuario
JOIN estado_inventarios esi ON i.id_estado_en_inventario = esi.id
WHERE u.vendedor = TRUE AND esi.nombre_estado = 'Disponible'
GROUP BY u.id, u.nombre
HAVING COUNT(i.id) > 1
ORDER BY cantidad_articulos_disponibles DESC;

SELECT
    j.nombre  nombre_juego,
    r.nombre_rareza,
    AVG(i.precio)  precio_medio_rareza
FROM inventarios i
JOIN cartas c ON i.id_carta = c.id
JOIN cartas_ediciones ce ON c.id = ce.id_carta
JOIN rarezas r ON ce.id_rareza = r.id
JOIN ediciones ed ON ce.id_edicion = ed.id
JOIN juegos j ON ed.id_juego = j.id
JOIN estado_inventarios esi ON i.id_estado_en_inventario = esi.id
WHERE j.id = 1 AND esi.nombre_estado = 'Disponible'
GROUP BY j.nombre, r.nombre_rareza
ORDER BY precio_medio_rareza DESC;

SELECT
    u.nombre  nombre_comprador,
    count( p.id)  numero_de_pedidos,
    sum(inv.precio)  total_gastado 
FROM usuarios u
JOIN pedidos p ON u.id = p.id_usuario
JOIN pedidos_inventarios pi ON p.id = pi.id_pedido
JOIN inventarios inv ON pi.id_inventario = inv.id 
GROUP BY u.id, u.nombre
HAVING numero_de_pedidos > 0 
ORDER BY total_gastado DESC;


SELECT
    c.nombre AS nombre_carta,
    count(DISTINCT i.id_usuario)  numero_de_vendedores
FROM cartas c
JOIN inventarios i ON c.id = i.id_carta
JOIN estado_inventarios esi ON i.id_estado_en_inventario = esi.id
WHERE esi.nombre_estado = 'Disponible'
GROUP BY c.id, c.nombre
HAVING numero_de_vendedores >= 2 
ORDER BY numero_de_vendedores DESC;

SELECT
    u.nombre  nombre_usuario_receptor,
    m.contenido  ultimo_mensaje_recibido,
    m.fecha  fecha_ultimo_mensaje,
    env.nombre  nombre_emisor
FROM usuarios u
JOIN mensajes m ON u.id = m.id_usuario_receptor
JOIN usuarios env ON m.id_usuario_enviador = env.id
WHERE m.fecha = (
    SELECT max(m2.fecha)
    FROM mensajes m2
    WHERE m2.id_usuario_receptor = u.id
)
ORDER BY u.nombre;

SELECT
    p.id  id_pedido,
    u.nombre  nombre_comprador,
    sum(inv.precio)  valor_total_pedido_con_foil
FROM pedidos p
JOIN usuarios u ON p.id_usuario = u.id
JOIN pedidos_inventarios pi ON p.id = pi.id_pedido
JOIN inventarios inv ON pi.id_inventario = inv.id 
WHERE EXISTS (
    SELECT 1
    FROM pedidos_inventarios pi_sub
    JOIN inventarios i_sub ON pi_sub.id_inventario = i_sub.id
    WHERE pi_sub.id_pedido = p.id AND i_sub.foil = TRUE
)
GROUP BY p.id, u.nombre
ORDER BY valor_total_pedido_con_foil DESC;


SELECT
    u.nombre,
    u.valoracionMedia
FROM usuarios u
WHERE u.vendedor = TRUE AND u.valoracionMedia > (
    SELECT AVG(u2.valoracionMedia)
    FROM usuarios u2
    WHERE u2.vendedor = TRUE AND u2.valoracionMedia > 0 
);


SELECT
    j.nombre AS nombre_juego,
    count(i.id_carta)  cantidad_cartas_distintas_disponibles
FROM juegos j
JOIN ediciones e ON j.id = e.id_juego
JOIN cartas_ediciones ce ON e.id = ce.id_edicion
JOIN inventarios i ON ce.id_carta = i.id_carta
JOIN estado_inventarios esi ON i.id_estado_en_inventario = esi.id
WHERE esi.nombre_estado = 'Disponible'
GROUP BY j.id, j.nombre
ORDER BY cantidad_cartas_distintas_disponibles DESC
LIMIT 1;


SELECT
    c.nombre  nombre_carta,
    c.precio_medio  precio_medio_registrado,
    i.precio  precio_venta_inventario,
    u.nombre  nombre_vendedor,
    ((i.precio - c.precio_medio) / c.precio_medio) * 100  porcentaje_diferencia
FROM inventarios i
JOIN cartas c ON i.id_carta = c.id
JOIN usuarios u ON i.id_usuario = u.id
JOIN estado_inventarios esi ON i.id_estado_en_inventario = esi.id
WHERE esi.nombre_estado = 'Disponible'
  AND c.precio_medio > 0 
  AND i.precio > (c.precio_medio * 1.20)
ORDER BY porcentaje_diferencia DESC;


SELECT valorInventarioDisponible(3);



