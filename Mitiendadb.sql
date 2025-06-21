-- Crear la base de datos
CREATE DATABASE Mitiendadb;


USE Mitiendadb;


-- TABLAS PRINCIPALES


CREATE TABLE tb_Roles (
    RolID INT IDENTITY(1,1) PRIMARY KEY,
    NombreRol VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(255),
    Note VARCHAR(100)
);

CREATE TABLE tb_Modulos (
    ModuloID INT IDENTITY(1,1) PRIMARY KEY,
    NombreModulo VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(255),
    Icono VARCHAR(50),
    OrdenMenu INT DEFAULT 0
);

CREATE TABLE tb_Permisos (
    PermisoID INT IDENTITY(1,1) PRIMARY KEY,
    RolID INT NOT NULL,
    ModuloID INT NOT NULL,
    PuedeVer BIT DEFAULT 1,
    PuedeEditar BIT DEFAULT 0,
    PuedeEliminar BIT DEFAULT 0,
    PuedeExportar BIT DEFAULT 0,
    FOREIGN KEY (RolID) REFERENCES tb_Roles(RolID),
    FOREIGN KEY (ModuloID) REFERENCES tb_Modulos(ModuloID)
);

CREATE TABLE tb_Usuarios (
    UsuarioID INT IDENTITY(1,1) PRIMARY KEY,
    RolID INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Contrasena VARCHAR(255) NOT NULL,
    Telefono VARCHAR(20),
    Activo BIT DEFAULT 1,
    FechadeNacimiento DATETIME,
    FOREIGN KEY (RolID) REFERENCES tb_Roles(RolID)
);


-- CATÁLOGO Y VENTAS

CREATE TABLE tb_Categorias (
    CategoriaID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255),
    ImagenURL VARCHAR(255),
    CategoriaPadreID INT,
    Orden INT DEFAULT 0,
    FOREIGN KEY (CategoriaPadreID) REFERENCES tb_Categorias(CategoriaID)
);

CREATE TABLE tb_Proveedores (
    ProveedorID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Contacto VARCHAR(100) NOT NULL,
    Telefono VARCHAR(20) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Direccion VARCHAR(255) NOT NULL,
    RUC VARCHAR(20),
    Activo BIT DEFAULT 1
);

CREATE TABLE tb_Productos (
    ProductoID INT IDENTITY(1,1) PRIMARY KEY,
    CategoriaID INT NOT NULL,
    SKU VARCHAR(50) NOT NULL UNIQUE,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Precio DECIMAL(10,2) NOT NULL,
    PrecioOferta DECIMAL(10,2),
    Stock INT NOT NULL,
    StockMinimo INT DEFAULT 5,
    ImagenURL VARCHAR(255),
    Peso DECIMAL(10,3),
    Ancho DECIMAL(10,2),
    Alto DECIMAL(10,2),
    Profundidad DECIMAL(10,2),
    ProveedorID INT,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    FechaUltimaActualizacion DATETIME DEFAULT GETDATE(),
    Activo BIT DEFAULT 1,
    FOREIGN KEY (CategoriaID) REFERENCES tb_Categorias(CategoriaID),
    FOREIGN KEY (ProveedorID) REFERENCES tb_Proveedores(ProveedorID)
);

CREATE TABLE tb_Carritos (
    CarritoID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT NOT NULL,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    FechaActualizacion DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UsuarioID) REFERENCES tb_Usuarios(UsuarioID)
);

CREATE TABLE tb_CarritoItems (
    CarritoItemID INT IDENTITY(1,1) PRIMARY KEY,
    CarritoID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    FechaAgregado DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CarritoID) REFERENCES tb_Carritos(CarritoID),
    FOREIGN KEY (ProductoID) REFERENCES tb_Productos(ProductoID)
);

CREATE TABLE tb_Descuentos (
    DescuentoID INT IDENTITY(1,1) PRIMARY KEY,
    Codigo VARCHAR(50) NOT NULL UNIQUE,
    Porcentaje DECIMAL(5,2) NOT NULL,
    MontoMaximo DECIMAL(10,2),
    FechaInicio DATETIME NOT NULL,
    FechaFin DATETIME NOT NULL,
    UsosMaximos INT,
    UsosActuales INT DEFAULT 0,
    MinimoCompra DECIMAL(10,2) DEFAULT 0,
    Activo BIT DEFAULT 1
);

