const Eventos = require("../models/TiposEventos");
const RespuestaBasica = require("../models/Response");

exports.listarEventos =  function (req,res){
    Eventos.listarEventos (function (err,result){
        var respuestaRetorno = new RespuestaBasica();
        if(err){
            respuestaRetorno.status = false;
            respuestaRetorno.message = "error al consultar eventos";
        }else{
            respuestaRetorno.status = true;
            respuestaRetorno.code = 200;
            respuestaRetorno.message = "Datos obtenidos correctamente";
            respuestaRetorno.data = result;
            res.status(200);
            res.send(respuestaRetorno);
        }
    });
}
