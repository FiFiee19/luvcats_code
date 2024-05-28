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
        const {user_id} = req.params;
        const cathotel = await Cathotel.find({ user_id }).populate('user');
        res.json(cathotel);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }
}


exports.editCathotel = async (req, res) => {
    
    try { 
        const {id} = req.params;
        const newCathotel = await Cathotel.findByIdAndUpdate(
            id, 
            req.body, 
            { new: true } 
        );
        res.status(200).json({data:newCathotel , message:"Updated successfully "});
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }
}