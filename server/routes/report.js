const express = require('express')
const auth = require('../middlewares/auth')
const reportRouter = express.Router()

const  {
    create, list, deleteReport
} = require('../controllers/report')


reportRouter.post('/postReport/:commuId',auth,create)//
// reportRouter.get('/getReport/:commuId',auth,list)//
reportRouter.get('/getReport',auth,list)//
reportRouter.delete('/getReport/delete/:reportId',auth,deleteReport)//

module.exports = reportRouter