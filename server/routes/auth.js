const express = require("express");
const authRouter = express.Router();
const auth = require("../middlewares/auth");

const {
  signup,
  signin,
  tokenIsValid,
  list,
  editUser
} = require('../controllers/auth')

// Sign Up
authRouter.post('/api/signup', signup);

// Sign In
authRouter.post("/api/signin", signin);

authRouter.post("/tokenIsValid", tokenIsValid);

// get user data
authRouter.get("/", auth, list);
authRouter.put('/edit/:user_id',auth,editUser)

module.exports = authRouter;

