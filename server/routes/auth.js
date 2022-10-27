const e = require('express');
const express = require('express');
const User = require('../models/users');

const authRouter = express.Router();


authRouter.post('/api/signup', async(req, res) => {
    console.log(req.body)
    try {
        const {name, email, profilePic} = req.body;

        // If email exists, don't store the data
        let user = await User.findOne({email: email});

        if(!user) {
            user = new User({
                email: email,
                profilePic: profilePic,
                name: name,
            });
            user = await user.save();
        }
        // else, store the data

        res.json({user});
    } catch (error) {
        res.status(500).json({error: e.message})
    }
}); 

module.exports = authRouter;