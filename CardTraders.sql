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
    nombre_rareza VARCHAR(100) UNIQUE, -- El nombre de la rareza debe ser único
    descripcion TEXT -- Descripción opcional de la rareza
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


# Funciones TRIGGER procedimientos


DELIMITER //
CREATE TRIGGER 
calcularMedia
BEFORE INSERT ON pedidos_inventarios
FOR EACH ROW
BEGIN


    DECLARE carta BIGINT DEFAULT (SELECT id_carta FROM inventarios WHERE id = new.id_inventario);
    DECLARE precioVenta DECIMAL(30,2) DEFAULT (SELECT precio FROM inventarios WHERE id = new.id_inventario);
    DECLARE cartas_de_vendidas BIGINT DEFAULT (SELECT count(id) FROM pedidos_inventarios WHERE (SELECT id_carta FROM inventarios WHERE id = new.id_inventario) = carta);
    
    UPDATE cartas SET precio_medio = ((precio_medio * cartas_de_vendidas) + precioVenta) / if(cartas_de_vendidas = 0,1,cartas_de_vendidas) WHERE cartas.id = carta;

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



