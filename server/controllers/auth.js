const User = require('../models/user');
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

exports.signup = async (req, res) => {
  try {
    const { username, email, password, type, images } = req.body;

    // Check if user exists in UserSchema
    var user = await User.findOne({ email });
    if (user) {
      return res.send('User Already Exists!!!').status(400);
    }

    const salt = await bcrypt.genSalt(8);
    const hashedPassword = await bcrypt.hash(password, salt);
    

    const newUser = new User({
      username,
      email,
      password: hashedPassword,
      type,
      images
    });
    await newUser.save();
    
    res.send('Register Success!!');


  } catch (err) {
    console.log(err);
    res.status(500).send('Server Error');
  }
}


exports.signin = async (req, res) => {
  try {

    const { email, password } = req.body
    var user = await User.findOne({ email })
    console.log(user)

    if (user) {
      const isMatch = await bcrypt.compare(password, user.password)

      if (!isMatch) {
        return res.status(400).send('Password Invalid!!!')
      }
      // 3. Generate  { expiresIn: 2000 },
      jwt.sign({ user: { id: user._id } }, 'jwtsecret', (err, token) => {
        if (err) throw err;
        res.json({ token, user })

      })

    } else {
      return res.status(400).send('User not found!!!')
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

