const Commu = require('../models/postcommu')
const User = require('../models/user');
exports.list = async (req,res) => {
    try {
        const commu = await Commu.find({}).populate('user')
        res.json(commu)

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.create = async (req,res) => {
    try {
        const {title,description,images} = req.body
        const user = await User.findById(req.user);
        if (!user) {
            return res.status(404).json({ msg: 'User not found' });
        }
        let commu = new Commu({
            user: user,
            user_id:req.user,
            title,
            description,
            images
            
        })

        commu = await commu.save()
        res.json(commu)

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.likes = async (req , res ) => {
    try {
        const {post_id} = req.params;
        // get post 
        var getPost = await Commu.findById(post_id);
        if(!getPost) return res.status(404).json("Post not found !!")
        // check if user liked on this post before or not
        if(getPost.likes.includes(req.user)){
            getPost = await Commu.findByIdAndUpdate(post_id , {$pull:{likes:req.user}} , {new:true}) 
        }else{
            getPost = await Commu.findByIdAndUpdate(post_id , {$push:{likes:req.user}} , {new:true}) 
        }
        
        return res.status(200).json(await getPost.populate('user_id'));
    } catch (error) {
        return res.status(500).json(error.message);
    }
}

exports.id = async (req,res) => {
    try {
        const userCommu = await Commu.find({ user_id: req.user }).populate('user')
        res.json(userCommu);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

