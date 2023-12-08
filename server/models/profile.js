const mongoose = require("mongoose");

const profileSchema = mongoose.Schema({
    user_id: {
        required: true,
        type: String,
    },
    description: {
        required: false,
        type: String,
    },

    images: {
        required: false,
        type: String,
    },
});

const Profile = mongoose.model("Profile", profileSchema);
module.exports = Profile;

