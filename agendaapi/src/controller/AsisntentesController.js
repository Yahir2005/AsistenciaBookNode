const Asistentes = require("../models/Asistentes");
const RespuestaBasica = require("../models/Response");

exports.listarAsistentes = function (req, res) {
    Asistentes.listarAsistentes(function (err, res) {
        var respuestaRetorno = new RespuestaBasica();
        if (err) {
            console.log("error al consultar", res);
            respuestaRetorno.status = false;
            respuestaRetorno.code = 200;
            respuestaRetorno.message = "Error al consultar los asistentes";
        } else {
            console.log("Asistentes obtenidos", res);
            respuestaRetorno.status = true;
            respuestaRetorno.code = 200;
            respuestaRetorno.message = "Asistentes obtenidos correctamente";
            res.status(200);
            res.send(respuestaRetorno);
        }
    })
}