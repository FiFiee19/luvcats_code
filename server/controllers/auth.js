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
    const { email, password } = req.body;
    var user = await User.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .json({ msg: "ไม่พบผู้ใช้" });
    }
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(400).send('รหัสผ่านผิด');
    }
    const token = jwt.sign({ user: { id: user._id } }, 'jwtsecret');
    // jwt.sign({ user: { id: user._id } }, 'jwtsecret', { expiresIn: '15m' }, (err, token) => {
    //   if (err) throw err;

    //   // สมมติว่า 'refresh_jwt_secret' เป็น secret key อื่นสำหรับ refresh token
    //   // const refreshToken = jwt.sign({ id: user._id }, 'refresh_jwt_secret', { expiresIn: '7d' });

    res.json({ token, user })




    // const token = jwt.sign(payload, "jwtsecret", { expiresIn: '1h' });
    // res.json({ token, user });

  } catch (err) {
    console.error(err);
    res.status(500).send('Server Error');
  }
};



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
  res.json({ user, token: req.token });
}



