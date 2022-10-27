const express = require('express');
const mongoose = require('mongoose');
const dotenv = require("dotenv");
const authRouter = require('./routes/auth');
const cors = require('cors');

dotenv.config();

const PORT = process.env.PORT | 3001;

const app = express();

app.use(cors());
// This helps with transmitting data to and from db
app.use(express.json());

app.use(authRouter);

const DB = `mongodb+srv://${process.env.DB_USERNAME}:${process.env.DB_PASSWORD}@cluster0.q4uhmzy.mongodb.net/?retryWrites=true&w=majority`;

mongoose.connect(DB).then(() => console.log('Connection Successful! 🙃')).catch((err) => console.log(`Database Error: ${err}`))


app.listen(PORT, "0.0.0.0", () => {
    console.log(`Connected at port: http://localhost:${PORT}`)
});