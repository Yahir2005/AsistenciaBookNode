var express = require("express");
var router = express.Router();
var DiasEventoController = require("../src/controller/DiasEventoController");

router.get("/", DiasEventoController.listarDiasEvento);

module.exports = router;