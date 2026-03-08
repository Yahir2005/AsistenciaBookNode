var express = require("express");
var router = express.Router();
var AsistentesController = require("../src/controller/AsistentesController");

router.get("/", AsistentesController.listarAsistentes);
router.post("/",AsistentesController.RegistrarAsistente);

module.exports = router;