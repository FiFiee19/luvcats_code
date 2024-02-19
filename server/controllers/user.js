const User = require('../models/user');
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

exports.editPassword = async (req, res) => {

    try {
        const { password } = req.body; // รับค่ารหัสผ่านใหม่จาก body ของ request
        const user_id = req.user; // สมมติว่า req.user เก็บค่า ID ของผู้ใช้ที่ต้องการแก้ไข

        if (!password) {
            return res.status(400).send('Password is required');
        }

        // ค้นหาผู้ใช้จากฐานข้อมูลด้วย ID
        const user = await User.findById(user_id);
        if (!user) {
            return res.status(404).send('User not found');
        }

        // สร้างรหัสผ่านที่ถูกเข้ารหัส
        const salt = await bcrypt.genSalt(8);
        const hashedPassword = await bcrypt.hash(password, salt);

        // อัปเดตรหัสผ่านของผู้ใช้
        user.password = hashedPassword;
        await user.save();

        res.send('Password updated successfully');
        console.log(user)
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }

};

exports.editUser = async (req, res) => {
    try {
        const { username, imagesP } = req.body;
        const user_id = req.user; // สมมติว่า req.user เก็บค่า ID ของผู้ใช้ที่ต้องการแก้ไข

        // ค้นหาและอัปเดตผู้ใช้
        const updatedUser = await User.findByIdAndUpdate(user_id, {
            $set: {
                username: username,
                imagesP: imagesP
            }
        }, { new: true }).select('-password'); // ไม่คืนค่ารหัสผ่าน

        if (!updatedUser) {
            return res.status(404).send('User not found');
        }

        res.json({ user: updatedUser, message: "User updated successfully" });

    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }
};

exports.userId = async (req,res) => {
    try {
        const user_id  = req.params.id;
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

exports.search =  async (req,res) => {
    try {
        const user = await User.find(
            {
                $and: [
                    { username: { $regex: req.params.username, $options: 'i' } }, // ใช้ $options: 'i' เพื่อค้นหาแบบ case-insensitive
                    { type: 'user' } // เพิ่มเงื่อนไขนี้เพื่อจำกัดเฉพาะ user
                ]
            }
        )
        res.json(user);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}