"use strict";

const mysql = require("mysql");

const dbConn = mysql.createConnection({
    host: "localhost",
    user: "admin",
    password: "0110",
    database: "AsistenciaEventosBd"
});

dbConn.connect(function (err) {
    if (err) {
        throw (err);
        console.log("Base de datos no encontrada");
    }
    else {
        console.log("Conexion exitosa");
    }
});

module.exports = dbConn;
