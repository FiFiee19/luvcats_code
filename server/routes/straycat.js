const express = require("express");
const straycatRouter = express.Router();
const auth = require("../middlewares/auth");


const {
    create,
    list,
    userId,
    deleteStraycats,
    editStraycats,
    updateStatus,
    straycatsId
} = require('../controllers/straycat');

straycatRouter.post("/postStrayCat", auth, create);
straycatRouter.get("/getStrayCat", auth, list);
straycatRouter.get("/getStrayCat/:user_id", auth, userId);
straycatRouter.get("/getStrayCat/:straycatsId", auth, straycatsId);
straycatRouter.delete("/getStrayCat/delete/:id", auth, deleteStraycats);
straycatRouter.put("/getStrayCat/edit/:id", auth, editStraycats);
straycatRouter.post("/updateStatus/:id", auth, updateStatus);
module.exports = straycatRouter;