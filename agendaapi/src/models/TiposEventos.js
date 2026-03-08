"use strict";

const dbConn = require("../../config/dbConfig");

const TiposEventos = function (tiposEventos){
    this.IdTipo = tiposEventos.IdTipo;
    this.NombreTipo = tiposEventos.NombreTipo;
    this.Descripcion = tiposEventos.Descripcion;
    this.Activo = tiposEventos.Activo;
    this.FechaCreacion = tiposEventos.FechaCreacion;
}

TiposEventos.listarTiposEventos = function (result){
    dbConn.query("SELECT * FROM TiposEvento",function(err, res){
        if (err) {
            console.log("error al consultar", err);
        } else {
            console.log("Tipos eventos obtenidos", res);
            result(null, res);
        }
    });
}