CREATE TABLE tb_Pedidos (
    PedidoID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT NOT NULL,
    NumeroPedido VARCHAR(20) NOT NULL UNIQUE,
    FechaPedido DATETIME DEFAULT GETDATE(),
    Estado VARCHAR(50) NOT NULL,
    Total DECIMAL(10,2) NOT NULL,
    Impuestos DECIMAL(10,2) DEFAULT 0,
    CostoEnvio DECIMAL(10,2) DEFAULT 0,
    DescuentoID INT,
    DireccionEnvio VARCHAR(255) NOT NULL,
    CiudadEnvio VARCHAR(100) NOT NULL,
    CodigoPostalEnvio VARCHAR(20) NOT NULL,
    MetodoPago VARCHAR(50) NOT NULL,
    NumeroSeguimiento VARCHAR(100),
    FechaEnvio DATETIME,
    FechaEntrega DATETIME,
    Comentarios TEXT,
    FOREIGN KEY (UsuarioID) REFERENCES tb_Usuarios(UsuarioID),
    FOREIGN KEY (DescuentoID) REFERENCES tb_Descuentos(DescuentoID)
);

CREATE TABLE tb_PedidoDetalles (
    PedidoDetalleID INT IDENTITY(1,1) PRIMARY KEY,
    PedidoID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    DescuentoAplicado DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (PedidoID) REFERENCES tb_Pedidos(PedidoID),
    FOREIGN KEY (ProductoID) REFERENCES tb_Productos(ProductoID)
);

CREATE TABLE tb_MovimientosInventario (
    MovimientoID INT IDENTITY(1,1) PRIMARY KEY,
    ProductoID INT NOT NULL,
    CantidadAnterior INT NOT NULL,
    CantidadNueva INT NOT NULL,
    TipoMovimiento VARCHAR(50) NOT NULL,
    FechaMovimiento DATETIME DEFAULT GETDATE(),
    UsuarioID INT NOT NULL,
    PedidoID INT,
    Comentarios VARCHAR(255),
    FOREIGN KEY (ProductoID) REFERENCES tb_Productos(ProductoID),
    FOREIGN KEY (UsuarioID) REFERENCES tb_Usuarios(UsuarioID),
    FOREIGN KEY (PedidoID) REFERENCES tb_Pedidos(PedidoID)
);

CREATE TABLE tb_DireccionesUsuarios (
    DireccionID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT NOT NULL,
    Alias VARCHAR(50) NOT NULL,
    DireccionCompleta VARCHAR(255) NOT NULL,
    Ciudad VARCHAR(100) NOT NULL,
    Estado VARCHAR(100) NOT NULL,
    CodigoPostal VARCHAR(20) NOT NULL,
    Pais VARCHAR(100) NOT NULL,
    TelefonoContacto VARCHAR(20) NOT NULL,
    EsPrincipal BIT DEFAULT 0,
    FOREIGN KEY (UsuarioID) REFERENCES tb_Usuarios(UsuarioID)
);

CREATE TABLE tb_MetodosPagoUsuarios (
    MetodoPagoID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT NOT NULL,
    TipoMetodo VARCHAR(50) NOT NULL,
    Informacion VARCHAR(255) NOT NULL,
    EsDefault BIT DEFAULT 0,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    TokenPago VARCHAR(255),
    FOREIGN KEY (UsuarioID) REFERENCES tb_Usuarios(UsuarioID)
);

CREATE TABLE tb_Resenas (
    ResenaID INT IDENTITY(1,1) PRIMARY KEY,
    ProductoID INT NOT NULL,
    UsuarioID INT NOT NULL,
    Calificacion INT NOT NULL,
    Comentario TEXT,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    Aprobado BIT DEFAULT 0,
    FOREIGN KEY (ProductoID) REFERENCES tb_Productos(ProductoID),
    FOREIGN KEY (UsuarioID) REFERENCES tb_Usuarios(UsuarioID)
);


-- tablas añadidas de susario
-- tabla tb_Generos
CREATE TABLE tb_Generos (
    GeneroID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Codigo VARCHAR(10) NOT NULL UNIQUE
);

-- tabla tb_TiposDocumento
CREATE TABLE tb_TiposDocumento (
    TipoDocumentoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Abreviatura VARCHAR(10) NOT NULL UNIQUE,
    Longitud INT
);

-- tabla tb_Departamentos
CREATE TABLE tb_Departamentos (
    DepartamentoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Codigo VARCHAR(10) NOT NULL UNIQUE
);

-- tabla tb_Municipios
CREATE TABLE tb_Municipios (
    MunicipioID INT IDENTITY(1,1) PRIMARY KEY,
    DepartamentoID INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Codigo VARCHAR(10) NOT NULL,
    FOREIGN KEY (DepartamentoID) REFERENCES tb_Departamentos(DepartamentoID),
    CONSTRAINT UQ_Municipio_Departamento UNIQUE (DepartamentoID, Nombre)
);

