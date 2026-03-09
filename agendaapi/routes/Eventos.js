var express = require("express");
var router = express.Router();
var EventosController = require("../src/controller/EventosController");

router.get("/",EventosController.listarEventos);

module.exports = router;
