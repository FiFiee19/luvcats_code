const Expense = require("../models/expense")
const User = require("../models/user")

exports.list = async (req,res) => {
    try {
        const expense = await Expense.find({}).populate('user')
        res.json(expense)

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.create = async (req,res) => {
    try {
        const {category,description,amount} = req.body
        const user = await User.findById(req.user);
        if (!user) {
            return res.status(404).json({ msg: 'User not found' });
        }
        let expense = new Expense({
            user: user,
            user_id:req.user,
            category,
            description,
            amount
            
        })

        expense = await expense.save()
        res.json(expense)

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.user_Id = async (req,res) => {
    try {
        const { user_id } = req.params;
        const findUserId = await Expense.find({ user_id }).populate('user')
        res.json(findUserId);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}
