const mongoose = require("mongoose");

const cathotelSchema = mongoose.Schema({
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
      },
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
        type: String,
    },
    contact: {
        required: true,
        type: String,
    },

    province: {
        required: true,
        type: String,
    },

    // rating: {
    //     required: false,
    //     type: String,
    //     default:null
    // },

    // review: [
    //     {
    //     type: mongoose.Schema.Types.ObjectId,
    //     ref: 'Review',
    //     },
    // ],

    images: [
        {
            type: String,
            required: false,
        },
    ],

});

const Cathotel = mongoose.model("Cathotel", cathotelSchema);
module.exports = Cathotel;

