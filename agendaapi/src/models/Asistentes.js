"use strict";

const dbConn = require("../../config/dbConfig");

const Asistentes = function (asistente) {
    this.id_asistente = asistente.id_asistente;
    this.Nombre = asistente.Nombre;
    this.Apellido = asistente.Apellido;
    this.Email = asistente.Email;
    this.Telefono = asistente.Telefono;
    this.DocumentoIdentidad = asistente.DocumentoIdentidad;
    this.TipoDocumento = asistente.TipoDocumento;
    this.FechaNacimiento = asistente.FechaNacimiento;
    this.Genero = asistente.Genero;
    this.Profesion = asistente.Profesion;
    this.Institucion = asistente.Institucion;
    this.Ciudad = asistente.Ciudad;
    this.Pais = asistente.Pais;
    this.CodigoQR = asistente.CodigoQR;
    this.Activo = asistente.Activo;
    this.FechaRegistro = asistente.FechaRegistro;
    this.Notas = asistente.Notas;
}
Asistentes.listarAsistentes = function (result) {
    dbConn.query("SELECT * FROM Asistentes", function (err, res) {
        if (err) {
            console.log("error al consultar", err);
        } else {
            console.log("Asistentes obtenidos", res);
            result(null, res);
        }
    })
}

Asistentes.Registrar = function (visitanteNew,Result){
    dbConn.query("INSERT INTO Asistentes SET?",visitanteNew,function(err,res){
        if(err){
            console.log("error Asistente: ",err);
            result(err,null);
        }else{
            console.log(res,insertId);
            result(null,res.insertId);
        }
    });
}

module.exports = Asistentes;
