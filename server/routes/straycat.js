const express = require("express");
const straycatRouter = express.Router();
const auth = require("../middlewares/auth");


const {
    create,
    list,
    id
} = require('../controllers/straycat');

straycatRouter.post("/postStrayCat", auth, create);

straycatRouter.get("/getStrayCat", auth, list);

straycatRouter.post("/getStrayCat/:id", auth, id);


module.exports = straycatRouter;