-- Modificación de la tabla tb_Usuarios.
ALTER TABLE tb_Usuarios
ADD 
    TipoDocumentoID INT REFERENCES tb_TiposDocumento(TipoDocumentoID),
    NumeroDocumento VARCHAR(20),
    GeneroID INT REFERENCES tb_Generos(GeneroID),
    DepartamentoID INT REFERENCES tb_Departamentos(DepartamentoID),
    MunicipioID INT REFERENCES tb_Municipios(MunicipioID),
    Direccion VARCHAR(255),
    FechaRegistro DATETIME DEFAULT GETDATE();


--INSERTAR DATOS

-- Géneros
INSERT INTO tb_Generos (Nombre, Codigo) VALUES
('Masculino', 'MASC'),
('Femenino', 'FEM'),
('No Binario', 'NB'),
('Otro', 'OTRO');

-- Tipos de Documento (Colombia)
INSERT INTO tb_TiposDocumento (Nombre, Abreviatura, Longitud) VALUES
('Cédula de Ciudadanía', 'CC', 10),
('Tarjeta de Identidad', 'TI', 10),
('Cédula de Extranjería', 'CE', 10),
('Pasaporte', 'PAS', 12),
('Registro Civil', 'RC', 10),
('Número de Identificación Tributaria', 'NIT', 15);

-- Departamentos de Colombia
INSERT INTO tb_Departamentos (Nombre, Codigo) VALUES
('Amazonas', 'AMA'),
('Antioquia', 'ANT'),
('Arauca', 'ARA'),
('Atlántico', 'ATL'),
('Bogotá D.C.', 'DC'),
('Bolívar', 'BOL'),
('Boyacá', 'BOY'),
('Caldas', 'CAL'),
('Caquetá', 'CAQ'),
('Casanare', 'CAS'),
('Cauca', 'CAU'),
('Cesar', 'CES'),
('Chocó', 'CHO'),
('Córdoba', 'COR'),
('Cundinamarca', 'CUN'),
('Guainía', 'GUA'),
('Guaviare', 'GUV'),
('Huila', 'HUI'),
('La Guajira', 'LAG'),
('Magdalena', 'MAG'),
('Meta', 'MET'),
('Nariño', 'NAR'),
('Norte de Santander', 'NSA'),
('Putumayo', 'PUT'),
('Quindío', 'QUI'),
('Risaralda', 'RIS'),
('San Andrés y Providencia', 'SAP'),
('Santander', 'SAN'),
('Sucre', 'SUC'),
('Tolima', 'TOL'),
('Valle del Cauca', 'VAL'),
('Vaupés', 'VAU'),
('Vichada', 'VID');

-- Municipios de Colombia
-- Antioquia
INSERT INTO tb_Municipios (DepartamentoID, Nombre, Codigo) VALUES
(2, 'Medellín', '05001'),
(2, 'Bello', '05088'),
(2, 'Itagüí', '05360'),
(2, 'Envigado', '05266'),
(2, 'Rionegro', '05615');

-- Bogotá D.C.
INSERT INTO tb_Municipios (DepartamentoID, Nombre, Codigo) VALUES
(5, 'Bogotá', '11001'),
(5, 'Usaquén', '11001'),
(5, 'Chapinero', '11001'),
(5, 'Santa Fe', '11001'),
(5, 'San Cristóbal', '11001');

-- Valle del Cauca
INSERT INTO tb_Municipios (DepartamentoID, Nombre, Codigo) VALUES
(31, 'Cali', '76001'),
(31, 'Palmira', '76520'),
(31, 'Buenaventura', '76109'),
(31, 'Tuluá', '76834'),
(31, 'Cartago', '76147');

-- Santander
INSERT INTO tb_Municipios (DepartamentoID, Nombre, Codigo) VALUES
(28, 'Bucaramanga', '68001'),
(28, 'Floridablanca', '68276'),
(28, 'Girón', '68307'),
(28, 'Piedecuesta', '68547'),
(28, 'Barrancabermeja', '68081');

-- Atlántico
INSERT INTO tb_Municipios (DepartamentoID, Nombre, Codigo) VALUES
(4, 'Barranquilla', '08001'),
(4, 'Soledad', '08758'),
(4, 'Malambo', '08433'),
(4, 'Sabanalarga', '08638'),
(4, 'Puerto Colombia', '08573');

-- Roles
INSERT INTO tb_Roles (NombreRol, Descripcion) VALUES
('Administrador', 'Acceso completo al sistema'),
('Cliente', 'Usuario regular que realiza compras'),
('Vendedor', 'Puede gestionar productos y ventas'),
('Inventario', 'Gestiona el stock y almacén');

