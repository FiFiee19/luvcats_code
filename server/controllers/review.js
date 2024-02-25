const User = require('../models/user');
const Cathotel = require('../models/cathotel');
const Review = require('../models/review');

exports.addReview = async (req, res) => {
    try {
        const { message, rating } = req.body;
        const { cathotelId } = req.params;
        const user = await User.findById(req.user);
        const cathotel = await Cathotel.findById(cathotelId);
        const newReview = new Review({
            message,
            rating,
            user_id: req.user,
            user: user,
            cathotelId: cathotel
        })
        await newReview.save();
        var addReview = await Cathotel.findById(cathotelId);
        addReview = await Cathotel.findByIdAndUpdate(
            cathotelId,
            { $push: { reviews: newReview } },
            { new: true }
        );

        return res.status(200).json(await addReview.populate('user_id'));

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.review = async (req, res) => {
    try {

        const { cathotelId } = req.params;
        const review = await Cathotel.findById(cathotelId)
            .populate({
                path: 'reviews',
                populate: { path: 'user' }
            });
        if (!review) {
            return res.status(404).json({ msg: 'Review not found' });
        }

        res.json(review.reviews); // ส่งคอมเมนต์กลับไปยัง client
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }
};

exports.userId = async (req,res) => {
    try {
        const cathotel = await Cathotel.find({ user_id: req.params.user_id }).populate({
            path: 'reviews',
            populate: { path: 'user' }
        });
        if (!cathotel) {
            return res.status(404).send('Cathotel not found');
        }
        res.json(cathotel);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}



