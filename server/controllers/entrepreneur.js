const Cathotel = require('../models/cathotel')
const Entre = require('../models/entrepreneur')
const User = require('../models/user')
const bcrypt = require("bcrypt");
exports.create = async (req, res) => {
    try {
        const { username, email, password, imagesP,description,
            price,
            contact,
            province,
            images, } = req.body;

    
    var user_email = await User.findOne({ email });
    if (user_email) {
      return res.send('User Already Exists!!!').status(400);
    }

    const salt = await bcrypt.genSalt(8);
    const hashedPassword = await bcrypt.hash(password, salt);

    const newUser = new User({
        username,
        email,
        password: hashedPassword,
        type: 'entrepreneur',
        imagesP
    });
    await newUser.save();
    
    const cathotel = new Cathotel({
        user: newUser._id,
        user_id: newUser._id,
        description,
        price,
        contact,
        province,
        images
    });
    await cathotel.save();

    const newEntre = new Entre({
        user: newUser._id,
        user_id: newUser._id, // ใช้ newUser._id แทน newUser และ user_id
        store_id: cathotel._id, // ใช้ _id ที่ถูกต้องจาก Mongoose
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
        const entre = await Entre.find({}).populate('user')
        res.json(entre)

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.userId = async (req, res) => {
    try {
        const entreId = await Entre.find( {user_id: req.user} ).populate('user')
        res.json(entreId);
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }
}