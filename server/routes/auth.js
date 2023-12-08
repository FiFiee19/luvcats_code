const express = require("express");
const authRouter = express.Router();
const auth = require("../middlewares/auth");

const {
  signup,
  signin,
  tokenIsValid,
  list
} = require('../controllers/auth')

// Sign Up
authRouter.post('/api/signup', signup);

// Sign In
authRouter.post("/api/signin", signin);

authRouter.post("/tokenIsValid", tokenIsValid);

// get user data
authRouter.get("/", auth, list);

module.exports = authRouter;


// authRouter.post("/register", cloudinary.configStorage("image"), async (req, res) => {
//   try {
//     const newUser = User(req.body);

//     const existingUser = await User.findOne({ email: newUser.email });
//     if (existingUser) {
//       return res
//         .status(400)
//         .json({ msg: "User with the same email already exists!" });
//     }

//     // อัปโหลดรูปภาพผ่าน Cloudinary
//     Upload.upload(
//       { filePath: req.file.path, folder: "ImageProfile/", name: newUser._id },
//       async function (err, result) {
//         if (err) {
//           console.error("Error uploading image:", err);
//           return res.json({
//             message: "Unable to upload image.",
//             isSuccess: false,
//           });
//         }
//         newUser.image = result.secure_url;
// 			newUser._id = result.public_id;
// 			newUser.save(function (err) {
// 				if (err) return res.json({ message: err.message, isSuccess: false });
// 				else
// 					authentication.encodeToken(newUser._id, function (token) {
// 						return res.json({ token: token, isSuccess: true });
// 					});
//         })

//         const hashedPassword = await bcrypt.hash(newUser.password, 8); // แก้ hashedPassword ให้ใช้ newUser.password

//         // ประกาศ newUser ที่ตรงนี้
//         let newUser = new User({ // ประกาศ newUser ที่ตรงนี้
//           username: newUser.username,
//           email: newUser.email,
//           password: hashedPassword,
//           image: {
//             public_id: result.public_id,
//             url: result.secure_url,
//           },
//         });
//         newUser = await newUser.save();

//         // เราสามารถส่ง token กลับไปให้ผู้ใช้หากต้องการ
//         // แต่ในตัวอย่างนี้เราไม่ได้นำมาใช้
//         res.json(newUser);
//       }
//     );
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });