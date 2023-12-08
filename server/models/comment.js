const mongoose = require("mongoose");

const commentSchema = mongoose.Schema({
    post_id: {
        type: Schema.Types.ObjectId,
        ref: 'Commu',
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