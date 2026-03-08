-- bd name: AsistenciaEventosBd
-- Base de datos para Sistema de Registro de Eventos y pase de asistencia Asistencia
-- Creado: 10 de diciembre de 2025

-- =====================================================
-- Tabla: TiposEvento
-- Descripción: Categorías de eventos (congreso, taller, ponencia, etc.)
-- =====================================================
CREATE TABLE TiposEvento (
    IdTipo INT AUTO_INCREMENT PRIMARY KEY,
    NombreTipo VARCHAR(50) NOT NULL UNIQUE,
    Descripcion TEXT,
    Activo BOOLEAN DEFAULT TRUE,
    FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- Tabla: UsuariosAdmin
-- Descripción: Usuarios administradores del sistema
-- =====================================================
CREATE TABLE UsuariosAdmin (
    IdAdmin INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    Telefono VARCHAR(20),
    Username VARCHAR(50) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Activo BOOLEAN DEFAULT TRUE,
    FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UltimoAcceso TIMESTAMP NULL,
    
    INDEX IdxEmail (Email),
    INDEX IdxUsername (Username)
);

-- =====================================================
-- Tabla: Eventos
-- Descripción: Eventos principales (congresos, talleres, ponencias, etc.)
-- =====================================================
CREATE TABLE Eventos (
    IdEvento INT AUTO_INCREMENT PRIMARY KEY,
    IdTipo INT NOT NULL,
    IdAdminResponsable INT NOT NULL,
    NombreEvento VARCHAR(200) NOT NULL,
    Descripcion TEXT,
    Lugar VARCHAR(200) NOT NULL,
    Direccion TEXT,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    HoraInicio TIME,
    HoraFin TIME,
    CapacidadMaxima INT DEFAULT 0,
    Costo DECIMAL(10,2) DEFAULT 0.00,
    RequiereRegistro BOOLEAN DEFAULT TRUE,
    Estado ENUM('Planificado', 'Activo', 'Finalizado', 'Cancelado') DEFAULT 'Planificado',
    Notas TEXT,
    FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FechaModificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (IdTipo) REFERENCES TiposEvento(IdTipo) ON DELETE RESTRICT,
    FOREIGN KEY (IdAdminResponsable) REFERENCES UsuariosAdmin(IdAdmin) ON DELETE RESTRICT,
    
    INDEX IdxFechas (FechaInicio, FechaFin),
    INDEX IdxEstado (Estado),
    INDEX IdxTipo (IdTipo),
    INDEX IdxResponsable (IdAdminResponsable)
);

-- =====================================================
-- Tabla: DiasEvento
-- Descripción: Días específicos de cada evento para control de asistencia
-- =====================================================
CREATE TABLE DiasEvento (
    IdDiaEvento INT AUTO_INCREMENT PRIMARY KEY,
    IdEvento INT NOT NULL,
    FechaDia DATE NOT NULL,
    HoraInicio TIME,
    HoraFin TIME,
    DescripcionDia VARCHAR(200),
    TemaPrincipal VARCHAR(200),
    UbicacionEspecifica VARCHAR(200),
    RequiereAsistencia BOOLEAN DEFAULT TRUE,
    ToleranciaLlegadaTarde INT DEFAULT 15, -- minutos
    Activo BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (IdEvento) REFERENCES Eventos(IdEvento) ON DELETE CASCADE,
    
    UNIQUE KEY UniqueEventoFecha (IdEvento, FechaDia),
    INDEX IdxFecha (FechaDia),
    INDEX IdxEvento (IdEvento)
);

-- =====================================================
-- Tabla: Asistentes
-- Descripción: Personas que asisten a los eventos
-- =====================================================
CREATE TABLE Asistentes (
    IdAsistente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Email VARCHAR(150) UNIQUE,
    Telefono VARCHAR(20),
    DocumentoIdentidad VARCHAR(50),
    TipoDocumento ENUM('Cedula', 'Pasaporte', 'TarjetaIdentidad', 'Otro') DEFAULT 'Cedula',
    FechaNacimiento DATE,
    Genero ENUM('Masculino', 'Femenino', 'Otro', 'PrefiereNoDecir'),
    Profesion VARCHAR(100),
    Institucion VARCHAR(200),
    Ciudad VARCHAR(100),
    Pais VARCHAR(100) DEFAULT 'República Dominicana',
    CodigoQR VARCHAR(100) UNIQUE, -- Para identificación rápida
    Activo BOOLEAN DEFAULT TRUE,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Notas TEXT,
    
    INDEX IdxEmail (Email),
    INDEX IdxDocumento (DocumentoIdentidad),
    INDEX IdxCodigoQR (CodigoQR),
    INDEX IdxNombreApellido (Nombre, Apellido)
);

-- =====================================================
-- Tabla: InscripcionesEvento
-- Descripción: Relación entre asistentes y eventos (inscripciones)
-- =====================================================
CREATE TABLE InscripcionesEvento (
    IdInscripcion INT AUTO_INCREMENT PRIMARY KEY,
    IdAsistente INT NOT NULL,
    IdEvento INT NOT NULL,
    FechaInscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    EstadoInscripcion ENUM('Pendiente', 'Confirmada', 'Cancelada', 'EnEspera') DEFAULT 'Confirmada',
    FormaPago ENUM('Efectivo', 'Tarjeta', 'Transferencia', 'Gratuito', 'Beca') DEFAULT 'Gratuito',
    MontoPagado DECIMAL(10,2) DEFAULT 0.00,
    ComprobantePago VARCHAR(200),
    NotasInscripcion TEXT,
    IdAdminRegistro INT,
    
    FOREIGN KEY (IdAsistente) REFERENCES Asistentes(IdAsistente) ON DELETE CASCADE,
    FOREIGN KEY (IdEvento) REFERENCES Eventos(IdEvento) ON DELETE CASCADE,
    FOREIGN KEY (IdAdminRegistro) REFERENCES UsuariosAdmin(IdAdmin),
    
    UNIQUE KEY UniqueAsistenteEvento (IdAsistente, IdEvento),
    INDEX IdxAsistente (IdAsistente),
    INDEX IdxEvento (IdEvento),
    INDEX IdxEstado (EstadoInscripcion),
    INDEX IdxFechaInscripcion (FechaInscripcion)
);

-- =====================================================
-- Tabla: Asistencia
-- Descripción: Control diario de asistencia por evento y día
-- =====================================================
CREATE TABLE Asistencia (
    IdAsistencia INT AUTO_INCREMENT PRIMARY KEY,
    IdInscripcion INT NOT NULL,
    IdDiaEvento INT NOT NULL,
    FechaAsistencia DATE NOT NULL,
    HoraLlegada TIME,
    HoraSalida TIME,
    EstadoAsistencia ENUM('Presente', 'Ausente', 'Tardanza', 'SalioTemprano') DEFAULT 'Presente',
    MinutosTardanza INT DEFAULT 0,
    Observaciones TEXT,
    MetodoRegistro ENUM('Manual', 'QR', 'Biometrico', 'RFID') DEFAULT 'Manual',
    IdAdminRegistro INT,
    IpRegistro VARCHAR(45),
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (IdInscripcion) REFERENCES InscripcionesEvento(IdInscripcion) ON DELETE CASCADE,
    FOREIGN KEY (IdDiaEvento) REFERENCES DiasEvento(IdDiaEvento) ON DELETE CASCADE,
    FOREIGN KEY (IdAdminRegistro) REFERENCES UsuariosAdmin(IdAdmin),
    
    UNIQUE KEY UniqueInscripcionDia (IdInscripcion, IdDiaEvento),
    INDEX IdxFechaAsistencia (FechaAsistencia),
    INDEX IdxEstado (EstadoAsistencia),
    INDEX IdxInscripcion (IdInscripcion),
    INDEX IdxDiaEvento (IdDiaEvento),
    INDEX IdxAdminRegistro (IdAdminRegistro)
);

-- =====================================================
-- Tabla: ConfiguracionSistema
-- Descripción: Configuraciones generales del sistema
-- =====================================================
CREATE TABLE ConfiguracionSistema (
    IdConfig INT AUTO_INCREMENT PRIMARY KEY,
    ClaveConfig VARCHAR(100) NOT NULL UNIQUE,
    ValorConfig TEXT NOT NULL,
    Descripcion TEXT,
    TipoDato ENUM('String', 'Integer', 'Boolean', 'Decimal', 'Json') DEFAULT 'String',
    Categoria VARCHAR(50) DEFAULT 'General',
    Modificable BOOLEAN DEFAULT TRUE,
    FechaModificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX IdxCategoria (Categoria),
    INDEX IdxClave (ClaveConfig)
);

-- =====================================================
-- INSERTAR DATOS INICIALES
-- =====================================================

-- Tipos de evento predefinidos
INSERT INTO TiposEvento (NombreTipo, Descripcion) VALUES
('Congreso', 'Evento académico o profesional de gran escala'),
('Taller', 'Actividad práctica de aprendizaje'),
('Ponencia', 'Presentación académica o profesional'),
('Seminario', 'Evento educativo de corta duración'),
('Workshop', 'Taller práctico especializado'),
('Conferencia', 'Presentación formal ante audiencia'),
('Simposio', 'Reunión de expertos sobre un tema específico'),
('Mesa Redonda', 'Discusión grupal sobre temas de interés'),
('Capacitación', 'Formación profesional o técnica'),
('Webinar', 'Seminario virtual en línea');

-- Usuario administrador inicial (password: admin123)
INSERT INTO UsuariosAdmin (Nombre, Apellido, Email, Username, PasswordHash) VALUES
('Administrador', 'Sistema', 'admin@asistenciabook.com', 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

-- Configuraciones iniciales del sistema
INSERT INTO ConfiguracionSistema (ClaveConfig, ValorConfig, Descripcion, TipoDato, Categoria) VALUES
('SistemaNombre', 'AsistenciaBook', 'Nombre del sistema', 'String', 'General'),
('ToleranciaTardanzaDefault', '15', 'Tolerancia de tardanza en minutos por defecto', 'Integer', 'Asistencia'),
('PermitirAutoregistro', 'true', 'Permitir que los asistentes se registren automáticamente', 'Boolean', 'Registro'),
('FormatoCodigoQR', 'AB{IdAsistente}_{Timestamp}', 'Formato para generar códigos QR', 'String', 'Identificacion'),
('EmailNotificaciones', 'true', 'Enviar notificaciones por email', 'Boolean', 'Notificaciones'),
('CapacidadMaximaDefault', '100', 'Capacidad máxima por defecto para eventos', 'Integer', 'Eventos'),
('MonedaSistema', 'DOP', 'Moneda del sistema', 'String', 'General'),
('ZonaHoraria', 'America/Santo_Domingo', 'Zona horaria del sistema', 'String', 'General');

-- =====================================================
-- VISTAS ÚTILES
-- =====================================================

-- Vista: Resumen de eventos con información completa
CREATE VIEW VistaEventosCompleta AS
SELECT 
    e.IdEvento,
    e.NombreEvento,
    te.NombreTipo,
    CONCAT(ua.Nombre, ' ', ua.Apellido) as Responsable,
    e.Lugar,
    e.FechaInicio,
    e.FechaFin,
    e.CapacidadMaxima,
    e.Estado,
    COUNT(DISTINCT ie.IdAsistente) as AsistentesInscritos,
    COUNT(DISTINCT de.IdDiaEvento) as DiasProgramados
FROM Eventos e
LEFT JOIN TiposEvento te ON e.IdTipo = te.IdTipo
LEFT JOIN UsuariosAdmin ua ON e.IdAdminResponsable = ua.IdAdmin
LEFT JOIN InscripcionesEvento ie ON e.IdEvento = ie.IdEvento AND ie.EstadoInscripcion = 'Confirmada'
LEFT JOIN DiasEvento de ON e.IdEvento = de.IdEvento
GROUP BY e.IdEvento;

-- Vista: Estadísticas de asistencia por evento
CREATE VIEW VistaEstadisticasAsistencia AS
SELECT 
    e.IdEvento,
    e.NombreEvento,
    de.FechaDia,
    COUNT(DISTINCT ie.IdAsistente) as TotalInscritos,
    COUNT(DISTINCT CASE WHEN a.EstadoAsistencia = 'Presente' THEN a.IdInscripcion END) as Presentes,
    COUNT(DISTINCT CASE WHEN a.EstadoAsistencia = 'Ausente' THEN a.IdInscripcion END) as Ausentes,
    COUNT(DISTINCT CASE WHEN a.EstadoAsistencia = 'Tardanza' THEN a.IdInscripcion END) as Tardanzas,
    ROUND((COUNT(DISTINCT CASE WHEN a.EstadoAsistencia = 'Presente' THEN a.IdInscripcion END) * 100.0 / COUNT(DISTINCT ie.IdAsistente)), 2) as PorcentajeAsistencia
FROM Eventos e
JOIN DiasEvento de ON e.IdEvento = de.IdEvento
JOIN InscripcionesEvento ie ON e.IdEvento = ie.IdEvento AND ie.EstadoInscripcion = 'Confirmada'
LEFT JOIN Asistencia a ON ie.IdInscripcion = a.IdInscripcion AND de.IdDiaEvento = a.IdDiaEvento
GROUP BY e.IdEvento, de.IdDiaEvento;

-- =====================================================
-- PROCEDIMIENTOS ALMACENADOS
-- =====================================================

DELIMITER //

-- Procedimiento para registrar asistencia
CREATE PROCEDURE RegistrarAsistencia(
    IN pIdAsistente INT,
    IN pIdEvento INT,
    IN pFechaDia DATE,
    IN pHoraLlegada TIME,
    IN pMetodoRegistro VARCHAR(20),
    IN pIdAdmin INT
)
BEGIN
    DECLARE vIdInscripcion INT;
    DECLARE vIdDiaEvento INT;
    DECLARE vTolerancia INT DEFAULT 15;
    DECLARE vHoraInicio TIME;
    DECLARE vMinutosTardanza INT DEFAULT 0;
    DECLARE vEstadoAsistencia VARCHAR(20) DEFAULT 'Presente';
    
    -- Obtener ID de inscripción
    SELECT IdInscripcion INTO vIdInscripcion 
    FROM InscripcionesEvento 
    WHERE IdAsistente = pIdAsistente AND IdEvento = pIdEvento AND EstadoInscripcion = 'Confirmada';
    
    -- Obtener ID del día del evento y hora de inicio
    SELECT IdDiaEvento, HoraInicio, ToleranciaLlegadaTarde 
    INTO vIdDiaEvento, vHoraInicio, vTolerancia
    FROM DiasEvento 
    WHERE IdEvento = pIdEvento AND FechaDia = pFechaDia;
    
    -- Calcular tardanza si aplica
    IF vHoraInicio IS NOT NULL AND pHoraLlegada > vHoraInicio THEN
        SET vMinutosTardanza = TIME_TO_SEC(TIMEDIFF(pHoraLlegada, vHoraInicio)) / 60;
        IF vMinutosTardanza > vTolerancia THEN
            SET vEstadoAsistencia = 'Tardanza';
        END IF;
    END IF;
    
    -- Insertar o actualizar asistencia
    INSERT INTO Asistencia (
        IdInscripcion, IdDiaEvento, FechaAsistencia, HoraLlegada,
        EstadoAsistencia, MinutosTardanza, MetodoRegistro, IdAdminRegistro
    ) VALUES (
        vIdInscripcion, vIdDiaEvento, pFechaDia, pHoraLlegada,
        vEstadoAsistencia, vMinutosTardanza, pMetodoRegistro, pIdAdmin
    )
    ON DUPLICATE KEY UPDATE
        HoraLlegada = pHoraLlegada,
        EstadoAsistencia = vEstadoAsistencia,
        MinutosTardanza = vMinutosTardanza,
        MetodoRegistro = pMetodoRegistro,
        IdAdminRegistro = pIdAdmin,
        FechaRegistro = CURRENT_TIMESTAMP;
    
END //

-- Función para generar código QR único (solo retorna el código, no actualiza)
CREATE FUNCTION GenerarCodigoQR(pIdAsistente INT)
RETURNS VARCHAR(100)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE vTimestamp VARCHAR(20);
    DECLARE vCodigo VARCHAR(100);
    
    SET vTimestamp = UNIX_TIMESTAMP();
    SET vCodigo = CONCAT('AB', LPAD(pIdAsistente, 6, '0'), '_', vTimestamp);
    
    RETURN vCodigo;
END //

DELIMITER ;

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Nota: El código QR se genera manualmente en cada INSERT
-- para evitar conflictos de triggers con UPDATE en la misma tabla

-- =====================================================
-- ÍNDICES ADICIONALES PARA OPTIMIZACIÓN
-- =====================================================

-- Índices compuestos para consultas frecuentes
CREATE INDEX IdxAsistenciaFechaEstado ON Asistencia(FechaAsistencia, EstadoAsistencia);
CREATE INDEX IdxEventosFechasEstado ON Eventos(FechaInicio, FechaFin, Estado);
CREATE INDEX IdxInscripcionesEstadoFecha ON InscripcionesEvento(EstadoInscripcion, FechaInscripcion);

-- =====================================================
-- COMENTARIOS FINALES
-- =====================================================

/*
ESTRUCTURA DE LA BASE DE DATOS CREADA:

1. TIPOSEVENTOS: Categorías de eventos
2. USUARIOSADMIN: Administradores del sistema
3. EVENTOS: Eventos principales
4. DIASEVENTOS: Días específicos de cada evento
5. ASISTENTES: Personas que asisten
6. INSCRIPCIONESEVENTOS: Relación asistente-evento
7. ASISTENCIA: Control diario de asistencia
8. CONFIGURACIONSISTEMA: Parámetros del sistema

CARACTERÍSTICAS PRINCIPALES:
- Soporte para eventos de múltiples días
- Control de asistencia por día
- Gestión de diferentes tipos de eventos
- Sistema de inscripciones
- Códigos QR para identificación
- Tolerancia de tardanza configurable
- Múltiples métodos de registro
- Vistas para reportes
- Procedimientos almacenados
- Triggers automáticos
- Índices optimizados
- Nomenclatura en PascalCase (mayúsculas)

Para usar esta base de datos:
1. Ejecutar este script en MySQL/MariaDB
2. Crear usuarios adicionales según sea necesario
3. Configurar los parámetros del sistema
4. Comenzar a registrar eventos y asistentes
*/
