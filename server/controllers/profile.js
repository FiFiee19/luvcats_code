const Profile = require('../models/profile')

exports.list = async (req,res) => {
    try {
        
        const profile = await Profile.find({})
        res.json(profile)

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.userId = async (req,res) => {
    try {
        const userId = req.user;
        const profile = await Profile.find({user_id: userId})
        res.json(profile)

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.id = async (req,res) => {
    try {
        const ProfileId = req.params.id;
        const profile = await Profile.findById(ProfileId)
        const { __v, createdAt, ...profileData } = profile._doc;
        res.json(profileData)

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}