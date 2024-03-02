const Report = require('../models/report')
const User = require('../models/user')
const Commu = require('../models/postcommu')

exports.create = async (req,res) => {
    try {
        const{message} = req.body;
        const {commuId} = req.params;
        const user = await User.findById(req.user);
        const commu = await Commu.findById(commuId);
        const newReport = new Report({
            message,
            user_id: req.user,
            user: user,
            commu_id: commu
        })
        await newReport.save();
        var report = await Commu.findById(commuId);
        report = await Commu.findByIdAndUpdate(
            commuId,
            { $push: { reports: newReport } },
            { new: true }
        );
        
        return res.status(200).json(await report.populate('user_id'));

    }catch (e){
        console.log(e)
        res.status(500).send('Server Error')

    }
}
exports.list = async (req, res) => {
    try {
        
        const { commuId } = req.params;   
        const commu = await Commu.findById(commuId)
            .populate({
                path: 'reports',
                populate: { path: 'user' }
            });  
        if (!commu) {
            return res.status(404).json({ msg: 'Post not found' });
        }

        res.json(commu.reports); // ส่งคอมเมนต์กลับไปยัง client
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }
};


exports.listall = async (req, res) => {
    try {
        const report = await Report.find({}).populate('user').populate('commu_id');
        console.log(report); // Log the report data
        res.json(report);
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }
}

exports.deleteReport = async (req, res) => {
    
    try {
        const { reportId } = req.params;
        const commuId = req.params.commu_id;
        await Report.findByIdAndDelete(reportId);

        await Commu.findByIdAndUpdate(commuId, {
            $pull: { reports: reportId },
        });
        return res.status(200).json({message:"ลบสำเร็จ!"})
    } catch (e) {
        console.log(e)
        res.status(500).json({ error: 'Server Error' });

    }

}