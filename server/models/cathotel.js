const mongoose = require("mongoose");

const cathotelSchema = mongoose.Schema({
    user_id: {
        required: true,
        type: String,
    },

    description: {
        required: true,
        type: String,
    },
    price: {
        required: true,
        type: Number,
    },
    contact: {
        required: true,
        type: String,
    },

    province: {
        required: true,
        type: String,
    },

    rating: {
        required: false,
        type: String,
        default:null
    },

    review_id: [
        {
            type: String,
            required: false,
            default:null
        },
    ],

    images: [
        {
            type: String,
            required: false,
        },
    ],

});

const Cathotel = mongoose.model("Cathotel", cathotelSchema);
module.exports = Cathotel;