-- Módulos
INSERT INTO tb_Modulos (NombreModulo, Descripcion, Icono, OrdenMenu) VALUES
('Dashboard', 'Panel principal', 'home', 1),
('Usuarios', 'Gestión de usuarios', 'users', 2),
('Productos', 'Gestión de productos', 'box', 3),
('Ventas', 'Gestión de ventas', 'shopping-cart', 4),
('Reportes', 'Reportes y estadísticas', 'bar-chart-2', 5);

-- Permisos (ejemplo para administrador)
INSERT INTO tb_Permisos (RolID, ModuloID, PuedeVer, PuedeEditar, PuedeEliminar, PuedeExportar)
SELECT 1, ModuloID, 1, 1, 1, 1 FROM tb_Modulos;

-- Insertar 100 usuarios
INSERT INTO tb_Usuarios (RolID, TipoDocumentoID, NumeroDocumento, Nombre, Apellido, GeneroID, Email, Contrasena, Telefono, DepartamentoID, MunicipioID, Direccion, FechadeNacimiento, Activo) VALUES
-- Antioquia (20 usuarios)
(2, 1, '1012345678', 'Juan', 'Gómez', 1, 'juan.gomez@example.com', 'jg123', '3101234567', 2, 1, 'Carrera 43A #1-50', '1985-05-15', 1),
(2, 1, '1023456789', 'María', 'Rodríguez', 2, 'maria.rod@example.com', 'mr456', '3202345678', 2, 2, 'Calle 10 #5-25', '1990-08-22', 1),
(2, 2, '1034567890', 'Carlos', 'López', 1, 'carlos.lopez@example.com', 'cl789', '3003456789', 2, 3, 'Carrera 48 #10-45', '1988-03-10', 1),
(2, 1, '1045678901', 'Ana', 'Martínez', 2, 'ana.martinez@example.com', 'am012', '3154567890', 2, 4, 'Calle 30 Sur #43-20', '1992-11-05', 1),
(2, 3, '1056789012', 'Luis', 'González', 1, 'luis.gonzalez@example.com', 'lg345', '3185678901', 2, 5, 'Carrera 50 #25-30', '1987-07-18', 1),
(2, 1, '1067890123', 'Sofía', 'Pérez', 2, 'sofia.perez@example.com', 'sp678', '3136789012', 2, 1, 'Calle 20 #33-40', '1995-02-28', 1),
(2, 2, '1078901234', 'Andrés', 'Sánchez', 1, 'andres.sanchez@example.com', 'as901', '3007890123', 2, 2, 'Avenida 33 #45-60', '1989-09-12', 1),
(2, 1, '1089012345', 'Laura', 'Ramírez', 2, 'laura.ramirez@example.com', 'lr234', '3208901234', 2, 3, 'Carrera 65 #30-10', '1993-04-25', 1),
(2, 3, '1090123456', 'Pedro', 'Torres', 1, 'pedro.torres@example.com', 'pt567', '3159012345', 2, 4, 'Calle 10 #22-33', '1986-12-08', 1),
(2, 1, '1101234567', 'Diana', 'Díaz', 2, 'diana.diaz@example.com', 'dd890', '3100123456', 2, 5, 'Carrera 80 #28-45', '1991-06-30', 1),
(2, 2, '1112345678', 'Jorge', 'Hernández', 1, 'jorge.hernandez@example.com', 'jh123', '3001122334', 2, 1, 'Avenida 80 #12-18', '1984-10-17', 1),
(2, 1, '1123456789', 'Patricia', 'Muñoz', 2, 'patricia.munoz@example.com', 'pm456', '3202233445', 2, 2, 'Calle 50 #14-22', '1994-01-20', 1),
(2, 3, '1134567890', 'Fernando', 'Rojas', 1, 'fernando.rojas@example.com', 'fr789', '3183344556', 2, 3, 'Carrera 35 #19-27', '1983-07-14', 1),
(2, 1, '1145678901', 'Carolina', 'Vargas', 2, 'carolina.vargas@example.com', 'cv012', '3154455667', 2, 4, 'Calle 25 #30-15', '1996-03-09', 1),
(2, 2, '1156789012', 'Ricardo', 'Silva', 1, 'ricardo.silva@example.com', 'rs345', '3005566778', 2, 5, 'Avenida 40 #25-35', '1982-11-23', 1),
(2, 1, '1167890123', 'Gabriela', 'Castro', 2, 'gabriela.castro@example.com', 'gc678', '3206677889', 2, 1, 'Carrera 50 #10-12', '1997-05-18', 1),
(2, 3, '1178901234', 'Alejandro', 'Mendoza', 1, 'alejandro.mendoza@example.com', 'am901', '3137788990', 2, 2, 'Calle 30 #40-50', '1981-09-05', 1),
(2, 1, '1189012345', 'Natalia', 'Guerrero', 2, 'natalia.guerrero@example.com', 'ng234', '3158899001', 2, 3, 'Avenida 20 #15-25', '1990-12-31', 1),
(2, 2, '1190123456', 'Hugo', 'Navarro', 1, 'hugo.navarro@example.com', 'hn567', '3009900112', 2, 4, 'Carrera 70 #5-8', '1988-04-22', 1),
(2, 1, '1201234567', 'Adriana', 'Ríos', 2, 'adriana.rios@example.com', 'ar890', '3201001223', 2, 5, 'Calle 15 #20-30', '1993-08-15', 1),

