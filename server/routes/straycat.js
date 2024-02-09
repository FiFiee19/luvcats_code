const express = require("express");
const straycatRouter = express.Router();
const auth = require("../middlewares/auth");


const {
    create,
    list,
    id,
    deletepost,
    editpost,
    updateStatus
} = require('../controllers/straycat');

straycatRouter.post("/postStrayCat", auth, create);
straycatRouter.get("/getStrayCat", auth, list);
straycatRouter.get("/getStrayCat/:user_id", auth, id);
straycatRouter.delete("/getStrayCat/delete/:id", auth, deletepost);
straycatRouter.put("/getStrayCat/edit/:id", auth, editpost);
straycatRouter.post("/updateStatus/:id", auth, updateStatus);
module.exports = straycatRouter;