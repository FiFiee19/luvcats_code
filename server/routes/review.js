const express = require('express')
const reviewRouter = express.Router()



const auth = require('../middlewares/auth')
const { addReview, review, userId,replyToReview } = require('../controllers/review')


reviewRouter.post('/addReview/:cathotelId',auth,addReview)
reviewRouter.get('/getReview/:cathotelId',auth,review)
reviewRouter.get('/getReviewU/:user_id',auth,userId)
reviewRouter.post('/getReview/:reviewId/reply', replyToReview);
module.exports = reviewRouter