-- Bogotá (20 usuarios)
(2, 1, '1212345678', 'Camilo', 'Moreno', 1, 'camilo.moreno@example.com', 'cm123', '3101011121', 5, 6, 'Carrera 7 #40-50', '1987-02-10', 1),
(2, 2, '1223456789', 'Isabel', 'Jiménez', 2, 'isabel.jimenez@example.com', 'ij456', '3201213141', 5, 7, 'Calle 72 #10-15', '1992-06-25', 1),
(2, 1, '1234567890', 'Oscar', 'Peña', 1, 'oscar.pena@example.com', 'op789', '3001314151', 5, 8, 'Avenida 19 #100-20', '1985-11-30', 1),
(2, 3, '1245678901', 'Lucía', 'Duarte', 2, 'lucia.duarte@example.com', 'ld012', '3151415161', 5, 9, 'Carrera 11 #82-30', '1995-03-18', 1),
(2, 1, '1256789012', 'Felipe', 'Ortega', 1, 'felipe.ortega@example.com', 'fo345', '3181516171', 5, 10, 'Calle 100 #11-20', '1989-07-22', 1),
(2, 2, '1267890123', 'Valentina', 'Campos', 2, 'valentina.campos@example.com', 'vc678', '3131617181', 5, 6, 'Avenida 26 #62-40', '1991-09-14', 1),
(2, 1, '1278901234', 'Daniel', 'Vega', 1, 'daniel.vega@example.com', 'dv901', '3001718192', 5, 7, 'Carrera 15 #88-10', '1986-04-05', 1),
(2, 3, '1289012345', 'Sara', 'Paredes', 2, 'sara.paredes@example.com', 'sp234', '3201819202', 5, 8, 'Calle 85 #14-25', '1994-12-08', 1),
(2, 1, '1290123456', 'Javier', 'Cortés', 1, 'javier.cortes@example.com', 'jc567', '3151920212', 5, 9, 'Avenida 68 #45-30', '1983-10-19', 1),
(2, 2, '1301234567', 'Paula', 'Miranda', 2, 'paula.miranda@example.com', 'pm890', '3182021222', 5, 10, 'Carrera 20 #34-50', '1996-01-27', 1),
(2, 1, '1312345678', 'Gustavo', 'Reyes', 1, 'gustavo.reyes@example.com', 'gr123', '3132122232', 5, 6, 'Calle 45 #22-10', '1984-08-11', 1),
(2, 3, '1323456789', 'Camila', 'Soto', 2, 'camila.soto@example.com', 'cs456', '3002223242', 5, 7, 'Avenida 30 #55-20', '1990-05-03', 1),
(2, 1, '1334567890', 'Raúl', 'Contreras', 1, 'raul.contreras@example.com', 'rc789', '3202324252', 5, 8, 'Carrera 9 #70-15', '1988-02-16', 1),
(2, 2, '1345678901', 'Daniela', 'Valenzuela', 2, 'daniela.valenzuela@example.com', 'dv012', '3152425262', 5, 9, 'Calle 80 #12-30', '1993-07-29', 1),
(2, 1, '1356789012', 'Mauricio', 'Aguirre', 1, 'mauricio.aguirre@example.com', 'ma345', '3182526272', 5, 10, 'Avenida 15 #40-25', '1981-12-22', 1),
(2, 3, '1367890123', 'Mariana', 'Fuentes', 2, 'mariana.fuentes@example.com', 'mf678', '3132627282', 5, 6, 'Carrera 45 #25-10', '1997-04-07', 1),
(2, 1, '1378901234', 'Alberto', 'Molina', 1, 'alberto.molina@example.com', 'am901', '3002728293', 5, 7, 'Calle 60 #18-40', '1982-09-13', 1),
(2, 2, '1389012345', 'Claudia', 'Figueroa', 2, 'claudia.figueroa@example.com', 'cf234', '3202829303', 5, 8, 'Avenida 24 #72-15', '1994-11-05', 1),
(2, 1, '1390123456', 'Eduardo', 'Cárdenas', 1, 'eduardo.cardenas@example.com', 'ec567', '3152930313', 5, 9, 'Carrera 30 #45-20', '1987-06-18', 1),
(2, 3, '1401234567', 'Alejandra', 'Santana', 2, 'alejandra.santana@example.com', 'as890', '3183031323', 5, 10, 'Calle 94 #10-25', '1991-03-24', 1),

