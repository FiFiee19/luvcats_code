const mongoose = require("mongoose");

const expenseSchema = mongoose.Schema({
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    user_id: {
        required: true,
        type: String,
    },
    category: {
        type: String,
        required: true
    },

    description: {
        required: true,
        type: String,
    },
    amount: {
        required: true,
        type: Number,
    },

},
    { timestamps: true },);

const Expense = mongoose.model("Expense", expenseSchema);
module.exports = Expense;

