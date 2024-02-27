const Cathotel = require("../models/cathotel");

exports.list = async (req, res) => {
    try {
        const cats = await Cathotel.find({}).populate('user')
        res.json(cats);
 
        
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }

}

exports.userId = async (req,res) => {
    try {
        const cathotel = await Cathotel.find({ user_id: req.params.user_id }).populate('user');
        if (!cathotel) {
            return res.status(404).send('Cathotel not found');
        }
        res.json(cathotel);

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.cathotelId = async (req, res) => {
    const cathotelId = req.params.id;
    try {
        const catHotel = await Cathotel.find( cathotelId ).populate('user');
        
        // ถ้าไม่พบ catHotel, ส่งคืน response ว่าง
        if (!catHotel) {
            return res.status(404).json({ msg: 'Cat hotel not found' });
        }

        res.json(catHotel);
    } catch (e) {
        console.error(e);
        res.status(500).send('Server Error');
    }
}


exports.editCathotl = async (req, res) => {
    const id = req.params.id;
    try { 
        const newCathotel = await Cathotel.findByIdAndUpdate(
            id, 
            req.body, 
            { new: true } // ตัวเลือกนี้จะทำให้ method คืนค่าเอกสารหลังจากอัปเดต
        );
        return res.status(200).json({data:newCathotel , message:"Updated successfully "});
    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')
    }

}