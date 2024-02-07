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