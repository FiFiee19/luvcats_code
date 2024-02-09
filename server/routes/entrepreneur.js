const express = require('express')
const entrepreneurRouter = express.Router()

const {
    create,
    list,
    id
} = require('../controllers/entrepreneur')

const auth = require('../middlewares/auth')

entrepreneurRouter.get('/getEntre',auth,list)
entrepreneurRouter.get('/getEntre/:id',auth,id)
entrepreneurRouter.post('/signup_entre',create)

module.exports = entrepreneurRouter