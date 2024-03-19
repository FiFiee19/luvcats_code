const mongoose = require("mongoose");

const reviewSchema = mongoose.Schema({
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    user_id: {
        required: true,
        type: String,
    },
    cathotelId: {
        required: true,
        type: String,
    },
    message: {
        required: false,
        type: String,
    },
    rating: {
        required: true,
        type: Number,
    },
    reply: { // เพิ่ม field นี้เพื่อเก็บการตอบกลับ
        type: {
            message: { type: String, required: true },
            repliedAt: { type: Date, default: Date.now }, // บันทึกเวลาการตอบกลับ
            // เพิ่มเติมข้อมูลอื่นๆ ถ้าจำเป็น
        },
        required: false, // ไม่จำเป็นต้องมีการตอบกลับในทุกๆ รีวิว
    },
    
},
    { timestamps: true },
)
const Review = mongoose.model("Review", reviewSchema)
module.exports = Review;