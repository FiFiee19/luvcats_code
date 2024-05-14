const User = require('../models/user');
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

exports.signup = async (req, res) => {
  try {
    const { username, email, password, type, imagesP } = req.body;
    const findUser = await User.findOne({ username });
    if (findUser) {
      return res.status(400).send('ชื่อนี้มีผู้ใช้แล้ว');
    }
    const findEmail = await User.findOne({ email });
    if (findEmail) {
      return res.status(400).send('อีเมลนี้เคยลงทะเบียนแล้ว');
    }
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);
    const newUser = new User({
      username,
      email,
      password: hashedPassword,
      type,
      imagesP
    });
    await newUser.save();
    res.json(newUser);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server Error');
  }
};




exports.signin = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .send("ไม่พบผู้ใช้");
    }
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).send('รหัสผ่านผิด');
    }
    const token = jwt.sign({ user: { id: user._id } }, 'jwtsecret');
    res.json({ token, user })
  } catch (err) {
    console.error(err);
    res.status(500).send('Server Error');
  }
};


exports.list = async (req, res) => {
  const user = await User.findById(req.user);
  res.json({ ...user._doc, token: req.token });
}



