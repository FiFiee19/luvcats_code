const express = require("express");
const authRouter = express.Router();
const auth = require("../middlewares/auth");

const {
  signup,
  signin,
  tokenIsValid,
  list,
} = require('../controllers/auth')

// Sign Up
authRouter.post('/api/signup', signup);

// Sign In
authRouter.post("/api/signin", signin);

authRouter.post("/tokenIsValid", tokenIsValid);

// get user data
authRouter.get("/", auth, list);


module.exports = authRouter;

