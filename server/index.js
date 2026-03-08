require('dotenv').config();

const express = require('express');
var http = require('http');

const app = express();
const PORT = process.env.PORT || 3000;
const server = http.createServer(app);
const mongoose = require('mongoose');
const io = require('socket.io')(server);

// middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const DB = process.env.MONGO_URI;

mongoose.connect(DB, {
}).then(() => {
  console.log('Connected to MongoDB');
}).catch((err) => {
  console.error('Error connecting to MongoDB:', err);
});

app.get('/', (req, res) => {
  res.send('Hiii!');
});

server.listen(PORT,"0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});