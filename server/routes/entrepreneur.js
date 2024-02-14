const express = require('express')
const entrepreneurRouter = express.Router()

const {
    create,
    list,
    userId
} = require('../controllers/entrepreneur')

const auth = require('../middlewares/auth')

entrepreneurRouter.get('/getEntre',auth,list)
entrepreneurRouter.get('/getEntre/:user_id',auth,userId)
entrepreneurRouter.post('/signup_entre',create)

module.exports = entrepreneurRouter