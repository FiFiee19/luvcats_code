const express = require("express");
const cathotelRouter = express.Router();
const auth = require("../middlewares/auth");


const {
    list,
    userId,
    cathotelId
} = require('../controllers/cathotel');

cathotelRouter.get("/getCathotel", auth, list)
cathotelRouter.get("/getCathotel/:user_id", auth, userId)
cathotelRouter.get("/getCathotel/:id", auth, cathotelId)

module.exports = cathotelRouter;