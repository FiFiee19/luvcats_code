const express = require("express");
const userRouter = express.Router();
const auth = require("../middlewares/auth");

const {
  editPassword,
  editUser
} = require('../controllers/user')


userRouter.put('/editP/:user_id',auth,editPassword);
userRouter.put('/editU/:user_id',auth,editUser);

module.exports = userRouter;

