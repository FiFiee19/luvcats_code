const Cathotel = require("../models/cathotel");

exports.list = async (req, res) => {
    try {
        const cats = await Cathotel.find({}).populate('user')
        res.json(cats);
 
        
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }

}

exports.userId = async (req,res) => {
    try {
        const cathotel = await Cathotel.find({ user_id: req.params.user_id }).populate('user');
        if (!cathotel) {
            return res.status(404).send('Cathotel not found');
        }
        res.json(cathotel);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.cathotelId = async (req,res) => {
    try {
        const id = req.params.id;
        // Use findById to find a single document by its ID
        const cathotelId = await Cathotel.findById(id).populate('user');
        res.json(cathotelId);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}