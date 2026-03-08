"use strict";
const dbConn =  require("../../config/dbConfig");

const Eventos = function (eventos){
    this.idTipo = eventos.idTipo;
    this.IdAdminResponsable= eventos.IdAdminResponsable;
    this.NombreEvento = eventos.NombreEvento;
    this.Descripcion = eventos.Descripcion;
    this.Lugar = eventos.Lugar;
    this.Direccion = eventos.Direccion;
    this.FechaInicio = eventos.FechaInicio;
    this.FechaFin = eventos.FechaFin;
    this.HoraInicio = eventos.HoraInicio;
    this.HoraFin = eventos.HoraFin;
    this.CapacidadMaxima = eventos.CapacidadMaxima;
    this.Costo = eventos.Costo;
    this.RequiereRegistro = eventos.RequiereRegistro;
    this.Estado = eventos.Estado;
    this.Notas = eventos.Notas;
    this.FechaCreacion = eventos.FechaCreacion;
    this.FechaModificacion = eventos.FechaModificacion;
}

Eventos.listarEventos =  function (result){
    dbConn.query("SELECT * FROM Eventos",function (err, res)
    {
        if (err){
            console.log("error al consultar", err);
        }else{
            console.log("Eventos obtenidos correctamente", res);
            result(null, res);
        }
    });
}

module.exports = Eventos;