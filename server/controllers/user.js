const User = require('../models/user');
const bcrypt = require("bcrypt");

exports.editPassword = async (req, res) => {

    try {
        const { password } = req.body; 
        const user_id = req.user; 

        if (!password) {
            return res.status(400).send('Password is required');
        }

        const user = await User.findById(user_id);
        if (!user) {
            return res.status(404).send('User not found');
        }

        const salt = await bcrypt.genSalt(8);
        const hashedPassword = await bcrypt.hash(password, salt);

        user.password = hashedPassword;
        await user.save();

        res.status(200).json({ message: "แก้ไขสำเร็จ!" });
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }

};

exports.editUser = async (req, res) => {
    try {
        const { username, imagesP } = req.body;
        const user_id = req.user; 
        
        const updatedUser = await User.findByIdAndUpdate(user_id, {
            $set: {
                username: username,
                imagesP: imagesP
            }
        }, { new: true }).select('-password'); 
        if (!updatedUser) {
            return res.status(404).send('User not found');
        }

        res.json({ user: updatedUser, message: "แก้ไขสำเร็จ!" });

    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }
};

exports.userId = async (req, res) => {
    try {
        const user_id = req.params.id;
        const user = await User.findById(user_id)
        if (!user) {
            return res.status(404).send('user not found');
        }
        res.json(user);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.searchUser = async (req, res) => {
    try {
        const user = await User.find(
            {
                $and: [
                    { username: { $regex: req.params.username, $options: 'i' } }, 
                    { type: 'user' } 
                ]
            }
        )
        res.json(user);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}



