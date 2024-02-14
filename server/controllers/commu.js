const Commu = require('../models/postcommu')
const User = require('../models/user');
const Comment = require('../models/comment');
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
        const commu = new Commu({
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
        const {commuId} = req.params;
         
        var likesPost = await Commu.findById(commuId);
        if(!likesPost) return res.status(404).json("Post not found !!")
        
        if(likesPost.likes.includes(req.user)){
            likesPost = await Commu.findByIdAndUpdate(commuId , {$pull:{likes:req.user}} , {new:true}) 
        }else{
            likesPost = await Commu.findByIdAndUpdate(commuId , {$push:{likes:req.user}} , {new:true}) 
        }
        
        return res.status(200).json(await likesPost.populate('user_id'));
    } catch (error) {
        return res.status(500).json(error.message);
    }
}

exports.userId = async (req,res) => {
    try {
        const findUserId = await Commu.find({ user_id: req.user }).populate('user')
        res.json(findUserId);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.commuId = async (req,res) => {
    try {
        const { commuId } = req.params;
        const findCommuId = await Commu.findById( commuId ).populate('user')
        res.json(findCommuId);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}



exports.addComment = async (req, res) => {
    try {
        const{message} = req.body;
        const {commuId} = req.params;
        const user = await User.findById(req.user);
        const commu = await Commu.findById(commuId);
        const newComment = new Comment({
            message,
            user_id: req.user,
            user: user,
            post: commu
        })
        await newComment.save();
        var addComment = await Commu.findById(commuId);
        addComment = await Commu.findByIdAndUpdate(
            commuId,
            { $push: { comments: newComment } },
            { new: true }
        );
        
        return res.status(200).json(await addComment.populate('user_id'));

    }catch (e){
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.comment = async (req, res) => {
    try {
        
        const { commuId } = req.params;   
        const commentPost = await Commu.findById(commuId)
            .populate({
                path: 'comments',
                populate: { path: 'user' }
            });  
        if (!commentPost) {
            return res.status(404).json({ msg: 'Post not found' });
        }

        res.json(commentPost.comments); // ส่งคอมเมนต์กลับไปยัง client
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }
};

exports.deletePost = async (req, res) => {
    
    try {
        const { commuId } = req.params;
        await Commu.findByIdAndDelete(commuId);
        return res.status(200).json({message:"Post Deleted successfully"})
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }

}

exports.editPost = async(req, res) => {
    try {
        const { commuId } = req.params;

        const commu = await Commu.findById(commuId)
        const newPost = await Commu.findOneAndUpdate(commu , req.body , {new:true});

        return res.status(200).json({data:newPost , message:"updated successfully "});
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }
};



