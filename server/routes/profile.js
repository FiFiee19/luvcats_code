const express = require('express')
const profileRouter = express.Router()

const {
    id,
    userId,
    list
} = require('../controllers/profile')

const auth = require('../middlewares/auth')

profileRouter.get('/profile',auth,list)
profileRouter.post('/profile/userId',auth,userId)
profileRouter.post('/profile/:id',auth,id)

module.exports = profileRouter