const TiposEventos = require("../models/TiposEventos");
const RespuestaBasica = require("../models/Response");

exports.listarTiposEventos = function (req,res){
    TiposEventos.listarTiposEventos(function (err, result){
        var respuestaRetorno = new RespuestaBasica();
        if (err) {
            respuestaRetorno.status = false;
            respuestaRetorno.message = "Error al consultar los Tipos Eventos";
        } else {
            respuestaRetorno.status = true;
            respuestaRetorno.code = 200;
            respuestaRetorno.message = "Datos obtenidos Tipos Eventos";
            respuestaRetorno.data = result;
            res.status(200);
            res.send(respuestaRetorno);
        }
    });
};