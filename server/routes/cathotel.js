const express = require("express");
const cathotelRouter = express.Router();
const auth = require("../middlewares/auth");


const {
    list,
    userId,
    cathotelId,
    editCathotel
} = require('../controllers/cathotel');

cathotelRouter.get("/getCathotel", auth, list)//
cathotelRouter.get("/getCathotel/:user_id", auth, userId)//
// cathotelRouter.get("/getCathotel/:cathotelId", auth, cathotelId)
cathotelRouter.put("/getCathotel/edit/:id", auth, editCathotel)//
module.exports = cathotelRouter; 