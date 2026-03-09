const InscripcionesEvento = require("../models/InscripcionesEvento");
const RespuestaBasica = require("../models/Response");

exports.listarInscripcionesEvento = function (req, res) {
    InscripcionesEvento.listarInscripcionesEvento(function (err, result) {
        var respuestaRetorno = new RespuestaBasica();
        if (err) {
            respuestaRetorno.status = false;
            respuestaRetorno.message = "Error al consultar las Inscripciones Eventos";
        } else {
            respuestaRetorno.status = true;
            respuestaRetorno.code = 200;
            respuestaRetorno.message = "Datos obtenidos Inscripciones Eventos";
            respuestaRetorno.data = result;
            res.status(200);
            res.send(respuestaRetorno);
        }
    });
};

