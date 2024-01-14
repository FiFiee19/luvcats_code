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
    // date: {
    //     required: false,
    //     type: String,
    // }, 
    likes:[
        {
            type:mongoose.Schema.Types.ObjectId,
            ref:"User",
        }
    ],
},
{ timestamps: true },    
)
const Commu = mongoose.model("Commu", commuSchema)
module.exports = Commu;