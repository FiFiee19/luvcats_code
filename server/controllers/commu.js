const Commu = require('../models/postcommu')
const User = require('../models/user');
const Comment = require('../models/comment');
const Report = require('../models/report');

exports.list = async (req, res) => {
    try {
        const commu = await Commu.find({}).populate('user')
        res.json(commu)
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }
}

exports.create = async (req, res) => {
    try {
        const { title, description, images } = req.body
        const user = await User.findById(req.user);

        if (!user) {
            return res.status(404).json({ msg: 'User not found' });
        }
        const commu = new Commu({
            user: user,
            user_id: req.user,
            title,
            description,
            images
        })

        await commu.save()
        res.json(commu)

    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');

    }
}

exports.likes = async (req, res) => {
    try {
        const { commuId } = req.params;
        const userId = req.user;
        let commuPost = await Commu.findById(commuId);
        if (!commuPost) return res.status(404).json("Post not found !!");
        const index = commuPost.likes.indexOf(userId);
        if (index > -1) {
            await Commu.findByIdAndUpdate(commuId, { $pull: { likes: userId } }, { new: true });
        } else {
            await Commu.findByIdAndUpdate(commuId, { $push: { likes: userId } }, { new: true });
        }
        commuPost = await Commu.findById(commuId).populate('user')
            .populate('likes');
        res.json(commuPost);
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }
};



exports.userId = async (req, res) => {
    try {
        const user_id = req.user;
        const findUserId = await Commu.find({ user_id }).populate('user')
        res.json(findUserId);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.user_Id = async (req, res) => {
    try {
        const { user_id } = req.params;
        const findUserId = await Commu.find({ user_id }).populate('user')
        res.json(findUserId);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}


exports.commuId = async (req, res) => {
    try {
        const { commuId } = req.params;
        const findCommuId = await Commu.findById(commuId).populate('user')
        res.json(findCommuId);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}


exports.addComment = async (req, res) => {
    try {
        const { message } = req.body;
        const { commuId } = req.params;
        const user = await User.findById(req.user);
        const commu = await Commu.findById(commuId);
        const newComment = new Comment({
            message,
            user_id: req.user,
            user: user,
            commu_id: commu._id
        })
        await newComment.save();
        let addComment = await Commu.findById(commuId);
        addComment = await Commu.findByIdAndUpdate(
            commuId,
            { $push: { comments: newComment } },
            { new: true }
        );
        res.json(addComment)

    } catch (e) {
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

        res.json(commentPost.comments); 
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }
};

exports.commentUser = async (req, res) => {
    try {
        const { user_id } = req.params;
        const commuPosts = await Commu.find({ user_id }).populate({
            path: 'comments',
            populate: { path: 'user' }
        });

        let allComments = [];
        commuPosts.forEach(post => {
            allComments = [...allComments, ...post.comments];
        });

        if (allComments.length === 0) {
            return res.status(404).json({ msg: 'Comments not found' });
        }

        const comments = allComments.map(comment => ({
            id: comment.id,
            commu_id: comment.commu_id,
            message: comment.message,
            user: comment.user,
            createdAt: comment.createdAt,
        }));
        res.json(comments);
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }
};


exports.deletePost = async (req, res) => {
    try {
        const { commuId } = req.params;

        const deletedPost = await Commu.findByIdAndDelete(commuId);
        if (!deletedPost) {
            return res.status(404).json({ message: "ไม่พบโพสต์!" });
        }

        await Report.deleteMany({ commu_id: commuId });
        await Comment.deleteMany({ commu_id: commuId });

        
        res.status(200).json({ message: "ลบโพสต์สำเร็จ!" });
    } catch (e) {
        console.log(e);
        res.status(500).json({ error: 'Server Error' });
    }
};




exports.editPost = async (req, res) => {
    try {
        const { commuId } = req.params;

        const commu = await Commu.findById(commuId)
        const newPost = await Commu.findByIdAndUpdate(commu, req.body, { new: true });

        res.status(200).json({ data: newPost, message: "แก้ไขสำเร็จ!" });
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }
};

exports.deleteComment = async (req, res) => {
    try {
        const { commentId } = req.params;

        const comment = await Comment.findById(commentId);
        await Comment.findByIdAndDelete(commentId);

        const updatedCommu = await Commu.findByIdAndUpdate(
            comment.commu_id,
            { $pull: { comments: commentId } },
            { new: true }
        );

        if (!updatedCommu) {
            return res.status(404).json({ message: "Commu not found" });
        }

        res.status(200).json({ message: "Comment deleted successfully" });
    } catch (e) {
        console.log(e);
        res.status(500).json({ error: 'Server Error' });
    }
};