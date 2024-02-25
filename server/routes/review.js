const express = require('express')
const reviewRouter = express.Router()



const auth = require('../middlewares/auth')
const { addReview, review, userId } = require('../controllers/review')


reviewRouter.post('/addReview/:cathotelId',auth,addReview)
reviewRouter.get('/getReview/:cathotelId',auth,review)
reviewRouter.get('/getReviewU/:user_id',auth,userId)
module.exports = reviewRouter