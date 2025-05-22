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



CREATE TABLE IF NOT EXISTS cartas_ediciones(
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_carta BIGINT,
    id_edicion INT,
    rareza VARCHAR(100),
    CONSTRAINT FOREIGN KEY (id_carta) REFERENCES cartas(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FOREIGN KEY (id_edicion) REFERENCES ediciones(id) ON UPDATE CASCADE ON DELETE RESTRICT

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
    id_tipo_envio INT,
    id_estado_envio INT,
    comentario TEXT,
    valoracion INT CHECK(valoracion > 0 AND valoracion <= 5),
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
    CONSTRAINT FOREIGN KEY (id_cartas_inventario) REFERENCES inventarios(id) ON UPDATE CASCADE ON DELETE CASCADE
);




DELIMITER //
CREATE TRIGGER 
calcularMedia
BEFORE INSERT ON pedidos_inventarios
FOR EACH ROW
BEGIN


    DECLARE carta BIGINT DEFAULT (SELECT id_carta FROM inventarios WHERE id = new.id_inventario);
    DECLARE precioVenta DECIMAL(30,2) DEFAULT (SELECT precio FROM inventarios WHERE id = new.id_inventario);
    DECLARE cartas_de_vendidas BIGINT DEFAULT (SELECT count(id) FROM pedidos_inventarios WHERE (SELECT id_carta FROM inventarios WHERE id = new.id_inventario) = carta);
    
    UPDATE cartas SET precio_medio = ((precio_medio * cartas_de_vendidas) + precioVenta)/ MAX(cartas_de_vendidas,1) WHERE cartas.id = carta;

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

