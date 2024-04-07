
const express = require("express");
const authRouter = require("./routes/auth");
const userRouter = require("./routes/user");
const straycatRouter = require("./routes/straycat");
const commuRouter = require("./routes/commu");
const entrepreneurRouter = require("./routes/entrepreneur");
const cathotelRouter = require("./routes/cathotel");
const reportRouter = require("./routes/report");
const reviewRouter = require("./routes/review");
const expenseRouter = require("./routes/expense");
const PORT = process.env.PORT || 5000;
const app = express();
const connectDB = require('./config/db');
const ngrok = require('ngrok');

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
app.use(expenseRouter);

//connect database
connectDB()

//runserver
app.listen(PORT, () => {
  console.log(`connected at port:  http://localhost:${PORT}`);

  ngrok.connect(PORT).then(url => {
    console.log(`Ngrok tunnel at: ${url}`);
  }).catch(error => {
    console.log(`${error}`);
  });
  
  })
