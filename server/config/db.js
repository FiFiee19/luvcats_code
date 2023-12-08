const mongoose = require('mongoose')

const connectDB = async () => {
    try {
        await mongoose.connect('mongodb+srv://Mycat:p%40ssword@cluster0.wurdujv.mongodb.net/mycat')
        console.log('DB Connected')
    } catch (e) {
        console.log(e)
    }
}

module.exports = connectDB