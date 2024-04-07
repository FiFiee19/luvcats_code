const express = require("express");
const authRouter = express.Router();
const auth = require("../middlewares/auth");

const {
  signup,
  signin,
  tokenIsValid,
  list,
  home
} = require('../controllers/auth')

// Sign Up
authRouter.post('/api/signup', signup);

// Sign In
authRouter.post("/api/signin", signin);

authRouter.post("/tokenIsValid", tokenIsValid);

// get user data
authRouter.get("/",  list);

authRouter.get("/home",home);


module.exports = authRouter;

