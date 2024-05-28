const Cathotel = require('../models/cathotel')
const Entre = require('../models/entrepreneur')
const User = require('../models/user')
const bcrypt = require("bcrypt");
exports.create = async (req, res) => {
    try {
        const { username,
            email,
            password,
            imagesP,
            description,
            price,
            contact,
            province,
            images, } = req.body;


        let user_email = await User.findOne({ email });
        if (user_email) {
            return res.status(400).send('User Already Exists!!!');
        }

        const salt = await bcrypt.genSalt(10);
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
            user_id: newUser._id, 
            store_id: cathotel._id, 
            name: req.body.name,
            store_address: req.body.store_address,
            phone: req.body.phone
        });
        await newEntre.save();        
        res.send('ลงทะเบียนสำเร็จ!!');
    } catch (e) {        
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
        const { user_id } = req.params
        const entre = await Entre.find({ user_id }).populate('user');
        
        res.json(entre);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.editEntre = async (req, res) => {
    
    try {
        const { id } = req.params;
        const updatedEntre = await Entre.findByIdAndUpdate(
            id,
            req.body,
            { new: true } 
        );

        res.status(200).json({ data: updatedEntre, message: "Updated successfully" });
    } catch (e) {
        console.error(e);
        res.status(500).send('Server Error');
    }
}

