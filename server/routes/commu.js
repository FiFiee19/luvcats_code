const express = require('express')
const commuRouter = express.Router()

const {
    create,
    list
} = require('../controllers/commu')

const auth = require('../middlewares/auth')

commuRouter.get('/getCommu',auth,list)
commuRouter.post('/postCommu',auth,create)

module.exports = commuRouter