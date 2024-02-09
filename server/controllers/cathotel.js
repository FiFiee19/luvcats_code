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

exports.id = async (req, res) => {
    try {
        const catId = await Cathotel.find( {user_id: req.user} ).populate('user')
        res.json(catId);
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }
}