const express = require('express')
const auth = require('../middlewares/auth')
const reportRouter = express.Router()

const  {
    create, list
} = require('../controllers/report')

reportRouter.post('/postReport/:commuId',auth,create)
reportRouter.get('/getReport/:commuId',auth,list)

module.exports = reportRouter