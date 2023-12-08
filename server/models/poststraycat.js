const mongoose = require("mongoose");

const straycatSchema = mongoose.Schema({

  user_id: {
    required: true,
    type: String,
      },
  breed: {
    required: true,
    type: String,
      },
  gender: {
    required: true,
    type: String,
  },
  
  province: {
    required: true,
    type: String,
  },
  description: {
    required: true,
    type: String,
  },
  images: [
    {
      type: String,
      required: false,
    },
  ],
});

const Straycat = mongoose.model("Straycat", straycatSchema);
module.exports = Straycat;

// module.exports = mongoose.model('Straycat', straycatSchema);
