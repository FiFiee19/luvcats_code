const { decode } = require("jsonwebtoken");
const Straycat = require("../models/poststraycat");
const User = require("../models/user");
exports.create = async (req, res) => {
    try {
        const { breed, gender, province, description, images } = req.body;
        const user = await User.findById(req.user);       
        if (!user) {
            return res.status(404).json({ msg: 'User not found' });
        }
        let straycat = new Straycat({  
            user: user,
            user_id: req.user,
            description,
            breed,
            gender,
            province,
            images
        });

        straycat = await straycat.save();
        res.json(straycat);

        // res.send(straycat);
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
        //check error
    }
}

exports.list = async (req, res) => {
    try {
        const cats = await Straycat.find({}).populate('user')
        res.json(cats);
 
        // res.json(users);
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }

}

exports.id = async (req, res) => {
    const straycatId = req.params.id;
    try {
        const straycat = await Straycat.findById(straycatId).populate('user');
        const { __v, createdAt, ...straycatData } = straycat._doc;
        res.json(straycatData);
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }

}