const Asistentes = require("../models/Asistentes");
const RespuestaBasica = require("../models/Response");

exports.listarAsistentes = function (req, res) {
    Asistentes.listarAsistentes(function (err, result) {
        var respuestaRetorno = new RespuestaBasica();
        if (err) {
            respuestaRetorno.status = false;
            respuestaRetorno.message = "Error al consultar los asistentes";
        } else {
            respuestaRetorno.status = true;
            respuestaRetorno.code = 200;
            respuestaRetorno.message = "Asistentes obtenidos correctamente";
            respuestaRetorno.data = result;
            res.status(200);
            res.send(respuestaRetorno);
        }
    });
};