-- Valle del Cauca (20 usuarios)
(2, 1, '1412345678', 'Julio', 'Méndez', 1, 'julio.mendez@example.com', 'jm123', '3104142434', 31, 11, 'Avenida 4N #35-25', '1988-07-12', 1),
(2, 2, '1423456789', 'Carmen', 'Rangel', 2, 'carmen.rangel@example.com', 'cr456', '3205253545', 31, 12, 'Calle 5 #10-45', '1993-10-05', 1),
(2, 1, '1434567890', 'Roberto', 'Cabrera', 1, 'roberto.cabrera@example.com', 'rc789', '3006364656', 31, 13, 'Carrera 6 #22-30', '1985-04-18', 1),
(2, 3, '1445678901', 'Teresa', 'Villalba', 2, 'teresa.villalba@example.com', 'tv012', '3157475767', 31, 14, 'Avenida 7 #15-40', '1990-12-22', 1),
(2, 1, '1456789012', 'Héctor', 'Salazar', 1, 'hector.salazar@example.com', 'hs345', '3188586878', 31, 15, 'Calle 8 #33-15', '1987-09-30', 1),
(2, 2, '1467890123', 'Verónica', 'Pacheco', 2, 'veronica.pacheco@example.com', 'vp678', '3139697989', 31, 11, 'Carrera 9 #12-25', '1995-02-14', 1),
(2, 1, '1478901234', 'Arturo', 'Delgado', 1, 'arturo.delgado@example.com', 'ad901', '3001701717', 31, 12, 'Avenida 10 #45-50', '1983-11-27', 1),
(2, 3, '1489012345', 'Liliana', 'Castaño', 2, 'liliana.castano@example.com', 'lc234', '3202812828', 31, 13, 'Calle 11 #28-35', '1992-06-08', 1),
(2, 1, '1490123456', 'Fabián', 'Zapata', 1, 'fabian.zapata@example.com', 'fz567', '3153923939', 31, 14, 'Carrera 12 #19-22', '1989-01-19', 1),
(2, 2, '1501234567', 'Marcela', 'Osorio', 2, 'marcela.osorio@example.com', 'mo890', '3184034040', 31, 15, 'Avenida 13 #33-10', '1986-08-03', 1),
(2, 1, '1512345678', 'Rodrigo', 'Bernal', 1, 'rodrigo.bernal@example.com', 'rb123', '3135145151', 31, 11, 'Calle 14 #40-15', '1994-05-26', 1),
(2, 3, '1523456789', 'Gloria', 'Quintero', 2, 'gloria.quintero@example.com', 'gq456', '3006256262', 31, 12, 'Carrera 15 #25-30', '1981-10-09', 1),
(2, 1, '1534567890', 'Mario', 'Franco', 1, 'mario.franco@example.com', 'mf789', '3207367373', 31, 13, 'Avenida 16 #18-45', '1997-03-12', 1),
(2, 2, '1545678901', 'Beatriz', 'Gaitán', 2, 'beatriz.gaitan@example.com', 'bg012', '3158478484', 31, 14, 'Calle 17 #22-20', '1984-12-25', 1),
(2, 1, '1556789012', 'Alonso', 'Bermúdez', 1, 'alonso.bermudez@example.com', 'ab345', '3189589595', 31, 15, 'Avenida 18 #35-10', '1991-07-18', 1),
(2, 3, '1567890123', 'Rosa', 'Velasco', 2, 'rosa.velasco@example.com', 'rv678', '3130690606', 31, 11, 'Carrera 19 #28-15', '1988-04-01', 1),
(2, 1, '1578901234', 'René', 'Arias', 1, 'rene.arias@example.com', 'ra901', '3001708192', 31, 12, 'Calle 20 #40-25', '1983-11-14', 1),
(2, 2, '1589012345', 'Yolanda', 'Córdoba', 2, 'yolanda.cordoba@example.com', 'yc234', '3202819203', 31, 13, 'Avenida 21 #15-30', '1996-08-27', 1),
(2, 1, '1590123456', 'Guillermo', 'Escobar', 1, 'guillermo.escobar@example.com', 'ge567', '3153920314', 31, 14, 'Carrera 22 #33-20', '1989-05-10', 1),
(2, 3, '1601234567', 'Clara', 'Ospina', 2, 'clara.ospina@example.com', 'co890', '3184031425', 31, 15, 'Calle 23 #25-15', '1992-02-23', 1),

