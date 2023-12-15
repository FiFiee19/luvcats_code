// const jwt = require("jsonwebtoken");
// const User = require("../models/user");

// const admin = async (req, res, next) => {
//   try {
//     const token = req.headers["authtoken"]
//       if (!token) {
//           return res.status(401).send('No token')
//       }
//     const decoded = jwt.verify(token, 'jwtsecret')
//     const user = await User.findById(decoded.id);
//     if (user.type == "user" || user.type == "admin") {
//       return res.status(401).json({ msg: "You are not an admin!" });
//     }
//     req.user = decoded.user.id;
//     req.token = token;
//     console.log(req.user)
//     next();
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// };

// module.exports = admin;