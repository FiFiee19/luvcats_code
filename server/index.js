
const express = require("express");
const authRouter = require("./routes/auth");
const userRouter = require("./routes/user");
const straycatRouter = require("./routes/straycat");
const commuRouter = require("./routes/commu");
const entrepreneurRouter = require("./routes/entrepreneur");
const cathotelRouter = require("./routes/cathotel");
const reportRouter = require("./routes/report");
const reviewRouter = require("./routes/review");
const PORT = process.env.PORT || 5000;
const app = express();
const connectDB = require('./config/db');

//เรียกใช้
app.use(express.json());
app.use(authRouter);
app.use(userRouter);
app.use(straycatRouter);
app.use(commuRouter);
app.use(entrepreneurRouter);
app.use(cathotelRouter);
app.use(reportRouter);
app.use(reviewRouter);


//connect database
connectDB()

//runserver
app.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT}`);
});
