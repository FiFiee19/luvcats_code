const Commu = require('../models/postcommu')

exports.list = async (req,res) => {
    try {
        const commu = await Commu.find({})
        res.json(commu)

    } catch (e) {
        console.log(e)
        res.status(500).send('Server Error')

    }
}

exports.create = async (req,res) => {
    try {
        const {title,description,images} = req.body

        let commu = new Commu({
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

