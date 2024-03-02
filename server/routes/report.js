const express = require('express')
const auth = require('../middlewares/auth')
const reportRouter = express.Router()

const  {
    create, list, listall
} = require('../controllers/report')

reportRouter.post('/postReport/:commuId',auth,create)
reportRouter.get('/getReport/:commuId',auth,list)
reportRouter.get('/getReport',auth,listall)

module.exports = reportRouter