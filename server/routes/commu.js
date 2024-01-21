const express = require('express')
const commuRouter = express.Router()

const {
    create,
    list,
    likes,
    id,
    addComment,
    comment
} = require('../controllers/commu')

const auth = require('../middlewares/auth')

commuRouter.get('/getCommu',auth,list)
commuRouter.post('/postCommu',auth,create)
commuRouter.put('/likesCommu/:post_id',auth,likes)
commuRouter.get('/getCommu/:user_id',auth,id)
commuRouter.post('/addComment/:post_id',auth,addComment)
commuRouter.get('/getComment/:post_id',auth,comment)

module.exports = commuRouter