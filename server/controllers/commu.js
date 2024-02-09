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
         
        var getPost = await Commu.findById(post_id);
        if(!getPost) return res.status(404).json("Post not found !!")
        
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

exports.addComment = async (req, res) => {
    try {
        const{message} = req.body;
        const {post_id} = req.params;
        const user = await User.findById(req.user);
        const post = await Commu.findById(post_id);
        const newComment = new Comment({
            message,
            user_id: req.user,
            user: user,
            post: post
        })
        await newComment.save();
        var getPost = await Commu.findById(post_id);
        getPost = await Commu.findByIdAndUpdate(
            post_id,
            { $push: { comments: newComment } },
            { new: true }
        );
        
        return res.status(200).json(await getPost.populate('user_id'));

    }catch (e){
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.comment = async (req, res) => {
    try {
        
        const { post_id } = req.params;

        
        const post = await Commu.findById(post_id)
            .populate({
                path: 'comments',
                populate: { path: 'user' }
            });

        
        if (!post) {
            return res.status(404).json({ msg: 'Post not found' });
        }

        res.json(post.comments); // ส่งคอมเมนต์กลับไปยัง client
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }
};

exports.deletepost = async (req, res) => {
    
    try {
        const { post_id } = req.params;
        await Commu.findByIdAndDelete(post_id);
        return res.status(200).json({message:"Post Deleted successfully"})
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }

}

exports.editpost = async(req, res) => {
    try {
        // สมมติว่าคุณส่ง post_id ผ่าน req.params
        const { post_id } = req.params;

        // ดึงข้อมูลโพสต์ที่เฉพาะเจาะจงและคอมเมนต์ที่เกี่ยวข้อง
        const post = await Commu.findById(post_id)
        const newPost = await Commu.findOneAndUpdate(post , req.body , {new:true});

        return res.status(200).json({data:newPost , message:"updated successfully "});
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }
};



