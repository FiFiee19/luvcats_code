const mongoose = require("mongoose");

const reportSchema = mongoose.Schema({
    user:{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    user_id: {
        required: true,
        type: String,
    },
    commu_id:{
        required: true,
        type: String,
    },
    message:{
        required: true,
        type: String,
    },
    
},{ timestamps: true })

const Report = mongoose.model("Report",reportSchema);
module.exports = Report;