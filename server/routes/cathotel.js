const express = require("express");
const cathotelRouter = express.Router();
const auth = require("../middlewares/auth");


const {
    list,
    id
} = require('../controllers/cathotel');

cathotelRouter.get("/getCathotel", auth, list);
cathotelRouter.get("/getCathotel/:id", auth, id);
module.exports = cathotelRouter;