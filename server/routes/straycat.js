const express = require("express");
const straycatRouter = express.Router();
const auth = require("../middlewares/auth");


const {
    create,
    list,
    userId,
    user_Id,
    deleteStraycats,
    editStraycats,
    updateStatus,
    straycatsId,
    searchName
} = require('../controllers/straycat');

straycatRouter.post("/postStrayCat", auth, create);
straycatRouter.get("/getStrayCat", auth, list);
straycatRouter.get("/getStrayCat/:user_id", auth, userId);
straycatRouter.get("/getStrayCat/id/:user_id", auth, user_Id);
straycatRouter.get("/getStrayCat/stray/:straycatsId", auth, straycatsId);
straycatRouter.delete("/getStrayCat/delete/:id", auth, deleteStraycats);
straycatRouter.put("/getStrayCat/edit/:id", auth, editStraycats);
straycatRouter.post("/updateStatus/:id", auth, updateStatus);
straycatRouter.get("/getStrayCat/search/:username", auth, searchName);
module.exports = straycatRouter;