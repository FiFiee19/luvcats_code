const User = require('../models/user');
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

exports.signup = async (req, res) => {
  try {
    const { username, email, password, type, imagesP } = req.body;

    // Check if username exists
    const existingUserByUsername = await User.findOne({ username });
    if (existingUserByUsername) {
      return res.status(400).send('ชื่อนี้มีผู้ใช้แล้ว');
    }

    // Check if email exists
    const existingUserByEmail = await User.findOne({ email });
    if (existingUserByEmail) {
      return res.status(400).send('อีเมลนี้เคยลงทะเบียนแล้ว');
    }

    // Hash the password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create a new user object
    const newUser = new User({
      username,
      email,
      password: hashedPassword,
      type,
      imagesP
    });

    // Save the new user
    await newUser.save();

    // Send success message
    res.status(201).send('ลงทะเบียนสำเร็จ');
  } catch (err) {
    console.error(err);
    res.status(500).send('Server Error');
  }
};



exports.signin = async (req, res) => {
  try {

    const { email, password } = req.body
    var user = await User.findOne({ email })
    console.log(user)

    if (user) {
      const isMatch = await bcrypt.compare(password, user.password)

      if (!isMatch) {
        return res.status(400).send('รหัสผ่านผิด')
      }
      // 3. Generate  { expiresIn: 2000 },
      jwt.sign({ user: { id: user._id } }, 'jwtsecret', (err, token) => {
        if (err) throw err;
        res.json({ token, user })

      })

    } else {
      return res.status(400).send('ไม่พบผู้ใช้')
    }

  } catch (err) {
    //code
    console.log(err)
    res.status(500).send('Server Error')
  }
}

exports.tokenIsValid = async (req, res) => {
  try {
    const token = req.header("authtoken");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "jwtsecret");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}

exports.list = async (req, res) => {
  const user = await User.find({})
  res.json({ ...user._doc, token: req.token });
}
// exports.editPassword = async (req, res) => {

//   try {
//       const { password } = req.body; // รับค่ารหัสผ่านใหม่จาก body ของ request
//       const user_id = req.user; // สมมติว่า req.user เก็บค่า ID ของผู้ใช้ที่ต้องการแก้ไข

//       if (!password) {
//           return res.status(400).send('Password is required');
//       }

//       // ค้นหาผู้ใช้จากฐานข้อมูลด้วย ID
//       const user = await User.findById(user_id);
//       if (!user) {
//           return res.status(404).send('User not found');
//       }

//       // สร้างรหัสผ่านที่ถูกเข้ารหัส
//       const salt = await bcrypt.genSalt(8);
//       const hashedPassword = await bcrypt.hash(password, salt);

//       // อัปเดตรหัสผ่านของผู้ใช้
//       user.password = hashedPassword;
//       await user.save();

//       res.send('Password updated successfully');
//       console.log(user)
//   } catch (e) {
//       console.log(e);
//       res.status(500).send('Server Error');
//   }

// };

// exports.editUsername = async (req, res) => {
//   try {
//       const { username, imagesP } = req.body;
//       const user_id = req.user; // สมมติว่า req.user เก็บค่า ID ของผู้ใช้ที่ต้องการแก้ไข

//       // ค้นหาและอัปเดตผู้ใช้
//       const updatedUser = await User.findByIdAndUpdate(user_id, {
//           $set: {
//               username: username,
//               imagesP: imagesP
//           }
//       }, { new: true }).select('-password'); // ไม่คืนค่ารหัสผ่าน

//       if (!updatedUser) {
//           return res.status(404).send('User not found');
//       }

//       res.json({ user: updatedUser, message: "User updated successfully" });

//   } catch (e) {
//       console.log(e);
//       res.status(500).send('Server Error');
//   }
// };



