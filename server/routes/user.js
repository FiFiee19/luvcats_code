const express = require("express");
const userRouter = express.Router();
const auth = require("../middlewares/auth");

const {
  editPassword,
  editUser,
  userId,
  search
} = require('../controllers/user')


userRouter.put('/editP/:user_id',auth,editPassword);
userRouter.put('/editU/:user_id',auth,editUser);
userRouter.get('/profile/:id',auth,userId);
userRouter.get('/search/:username',auth,search);
module.exports = userRouter;

