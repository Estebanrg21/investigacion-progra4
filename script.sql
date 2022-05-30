DROP DATABASE IF EXISTS feria;
CREATE DATABASE feria;
DROP USER IF EXISTS 'feriaAdmin'@'%';
DROP USER IF EXISTS 'feriaAdmin'@'localhost';
CREATE USER 'feriaAdmin'@'%' IDENTIFIED BY 'root123';
CREATE USER 'feriaAdmin'@'localhost' IDENTIFIED BY 'root123';
GRANT ALL PRIVILEGES ON feria.* TO 'feriaAdmin'@'%';
GRANT ALL PRIVILEGES ON feria.* TO 'feriaAdmin'@'localhost';
USE feria;
CREATE TABLE puestos(
    id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
    descripcion VARCHAR(100) NOT NULL
);
CREATE TABLE productos(
    id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(9,2) NOT NULL
);

CREATE TABLE agricultores(
    id int PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    id_puesto bigint NOT NULL,
    FOREIGN KEY (id_puesto) REFERENCES puestos(id) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (id_puesto)
);

CREATE TABLE puesto_productos(
    id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_puesto bigint NOT NULL,
    id_producto bigint NOT NULL,
    FOREIGN KEY (id_puesto) REFERENCES puestos(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE(id_puesto,id_producto)
);

CREATE TABLE ventas(
    id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_producto bigint NOT NULL,
    id_puesto bigint NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_puesto) REFERENCES puestos(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DELIMITER //
DROP PROCEDURE IF EXISTS checkrows //
CREATE PROCEDURE checkrows (IN id_p BIGINT,IN id_pr BIGINT)
       BEGIN
            DECLARE max_prod_per_puest integer;
            DECLARE max_puest_per_prod integer;
            DECLARE cant_act_prod_puest integer;
            DECLARE cant_act_puest_prod integer;
            SET max_prod_per_puest :=5;
            SET max_puest_per_prod :=3;
            SET cant_act_prod_puest := (select count(id) from puesto_productos where id_puesto = id_p);
            SET cant_act_puest_prod := (select count(id) from puesto_productos where id_producto = id_pr);

            IF cant_act_prod_puest >= max_prod_per_puest then
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Limite de productos por puesto alcanzado';
            END IF;

            IF cant_act_puest_prod >= max_puest_per_prod then
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Limite de puestos vendiendo el mismo producto alcanzado';
            END IF;
END//


DROP TRIGGER IF EXISTS feria.ins_puesto_prod //
CREATE TRIGGER ins_puesto_prod BEFORE INSERT ON puesto_productos FOR EACH ROW
        BEGIN
        CALL checkrows(NEW.id_puesto,NEW.id_producto);
END//


DROP TRIGGER IF EXISTS feria.up_puesto_prod //
CREATE TRIGGER up_puesto_prod BEFORE UPDATE ON puesto_productos FOR EACH ROW
        BEGIN
        CALL checkrows(NEW.id_puesto,NEW.id_producto);
END//

DROP TRIGGER IF EXISTS feria.ins_puestos //
CREATE TRIGGER ins_puestos BEFORE INSERT ON puestos FOR EACH ROW
    BEGIN
        DECLARE cant_act_puest integer;
        DECLARE max_cant_puest integer;
        SET max_cant_puest := 15;
        SET cant_act_puest := (SELECT COUNT(id) FROM puestos);
        IF cant_act_puest >= max_cant_puest then
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Limite de puestos alcanzado';
        END IF;
END//

DROP PROCEDURE IF EXISTS checkventa //
CREATE PROCEDURE checkventa (IN id_p BIGINT,IN id_pr BIGINT)
       BEGIN
        DECLARE exists_relation INT;
        SET exists_relation := (SELECT count(id) FROM puesto_productos WHERE id_puesto=id_p AND id_producto=id_pr);
        IF exists_relation <= 0 THEN
            SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'No existe la relacion entre el puesto y el producto';
        END IF;
END//

DROP TRIGGER IF EXISTS feria.ins_venta //
CREATE TRIGGER ins_venta BEFORE INSERT ON ventas FOR EACH ROW
        BEGIN
        CALL checkventa(NEW.id_puesto,NEW.id_producto);
END//

DROP TRIGGER IF EXISTS feria.up_venta //
CREATE TRIGGER up_venta BEFORE UPDATE ON ventas FOR EACH ROW
        BEGIN
        CALL checkventa(NEW.id_puesto,NEW.id_producto);
END//
DELIMITER ;


-- DELETE FROM puestos;
-- DELETE FROM puesto_productos;
-- DELETE FROM agricultores;
-- DELETE FROM productos;
-- DELETE FROM ventas;
INSERT INTO puestos VALUES (1,"Puesto 1");
INSERT INTO puestos VALUES (2,"Puesto 2");
INSERT INTO puestos VALUES (3,"Puesto 3");
INSERT INTO puestos VALUES (4,"Puesto 4");
INSERT INTO puestos VALUES (5,"Puesto 5");
INSERT INTO agricultores VALUES (1,"Agricultor 1", "Apellido 1", 1);
INSERT INTO agricultores VALUES (2,"Agricultor 2", "Apellido 2", 2);
INSERT INTO agricultores VALUES (3,"Agricultor 3", "Apellido 3", 3);
INSERT INTO agricultores VALUES (4,"Agricultor 4", "Apellido 4", 4);
INSERT INTO agricultores VALUES (5,"Agricultor 5", "Apellido 5", 5);
INSERT INTO productos VALUES (1,"Mandarina",100);
INSERT INTO productos VALUES (2,"Banano",100);
INSERT INTO productos VALUES (3,"Fresa",100);
INSERT INTO productos VALUES (4,"Lechuga",100);
INSERT INTO productos VALUES (5,"Mango",100);
INSERT INTO productos VALUES (6,"Aguacate",100);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (1,1);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (1,3);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (1,4);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (1,5);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (2,1);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (2,3);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (2,5);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (3,1);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (3,2);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (3,3);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (4,2);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (4,3);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (4,4);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (4,5);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (5,2);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (5,3);
INSERT INTO puesto_productos(id_puesto,id_producto) VALUES (5,4);
INSERT INTO ventas (id_producto,id_puesto) VALUES (1,1);
INSERT INTO ventas (id_producto,id_puesto) VALUES (1,1);
INSERT INTO ventas (id_producto,id_puesto) VALUES (1,1);
INSERT INTO ventas (id_producto,id_puesto) VALUES (1,1);
INSERT INTO ventas (id_producto,id_puesto) VALUES (1,1);
INSERT INTO ventas (id_producto,id_puesto) VALUES (1,3);
INSERT INTO ventas (id_producto,id_puesto) VALUES (1,3);
INSERT INTO ventas (id_producto,id_puesto) VALUES (1,3);
INSERT INTO ventas (id_producto,id_puesto) VALUES (1,3);
INSERT INTO ventas (id_producto,id_puesto) VALUES (2,5);
INSERT INTO ventas (id_producto,id_puesto) VALUES (2,5);
INSERT INTO ventas (id_producto,id_puesto) VALUES (2,5);
INSERT INTO ventas (id_producto,id_puesto) VALUES (2,5);
INSERT INTO ventas (id_producto,id_puesto) VALUES (2,5);
INSERT INTO ventas (id_producto,id_puesto) VALUES (3,3);
INSERT INTO ventas (id_producto,id_puesto) VALUES (3,3);
INSERT INTO ventas (id_producto,id_puesto) VALUES (3,3);
INSERT INTO ventas (id_producto,id_puesto) VALUES (3,3);
INSERT INTO ventas (id_producto,id_puesto) VALUES (3,3);
INSERT INTO ventas (id_producto,id_puesto) VALUES (3,3);
INSERT INTO ventas (id_producto,id_puesto) VALUES (3,3);
INSERT INTO ventas (id_producto,id_puesto) VALUES (3,3);
INSERT INTO ventas (id_producto,id_puesto) VALUES (3,3);
INSERT INTO ventas (id_producto,id_puesto) VALUES (4,4);
INSERT INTO ventas (id_producto,id_puesto) VALUES (4,4);
INSERT INTO ventas (id_producto,id_puesto) VALUES (4,4);
INSERT INTO ventas (id_producto,id_puesto) VALUES (4,4);
INSERT INTO ventas (id_producto,id_puesto) VALUES (5,4);
INSERT INTO ventas (id_producto,id_puesto) VALUES (5,4);
INSERT INTO ventas (id_producto,id_puesto) VALUES (5,4);
INSERT INTO ventas (id_producto,id_puesto) VALUES (5,4);
INSERT INTO ventas (id_producto,id_puesto) VALUES (5,4);
INSERT INTO ventas (id_producto,id_puesto) VALUES (5,4);
INSERT INTO ventas (id_producto,id_puesto) VALUES (5,4);