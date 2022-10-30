 const express = require('express');
 const Document = require('../models//document_model');
 const documentRouter = express.Router();
 const auth = require('../middlewares/auth');
const e = require('express');


 documentRouter.post('/doc/create', auth, async(req, res) => {
     try {
         // Because when the file is created, it comes from the user's locale time zone,
         // This timezone might be different from that on the server.
         // So in other not to have time variations, let's use the 
         // time from the user, i.e req.body.
         const { createdAt } = req.body;
         let document = new Document({
             uid: req.id,
            title: "Untitled Document",
            createdAt,
            
        });
        
        document = await document.save();

        res.json(document);
    } catch (error) {
        res.status(500).json({error: error.message});
    }
});

documentRouter.get('/docs/me', auth, async(req, res) => {
    try {
        let documents = await Document.find({uid: req.id});
        console.log("George these are your docs:: "+documents);
        res.json(documents);
    } catch (error) {
        res.status(500).json({error: error.message});
    }
 });

 module.exports = documentRouter;