DROP DATABASE IF EXISTS feria;
CREATE DATABASE feria;
DROP USER IF EXISTS 'feriaAdmin'@'%';
DROP USER IF EXISTS 'feriaAdmin'@'localhost';
CREATE USER 'feriaAdmin'@'%' IDENTIFIED BY 'root123';
CREATE USER 'feriaAdmin'@'localhost' IDENTIFIED BY 'root123';
GRANT ALL PRIVILEGES ON scot.* TO 'feriaAdmin'@'%';
GRANT ALL PRIVILEGES ON scot.* TO 'feriaAdmin'@'localhost';
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
    puesto_id bigint NOT NULL,
    FOREIGN KEY (puesto_id) REFERENCES puestos(id) ON UPDATE CASCADE ON DELETE CASCADE
);

