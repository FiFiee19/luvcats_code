const express = require('express')
const expenseRouter = express.Router()

const {
    create,
    list,
    user_Id,
    deleteExpense,
    

} = require('../controllers/expense')

const auth = require('../middlewares/auth')

expenseRouter.get('/getExpense',auth,list)
expenseRouter.post('/postExpense',auth,create)//
expenseRouter.get('/getExpense/id/:user_id',auth,user_Id)//
expenseRouter.delete("/getExpense/delete/:id", auth, deleteExpense)//

module.exports = expenseRouter