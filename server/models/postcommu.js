const mongoose = require("mongoose");

const commuSchema = mongoose.Schema({
    user_id: {
        required: true,
        type: String,
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
    // like: {
    //     required: true,
    //     type: String,
    // },
},
{ timestamps: true },    
)
const Commu = mongoose.model("Commu", commuSchema)
module.exports = Commu;