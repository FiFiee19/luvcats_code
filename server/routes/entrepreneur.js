const express = require('express')
const entrepreneurRouter = express.Router()

const {
    create,
    list
} = require('../controllers/entrepreneur')

const auth = require('../middlewares/auth')

entrepreneurRouter.get('/getEntre',auth,list)
entrepreneurRouter.post('/signup_entre',create)

module.exports = entrepreneurRouter