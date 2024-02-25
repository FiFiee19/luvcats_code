const mongoose = require("mongoose");

const reviewSchema = mongoose.Schema({
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    user_id: {
        required: true,
        type: String,
    },
    cathotelId: {
        required: true,
        type: String,
    },
    message: {
        required: false,
        type: String,
    },
    rating: {
        required: true,
        type: Number,
    }
},
    { timestamps: true },
)
const Review = mongoose.model("Review", reviewSchema)
module.exports = Review;