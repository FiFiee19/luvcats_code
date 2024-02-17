const mongoose = require("mongoose");

const commuSchema = mongoose.Schema({
    user_id: {
        required: true,
        type: String,
          },
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
      },
    title: {
        required: true,
        type: String,
    }, 
    description: {
        required: true,
        type: String,
    }, 
    images: [
        {
          type: String,
          required: false,
        },
      ],
      comments:[{
        type:mongoose.Schema.Types.ObjectId,
        ref:"Comment"
    }], 
    likes:[
        {
            type:mongoose.Schema.Types.ObjectId,
            ref:"User",
        }
    ],
    reports:[
      {
          type:mongoose.Schema.Types.ObjectId,
          ref:"Report",
      }
  ],
},
{ timestamps: true },    
)
const Commu = mongoose.model("Commu", commuSchema)
module.exports = Commu;