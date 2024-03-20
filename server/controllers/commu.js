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
        let commu = new Commu({
            user: user,
            user_id: req.user,
            title,
            description,
            images

        })

        commu = await commu.save()
        res.json(commu)



        // res.send(straycat);
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');

    }
}

exports.likes = async (req, res) => {
    try {
        const { commuId } = req.params;
        const userId = req.user; // สมมติว่า req.user._id คือ ObjectId ของผู้ใช้งานที่ทำการ like

        let commuPost = await Commu.findById(commuId);
        if (!commuPost) return res.status(404).json("Post not found !!");

        const index = commuPost.likes.indexOf(userId);
        if (index > -1) {
            // User already liked the post, so remove their like
            await Commu.findByIdAndUpdate(commuId, { $pull: { likes: userId } }, { new: true });
        } else {
            // User has not liked the post yet, so add their like
            await Commu.findByIdAndUpdate(commuId, { $push: { likes: userId } }, { new: true });
        }

        commuPost = await Commu.findById(commuId).populate('user').populate('likes', 'username imagesP'); // หลังจากอัปเดต ทำการ populate เพื่อแสดงข้อมูล
        return res.status(200).json(commuPost);
    } catch (error) {
        return res.status(500).json({ message: error.message });
    }
};


exports.noti_likes = async (req, res) => {
    try {
        // สมมุติว่า `req.user` เป็น ID ของผู้ใช้ที่ทำการร้องขอ
        const commus = await Commu.find({ user_id: req.user })
            .populate('likes', 'username imagesP')
            .exec();

        if (!commus.length) {
            return res.status(404).send({ message: 'No Commu found for this user.' });
        }

        // ปรับปรุงการแสดงข้อมูล
        const allLikes = commus.map(commu => ({
            title: commu.title,
            likes: commu.likes.map(like => ({
                userId: like._id, // แสดง userId ของผู้ใช้ที่กดถูกใจ
                username: like.username, // ชื่อผู้ใช้
                imagesP: like.imagesP // ภาพโปรไฟล์ของผู้ใช้
            }))
        }));

        res.status(200).send(allLikes);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};





exports.userId = async (req, res) => {
    try {
        const findUserId = await Commu.find({ user_id: req.user }).populate('user')
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
        var addComment = await Commu.findById(commuId);
        addComment = await Commu.findByIdAndUpdate(
            commuId,
            { $push: { comments: newComment } },
            { new: true }
        );

        return res.status(200).json(await addComment.populate('user_id'));

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

        res.json(commentPost.comments); // ส่งคอมเมนต์กลับไปยัง client
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

        // Assuming you want to gather all comments from all posts by this user
        let allComments = [];
        commuPosts.forEach(post => {
            allComments = [...allComments, ...post.comments];
        });

        if (allComments.length === 0) {
            return res.status(404).json({ msg: 'Comments not found' });
        }

        // Transform comments to include user details
        const commentsWithUserDetails = allComments.map(comment => ({
            id: comment.id,
            commu_id: comment.commu_id,
            message: comment.message,
            user: comment.user,
            createdAt: comment.createdAt,
            // include any other fields you need
        }));
        console.log(commentsWithUserDetails.map(c => c.id));
        res.json(commentsWithUserDetails);
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }
};


exports.deletePost = async (req, res) => {
    try {
        const { commuId } = req.params;

        // ลบโพสต์จากคอลเลกชัน Commu
        const deletedPost = await Commu.findByIdAndDelete(commuId);
        if (!deletedPost) {
            return res.status(404).json({ message: "โพสต์ไม่พบ!" });
        }

        // ลบรายงานที่เกี่ยวข้องจากคอลเลกชัน Report
        await Report.deleteMany({ commu_id: commuId });
        await Comment.deleteMany({ commu_id: commuId });

        // ตอบกลับว่าลบสำเร็จ
        return res.status(200).json({ message: "ลบโพสต์และรายงานสำเร็จ!" });
    } catch (e) {
        console.log(e);
        res.status(500).json({ error: 'Server Error' });
    }
};




exports.editPost = async (req, res) => {
    try {
        const { commuId } = req.params;

        const commu = await Commu.findById(commuId)
        const newPost = await Commu.findOneAndUpdate(commu, req.body, { new: true });

        return res.status(200).json({ data: newPost, message: "แก้ไขสำเร็จ!" });
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }
};

exports.deleteComment = async (req, res) => {
    try {
        const { commentId, commuId } = req.params;

        // ลบคอมเมนต์จากคอลเลกชัน Comment
        const comment = await Comment.findById(commentId);
        if (!comment) {
            return res.status(404).json({ message: "Comment not found" });
        }

        await Comment.findByIdAndDelete(commentId);

        // ลบ ObjectId ของคอมเมนต์นั้นๆ ออกจากอาร์เรย์ comments ของ Commu
        const updatedCommu = await Commu.findByIdAndUpdate(
            comment.commu_id,
            { $pull: { comments: commentId } },
            { new: true }
        );

        if (!updatedCommu) {
            return res.status(404).json({ message: "Commu not found" });
        }

        // ตอบกลับว่าการลบสำเร็จ
        return res.status(200).json({ message: "Comment deleted successfully" });
    } catch (e) {
        console.log(e);
        res.status(500).json({ error: 'Server Error' });
    }
};




