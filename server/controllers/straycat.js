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

        await straycat.save();
        res.json(straycat);

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

// exports.userId = async (req,res) => {
//     try {
//         const findUserId = await Straycat.find({ user_id: req.user }).populate('user')
//         res.json(findUserId);

//     } catch (e) {
//         console.log(e)
//         res.status(500).send('Server Error')

//     }
// }

exports.user_Id = async (req,res) => {
    try {
        const { user_id } = req.params;
        const findUserId = await Straycat.find({ user_id}).populate('user')
        res.json(findUserId);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.straycatId = async (req,res) => {
    try {
        const { straycatId } = req.params;
        const findstraycatId = await Straycat.findById( straycatId ).populate('user')
        res.json(findstraycatId);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.deleteStraycat = async (req, res) => {
    
    try {
        const  straycatId  = req.params.id;
        await Straycat.findByIdAndDelete(straycatId);
        res.status(200).json({message:"Deleted successfully"})
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }

}

exports.editStraycats = async (req, res) => {
    
    try { 
        const straycatId = req.params.id;
        const newPost = await Straycat.findByIdAndUpdate(
            straycatId, 
            req.body, 
            { new: true } 
        );
        res.status(200).json({data:newPost , message:"Updated successfully "});
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
          res.status(404).send('Stray cat not found');
        }    
        res.status(200).json(straycat);
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }

}
