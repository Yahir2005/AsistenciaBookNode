const DiasEvento = require("../models/DiasEvento");
const RespuestaBasica = require("../models/Response");

exports.listarDiasEvento = function (req, res) {
    DiasEvento.listarDiasEvento(function (err, result) {
        var respuestaRetorno = new RespuestaBasica();
        if (err) {
            respuestaRetorno.status = false;
            respuestaRetorno.message = "error al consultar dias evento";
        } else {
            respuestaRetorno.status = true;
            respuestaRetorno.code = 200;
            respuestaRetorno.message = "Datos obtenidos correctamente";
            respuestaRetorno.data = result;
            res.status(200);
            res.send(respuestaRetorno);
        }
    });
}