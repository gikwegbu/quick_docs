const express = require('express');
const mongoose = require('mongoose');
const dotenv = require("dotenv");
const authRouter = require('./routes/auth');
const cors = require('cors');
const documentRouter = require('./routes/document');
const http = require('http');

dotenv.config();

const PORT = process.env.PORT | 3001;

const app = express();
var server = http.createServer(app);

// Patter 1: Of Init-ing the io
// var socket = require('socket.io');
// var io = socket(server);

// Patter 2: Of Init-ing the io
var io = require('socket.io')(server);

app.use(cors());
// This helps with transmitting data to and from db
app.use(express.json());

app.use(authRouter);
app.use(documentRouter);

const DB = `mongodb+srv://${process.env.DB_USERNAME}:${process.env.DB_PASSWORD}@cluster0.q4uhmzy.mongodb.net/?retryWrites=true&w=majority`;

mongoose.connect(DB).then(() => console.log('Connection Successful! 🙃')).catch((err) => console.log(`Database Error: ${err}`))

io.on('connection', (socket) => {
    console.log('Connected Our Socket:' + socket.id);

    // The documentId could be any variable at all, but here, it's representing our documentId
    socket.on('join', (documentId) => {
        socket.join(documentId)
        console.log("Joined a room with ID: "+ documentId);
    });
});

// Since we are now using the 'server', we won't listen on the 'app' anymore
// app.listen(PORT, "0.0.0.0", () => {
//     console.log(`Connected at port: http://localhost:${PORT}`)
// });

server.listen(PORT, "0.0.0.0", () => {
    console.log(`Connected at port: http://localhost:${PORT}`)
});