const Straycat = require("../models/poststraycat");
const User = require("../models/user");
exports.create = async (req, res) => {
    try {
        const { breed, gender, province, description, images } = req.body;
        const user = await User.findById(req.user);       
        if (!user) {
            return res.status(404).json({ msg: 'User not found' });
        }
        const straycat = new Straycat({  
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
        
    }
}

exports.list = async (req, res) => {
    try {
        const straycatlist = await Straycat.find({}).populate('user')
        res.json(straycatlist);
 
        
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }

}

exports.userId = async (req, res) => {
    try {
        const straycatId = await Straycat.find( {user_id: req.user} ).populate('user')
        res.json(straycatId);
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }
}

exports.deletepost = async (req, res) => {
    const straycatId = req.params.id;
    try {
        await Straycat.findByIdAndDelete(straycatId);
        return res.status(200).json({message:"Deleted successfully"})
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }

}

exports.editpost = async (req, res) => {
    const straycatId = req.params.id;
    try { 
        const newPost = await Straycat.findByIdAndUpdate(
            straycatId, 
            req.body, 
            { new: true } // ตัวเลือกนี้จะทำให้ method คืนค่าเอกสารหลังจากอัปเดต
        );
        return res.status(200).json({data:newPost , message:"Updated successfully "});
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }

}

exports.updateStatus = async (req, res) => {
    try {
        const straycatId = req.params.id;
        const status = req.body.status; // สถานะที่จะอัปเดต ('yes' หรือ 'no')
    
        const straycat = await Straycat.findByIdAndUpdate(straycatId, { status: status }, { new: true });
        
        if (!straycat) {
          return res.status(404).send('Stray cat not found');
        }
    
        res.status(200).json(straycat);
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }

}