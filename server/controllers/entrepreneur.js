const Cathotel = require('../models/cathotel')
const Entre = require('../models/entrepreneur')
const User = require('../models/user')
const jwt = require("jsonwebtoken");
exports.create = async (req, res) => {
    try {
        const { description,
            price,
            contact,
            province,
            review_id,
            rating,
            images } = req.body

        cathotel = new Cathotel({
            user_id: User.id,
            description,
            price,
            contact,
            province,
            review_id,
            rating,
            images
        });
        await cathotel.save();

        let newEntre = new Entre({
            user_id: User.id,
            store_id: cathotel.id,
            name: req.body.name,
            user_address: req.body.user_address,
            store_address: req.body.store_address,
            phone: req.body.phone

        });

        await newEntre.save();
        console.log(req.body)
        res.send('Register Success!!');

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.list = async (req, res) => {
    try {
        const entre = await Entre.find({})
        res.json(entre)

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}