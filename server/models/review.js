const mongoose = require("mongoose");

const reviewSchema = mongoose.Schema({
    user_id: {
        required: true,
        type: String,
          },
    store_id:{
        required: true,
        type: String, 
    },
    message:{
        required: false,
        type: String,
    },
    rating:{
        required: true,
        type: String,
    }
},
{ timestamps: true },  
)
const Review = mongoose.model("Review", reviewSchema)
module.exports = Review;