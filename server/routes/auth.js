const express = require("express");
const authRouter = express.Router();
const auth = require("../middlewares/auth");

const {
  signup,
  signin,
  list,

} = require('../controllers/auth')

authRouter.post('/api/signup', signup);

authRouter.post("/api/signin", signin);

authRouter.get("/", auth,list);



module.exports = authRouter;

