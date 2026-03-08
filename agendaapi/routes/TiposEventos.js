var express = require("express");
var router = express.Router();
var TiposEventosController = require("../src/controller/TiposEventosController");

router.get("/",TiposEventosController.listarTiposEventos);

module.exports = router;