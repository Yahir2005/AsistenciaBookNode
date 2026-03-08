var express = require("express");
var EventosController = require("../src/controller/EventosController");

router.get("/",EventosController.listarEventos);
module.exports = router;