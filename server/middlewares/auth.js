const e = require('express');
const jwt = require('jsonwebtoken');
const auth = async(req, res, next) => {
    try {
        // Getting the token from the request header
        const token = req.header('x-auth-token');
        if(!token) {
            return res.status(401).json({msg: "Not Authorized."});
        }
        const verified = jwt.verify(token, 'passwordKey');
        
        if(!verified) {
            return res.status(401).json("Authorization Denied!");
        }

        // What the below code means is that:
        // the 'user' key, is added to the request object, 
        // then assigned a value (i.e id) returned from the verified object
        // as it was the 'id' that was used to sign it initially.
        req.id = verified.id;

        req.token = token;
        next(); 
    } catch (error) {
        res.status(500).json({error: e.message});
    }
}

module.exports = auth;