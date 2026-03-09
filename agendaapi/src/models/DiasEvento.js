"use strict";
const dbConn = require("../../config/dbConfig");

const DiasEvento = function (diasEvento) {
    this.IdDiaEvento = diasEvento.IdDiaEvento;
    this.IdEvento = diasEvento.IdEvento;
    this.FechaDia = diasEvento.FechaDia;
    this.HoraInicio = diasEvento.HoraInicio;
    this.HoraFin = diasEvento.HoraFin;
    this.DescripcionDia = diasEvento.DescripcionDia;
    this.TemaPrincipal = diasEvento.TemaPrincipal;
    this.UbicacionEspecifica = diasEvento.UbicacionEspecifica;
    this.RequiereAsistencia = diasEvento.RequiereAsistencia;
    this.ToleranciaLlegadaTarde = diasEvento.ToleranciaLlegadaTarde;
    this.Activo = diasEvento.Activo;
}

DiasEvento.listarDiasEvento = function (result) {
    dbConn.query("SELECT * FROM DiasEvento", function (err, res) {
        if (err) {
            console.log("error al consultar", err);
        } else {
            console.log("DiasEvento obtenidos correctamente", res);
            result(null, res);
        }
    });
}

module.exports = DiasEvento;