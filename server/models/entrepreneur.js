const mongoose = require("mongoose");

const entrepreneurSchema = mongoose.Schema({
    user_id: {
        required: true,
        type: String,
    },
    store_id: {
        required: true,
        type: String,
    },
    name: {
        required: true,
        type: String,
    },
    
    user_address: {
        required: true,
        type: String,
    },
    store_address: {
        required: true,
        type: String,
    },
    phone: {
        required: true,
        type: String,
    },

});

const Entrepreneur = mongoose.model("Entrepreneur", entrepreneurSchema);
module.exports = Entrepreneur;

