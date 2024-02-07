const express = require("express");
const cathotelRouter = express.Router();
const auth = require("../middlewares/auth");


const {
    list,
} = require('../controllers/cathotel');

cathotelRouter.get("/getCathotel", auth, list);
module.exports = cathotelRouter;