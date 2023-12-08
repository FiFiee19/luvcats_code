const Straycat = require("../models/poststraycat");

exports.create = async (req, res) => {
    try {
        const { breed, gender, province, description, images } = req.body;
        
        let straycat = new Straycat({
            user_id:req.user,
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
        // user_id: req.user
        const cats = await Straycat.find({})
        res.json(cats);
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }
    
}

exports.id = async (req, res) => {
    const straycatId = req.params.id;
    try {
        const straycat = await Straycat.findById(straycatId);
        const { __v, createdAt, ...straycatData } = straycat._doc;
        res.json(straycatData);
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }
    
}