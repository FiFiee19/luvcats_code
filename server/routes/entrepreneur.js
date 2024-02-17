const express = require('express')
const entrepreneurRouter = express.Router()

const {
    create,
    list,
    userId,
    editEntre,
    entreId
} = require('../controllers/entrepreneur')

const auth = require('../middlewares/auth')

entrepreneurRouter.get('/getEntre',auth,list)
entrepreneurRouter.get('/getEntre/:user_id',auth,userId)
entrepreneurRouter.get('/getEntre/:id',auth,entreId)
entrepreneurRouter.put("/getEntre/edit/:id", auth, editEntre)
entrepreneurRouter.post('/signup_entre',create)

module.exports = entrepreneurRouter