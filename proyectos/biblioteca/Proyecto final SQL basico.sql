-- Proyecto Data Base de biblioteca 
-- Creamos la base de datos
CREATE DATABASE IF NOT EXISTS biblioteca_p;

-- Usamos la base de datos 
USE biblioteca_p;

-- Creación de talbas
CREATE TABLE libros (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	titulo VARCHAR(100) NOT NULL,
	autor VARCHAR(100) NOT NULL,
	año_publicacion INT CHECK(año_publicacion > 0 AND año_publicacion <=2026), 
	disponible BOOLEAN DEFAULT TRUE
);

CREATE TABLE usuarios (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE 
);

CREATE TABLE prestamos (
	id INT AUTO_INCREMENT PRIMARY KEY,
    libro_id INT NOT NULL,
    usuario_id INT NOT NULL,
    fecha_prestamo DATE NOT NULL DEFAULT(CURRENT_DATE),
    fecha_devolucion  DATE NULL,
    CONSTRAINT fk_prestamos_libro FOREIGN KEY (libro_id) REFERENCES libros(id),
    CONSTRAINT fk_prestamos_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);


-- Agragar datos a las tablas.

INSERT INTO libros (titulo, autor, año_publicacion) VALUES
('Cien años de soledad', 'Gabriel Garcia Marquéz', 1967),
('1984', 'George Orwell', 1949),
('El principito', 'Antonie de Saint Exupéry', 1943),
('Harry Potter y la piedra filosofal', 'J.K. Rowling', 1997),
('La sombra del viento', 'Carlos Ruiz Zafón', 2001);

SELECT * FROM libros;

INSERT INTO usuarios (nombre, email) VALUES
('Ana Rodriguez', 'ana@gmail.com'),
('Marcelo Gorriti', 'marcelo@gmail.com'),
('Juan Caballero', 'juan@gmail.com');

SELECT * FROM usuarios;


-- Préstamos activos 
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion) VALUES
(1,1, DATE_SUB(CURRENT_DATE, INTERVAL 5 DAY), NULL),
(3,2, DATE_SUB(CURRENT_DATE, INTERVAL 12 DAY), NULL);

-- Marcar libros prestados como no disponibles 
UPDATE libros
SET disponible = FALSE 
WHERE id IN (1,3);

SELECT * FROM prestamos;

-- Consultas
-- Libros disponibles (solo los no prestados).
SELECT titulo
FROM libros
WHERE disponible = TRUE;

-- Préstamos activos.
-- Días transcurridos desde el préstamo.
SELECT 
	l.titulo AS libro,
    u.nombre AS nombre, 
    p.fecha_prestamo AS fecha_de_prestamo,
    DATEDIFF(CURRENT_DATE, p.fecha_prestamo) AS dias_transcurridos
FROM prestamos p 
INNER JOIN libros l ON p.libro_id = l.id 
INNER JOIN usuarios u ON p.usuario_id = u.id
WHERE p.fecha_devolucion IS NULL;


-- Optimización 
-- Indices de optimización
-- Indexar libros por titulo - Buscar por catalogo 
CREATE INDEX idx_libros_titulo ON libros(titulo);

-- Indexar prestamos por usuarios - historial de prestamos de un usuario
CREATE INDEX idx_prestamos_usuario ON prestamos(usuario_id);