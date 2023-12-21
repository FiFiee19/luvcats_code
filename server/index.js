//import
const express = require("express");
const authRouter = require("./routes/auth");
const straycatRouter = require("./routes/straycat");
const commuRouter = require("./routes/commu");
const entrepreneurRouter = require("./routes/entrepreneur");
const PORT = process.env.PORT || 5000;
const app = express();
const connectDB = require('./config/db')

//เรียกใช้
app.use(express.json());
app.use(authRouter);
app.use(straycatRouter);
app.use(commuRouter);
app.use(entrepreneurRouter);
//connect database
connectDB()

  //runserver
app.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT}`);
});
