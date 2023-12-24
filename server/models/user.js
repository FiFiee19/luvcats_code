const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
  username: {
    required: true,
    type: String,
    trim: true,
  },
  email: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a valid email address",
    },
  },
  password: {
    required: true,
    type: String,
    trim: true,
    // validate: (value) => {
    //   const pw =
    //     /^(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$/;
    //   return value.match(pw);
    // },
    // message: "Password must be at least 8 characters long and include a number."
  },


  type: {
  required: true,
  type: String,
  enum: ['user', 'entrepreneur', 'admin'],
  default: "user"
},
  
});

const User = mongoose.model("User", userSchema);
module.exports = User;

