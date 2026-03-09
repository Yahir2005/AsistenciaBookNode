"use strict";
const dbConn = require("../../config/dbConfig");

const InscripcionesEvento = function (inscripcionesEvento) {
    this.IdInscripcion = inscripcionesEvento.IdInscripcion;
    this.IdAsistente = inscripcionesEvento.IdAsistente;
    this.IdEvento = inscripcionesEvento.IdEvento;
    this.FechaInscripcion = inscripcionesEvento.FechaInscripcion;
    this.EstadoInscripcion = inscripcionesEvento.EstadoInscripcion;
    this.FormaPago = inscripcionesEvento.FormaPago;
    this.MontoPagado = inscripcionesEvento.MontoPagado;
    this.ComprobantePago = inscripcionesEvento.ComprobantePago;
    this.NotasInscripcion = inscripcionesEvento.NotasInscripcion;
    this.IdAdminRegistro = inscripcionesEvento.IdAdminRegistro;
}

InscripcionesEvento.listarInscripcionesEvento = function (result) {
    dbConn.query("SELECT * FROM InscripcionesEvento", function (err, res) {
        if (err) {
            console.log("error al consultar", err);
        } else {
            console.log("InscripcionesEvento obtenidos correctamente", res);
            result(null, res);
        }
    });
}

module.exports = InscripcionesEvento;