-- Santander (20 usuarios)
(2, 1, '1612345678', 'Alfredo', 'Galvis', 1, 'alfredo.galvis@example.com', 'ag123', '3105142536', 28, 16, 'Carrera 24 #30-45', '1987-09-16', 1),
(2, 2, '1623456789', 'Rocío', 'Suárez', 2, 'rocio.suarez@example.com', 'rs456', '3206253647', 28, 17, 'Calle 25 #15-20', '1992-12-29', 1),
(2, 1, '1634567890', 'Germán', 'Pinto', 1, 'german.pinto@example.com', 'gp789', '3007364758', 28, 18, 'Avenida 26 #40-25', '1985-06-12', 1),
(2, 3, '1645678901', 'Silvia', 'Rueda', 2, 'silvia.rueda@example.com', 'sr012', '3158475869', 28, 19, 'Carrera 27 #22-30', '1990-01-25', 1),
(2, 1, '1656789012', 'Raúl', 'Gualteros', 1, 'raul.gualteros@example.com', 'rg345', '3189586970', 28, 20, 'Calle 28 #35-15', '1987-10-08', 1),
(2, 2, '1667890123', 'Olga', 'Barrera', 2, 'olga.barrera@example.com', 'ob678', '3130697081', 28, 16, 'Avenida 29 #18-40', '1995-05-21', 1),
(2, 1, '1678901234', 'Jairo', 'Cifuentes', 1, 'jairo.cifuentes@example.com', 'jc901', '3001708192', 28, 17, 'Carrera 30 #45-50', '1983-12-04', 1),
(2, 3, '1689012345', 'Tania', 'Gómez', 2, 'tania.gomez@example.com', 'tg234', '3202819203', 28, 18, 'Calle 31 #28-35', '1992-07-17', 1),
(2, 1, '1690123456', 'Leonardo', 'Ardila', 1, 'leonardo.ardila@example.com', 'la567', '3153920314', 28, 19, 'Avenida 32 #19-22', '1989-02-28', 1),
(2, 2, '1701234567', 'Nubia', 'Cadena', 2, 'nubia.cadena@example.com', 'nc890', '3184031425', 28, 20, 'Carrera 33 #33-10', '1986-09-11', 1),
(2, 1, '1712345678', 'Hernán', 'Fajardo', 1, 'hernan.fajardo@example.com', 'hf123', '3135142536', 28, 16, 'Calle 34 #40-15', '1994-04-24', 1),
(2, 3, '1723456789', 'Lorena', 'Gamba', 2, 'lorena.gamba@example.com', 'lg456', '3006253647', 28, 17, 'Avenida 35 #25-30', '1981-11-07', 1),
(2, 1, '1734567890', 'Félix', 'Hoyos', 1, 'felix.hoyos@example.com', 'fh789', '3207364758', 28, 18, 'Carrera 36 #18-45', '1997-06-20', 1),
(2, 2, '1745678901', 'Ruby', 'Jaimes', 2, 'ruby.jaimes@example.com', 'rj012', '3158475869', 28, 19, 'Calle 37 #22-20', '1984-01-03', 1),
(2, 1, '1756789012', 'Samuel', 'Klinger', 1, 'samuel.klinger@example.com', 'sk345', '3189586970', 28, 20, 'Avenida 38 #35-10', '1991-08-16', 1),
(2, 3, '1767890123', 'Iris', 'Lizarazo', 2, 'iris.lizarazo@example.com', 'il678', '3130697081', 28, 16, 'Carrera 39 #28-15', '1988-05-29', 1),
(2, 1, '1778901234', 'Víctor', 'Mora', 1, 'victor.mora@example.com', 'vm901', '3001708192', 28, 17, 'Calle 40 #40-25', '1983-12-12', 1),
(2, 2, '1789012345', 'Karen', 'Nieto', 2, 'karen.nieto@example.com', 'kn234', '3202819203', 28, 18, 'Avenida 41 #15-30', '1996-09-25', 1),
(2, 1, '1790123456', 'Óscar', 'Ochoa', 1, 'oscar.ochoa@example.com', 'oo567', '3153920314', 28, 19, 'Carrera 42 #33-20', '1989-04-08', 1),
(2, 3, '1801234567', 'Patricia', 'Pabón', 2, 'patricia.pabon@example.com', 'pp890', '3184031425', 28, 20, 'Calle 43 #25-15', '1992-01-21', 1),

