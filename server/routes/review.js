const express = require('express')
const reviewRouter = express.Router()



const auth = require('../middlewares/auth')
const { addReview, review } = require('../controllers/review')


reviewRouter.post('/addReview/:cathotelId',auth,addReview)
reviewRouter.get('/getReview/:cathotelId',auth,review)
module.exports = reviewRouter