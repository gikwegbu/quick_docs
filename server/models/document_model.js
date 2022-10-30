const mongoose = require('mongoose');


const documentSchema = mongoose.Schema({
    uid: {
        required: true,
        type: String,
    },
    createdAt: {
        // Since we working with flutter, and it uses DateTime,
        // To be on a safe side, we'd be using numbers here.
        // It'll be milliseconds since epoch
        required: true,
        type: Number,
    },
    title: {
        required: true,
        type: String,
        trim: true,
    },
    content: {
        // Content is not required, as user creates and empty file with no content.
        type: Array,
        default: [],
    }
});

const Document = mongoose.model("Document", documentSchema);

module.exports = Document;