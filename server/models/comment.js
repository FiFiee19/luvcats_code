const mongoose = require("mongoose");

const commentSchema = mongoose.Schema({
    commu_id: {
      required: true,
      type: String,
      },
      user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
      },
    user_id:{
        required: true,
        type: String, 
    },
    message:{
        required: true,
        type: String,
    }
    
},
{ timestamps: true },  
)
const Comment = mongoose.model("Comment", commentSchema)
module.exports = Comment;