-- Atlántico (20 usuarios)
(2, 1, '1812345678', 'Wilson', 'Quintero', 1, 'wilson.quintero@example.com', 'wq123', '3105142536', 4, 21, 'Carrera 44 #30-45', '1987-10-14', 1),
(2, 2, '1823456789', 'Ximena', 'Reyes', 2, 'ximena.reyes@example.com', 'xr456', '3206253647', 4, 22, 'Calle 45 #15-20', '1992-01-27', 1),
(2, 1, '1834567890', 'Yamil', 'Sarmiento', 1, 'yamil.sarmiento@example.com', 'ys789', '3007364758', 4, 23, 'Avenida 46 #40-25', '1985-08-10', 1),
(2, 3, '1845678901', 'Zulma', 'Téllez', 2, 'zulma.tellez@example.com', 'zt012', '3158475869', 4, 24, 'Carrera 47 #22-30', '1990-03-23', 1),
(2, 1, '1856789012', 'Álvaro', 'Uribe', 1, 'alvaro.uribe@example.com', 'au345', '3189586970', 4, 25, 'Calle 48 #35-15', '1987-12-06', 1),
(2, 2, '1867890123', 'Betsy', 'Vallejo', 2, 'betsy.vallejo@example.com', 'bv678', '3130697081', 4, 21, 'Avenida 49 #18-40', '1995-07-19', 1),
(2, 1, '1878901234', 'César', 'Wiesner', 1, 'cesar.wiesner@example.com', 'cw901', '3001708192', 4, 22, 'Carrera 50 #45-50', '1983-02-02', 1),
(2, 3, '1889012345', 'Dora', 'Ximénez', 2, 'dora.ximenez@example.com', 'dx234', '3202819203', 4, 23, 'Calle 51 #28-35', '1992-09-15', 1),
(2, 1, '1890123456', 'Esteban', 'Yances', 1, 'esteban.yances@example.com', 'ey567', '3153920314', 4, 24, 'Avenida 52 #19-22', '1989-04-28', 1),
(2, 2, '1901234567', 'Flora', 'Zambrano', 2, 'flora.zambrano@example.com', 'fz890', '3184031425', 4, 25, 'Carrera 53 #33-10', '1986-11-09', 1),
(2, 1, '1912345678', 'Gustavo', 'Acosta', 1, 'gustavo.acosta@example.com', 'ga123', '3135142536', 4, 21, 'Calle 54 #40-15', '1994-06-22', 1),
(2, 3, '1923456789', 'Helena', 'Bermúdez', 2, 'helena.bermudez@example.com', 'hb456', '3006253647', 4, 22, 'Avenida 55 #25-30', '1981-01-05', 1),
(2, 1, '1934567890', 'Ignacio', 'Cervantes', 1, 'ignacio.cervantes@example.com', 'ic789', '3207364758', 4, 23, 'Carrera 56 #18-45', '1997-08-18', 1),
(2, 2, '1945678901', 'Julieta', 'Dávila', 2, 'julieta.davila@example.com', 'jd012', '3158475869', 4, 24, 'Calle 57 #22-20', '1984-03-01', 1),
(2, 1, '1956789012', 'Kevin', 'Escorcia', 1, 'kevin.escorcia@example.com', 'ke345', '3189586970', 4, 25, 'Avenida 58 #35-10', '1991-10-14', 1),
(2, 3, '1967890123', 'Leticia', 'Fontalvo', 2, 'leticia.fontalvo@example.com', 'lf678', '3130697081', 4, 21, 'Carrera 59 #28-15', '1988-05-27', 1),
(2, 1, '1978901234', 'Manuel', 'Guerra', 1, 'manuel.guerra@example.com', 'mg901', '3001708192', 4, 22, 'Calle 60 #40-25', '1983-12-10', 1),
(2, 2, '1989012345', 'Nora', 'Hernández', 2, 'nora.hernandez@example.com', 'nh234', '3202819203', 4, 23, 'Avenida 61 #15-30', '1996-09-23', 1),
(2, 1, '1990123456', 'Orlando', 'Iriarte', 1, 'orlando.iriarte@example.com', 'oi567', '3153920314', 4, 24, 'Carrera 62 #33-20', '1989-04-06', 1),
(2, 3, '2001234567', 'Pilar', 'Jaramillo', 2, 'pilar.jaramillo@example.com', 'pj890', '3184031425', 4, 25, 'Calle 63 #25-15', '1992-01-19', 1);

select * from tb_Usuarios;

-- Usuarios Activos
SELECT UsuarioID, Nombre, Apellido, Email, Telefono 
FROM tb_Usuarios 
WHERE Activo = 1
ORDER BY Apellido, Nombre;

--  Usuarios por departamento y municipio
SELECT 
    u.UsuarioID,
    u.Nombre + ' ' + u.Apellido AS NombreCompleto,
    d.Nombre AS Departamento,
    m.Nombre AS Municipio,
    u.Direccion
FROM tb_Usuarios u
JOIN tb_Departamentos d ON u.DepartamentoID = d.DepartamentoID
JOIN tb_Municipios m ON u.MunicipioID = m.MunicipioID
ORDER BY d.Nombre, m.Nombre;

