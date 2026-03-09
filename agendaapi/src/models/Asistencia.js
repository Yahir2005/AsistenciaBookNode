"use strict"
const dbConn = require("../../config/dbConfig");

const Asistencia = function (asistencia) {
    this.IdAsistencia = asistencia.IdAsistencia;
    this.IdInscripcion = asistencia.IdInscripcion;
    this.IdDiaEvento = asistencia.IdDiaEvento;
    this.FechaAsistencia = asistencia.FechaAsistencia;
    this.HoraLlegada = asistencia.HoraLlegada;
    this.HoraSalida = asistencia.HoraSalida;
    this.EstadoAsistencia = asistencia.EstadoAsistencia;
    this.MinutosTardanza = asistencia.MinutosTardanza;
    this.Observaciones = asistencia.Observaciones;
    this.MetodoRegistro = asistencia.MetodoRegistro;
    this.IdAdminRegistro = asistencia.IdAdminRegistro;
    this.IpRegistro = asistencia.IpRegistro;
    this.FechaRegistro = asistencia.FechaRegistro;
}

Asistencia.listarAsistencia = function (result) {
    dbConn.query("SELECT * FROM Asistencia", function (err, res) {
        if (err) {
            console.log("error al consultar", err);
        } else {
            console.log("Asistencia obtenidos correctamente", res);
            result(null, res);
        }
    });
}

module.exports = Asistencia;
