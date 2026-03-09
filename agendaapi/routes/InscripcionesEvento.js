var express = require("express");
var router = express.Router();
var InscripcionesEventoController = require("../src/controller/InscripcionesEventoController");

router.get("/", InscripcionesEventoController.listarInscripcionesEvento);

module.exports = router;