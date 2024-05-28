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
        let report = await Commu.findById(commuId);
        report = await Commu.findByIdAndUpdate(
            commuId,
            { $push: { reports: newReport } },
            { new: true }
        );
        
        res.json(report);

    }catch (e){
        console.log(e)
        res.status(500).send('Server Error')

    }
}


exports.list = async (req, res) => {
    try {
        const report = await Report.find({}).populate('user').populate('commu_id');
        console.log(report); 
        res.json(report);
    } catch (e) {
        console.log(e);
        res.status(500).send('Server Error');
    }
}

exports.deleteReport = async (req, res) => {
    try {
        const { reportId } = req.params;
        const report = await Report.findById(reportId);
        if (!report) {
            return res.status(404).json({ message: "Report not found" });
        }
        const commuId = report.commu_id; 

        await Report.findByIdAndDelete(reportId);
        
        await Commu.findByIdAndUpdate(
            commuId,
            { $pull: { reports: reportId } },
            { new: true }
        );

        return res.status(200).json({ message: "Report deleted successfully" });
    } catch (e) {
        console.log(e);
        res.status(500).json({ error: 'Server Error' });
    }
};
