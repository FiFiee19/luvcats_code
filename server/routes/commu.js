const express = require('express')
const commuRouter = express.Router()

const {
    create,
    list,
    likes,
    addComment,
    comment,
    deletePost,
    editPost,
    userId,
    commuId,
    deleteComment,
    user_Id,
    noti_likes,
    commentUser

} = require('../controllers/commu')

const auth = require('../middlewares/auth')

commuRouter.get('/getCommu',auth,list)//
commuRouter.post('/postCommu',auth,create)//
commuRouter.put('/likesCommu/:commuId',auth,likes)//
// commuRouter.get('/getCommu/:user_id/likes',auth,noti_likes)//
commuRouter.get('/getCommu/:user_id',auth,userId)//
commuRouter.get('/getCommu/id/:user_id',auth,user_Id)//
commuRouter.get('/getCommu/commu/:commuId',auth,commuId)//
commuRouter.post('/addComment/:commuId',auth,addComment)//
commuRouter.get('/getComment/:commuId',auth,comment)//
commuRouter.get('/getComment/id/:user_id',auth,commentUser)//
commuRouter.delete('/getCommu/delete/:commuId',auth,deletePost)//
commuRouter.put('/getCommu/edit/:commuId',auth,editPost)//
commuRouter.delete('/getComment/delete/:commentId',auth,deleteComment)//
module.exports = commuRouter
