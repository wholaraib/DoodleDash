require("dotenv").config();

const express = require("express");
var http = require("http");

const app = express();
const PORT = process.env.PORT || 3000;
const server = http.createServer(app);
const mongoose = require("mongoose");
const io = require("socket.io")(server);
const RoomModel = require("./models/Room.js");
const getRandomWord = require("./api/getRandomWord.js");

// middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const DB = process.env.MONGO_URI;

mongoose
  .connect(DB, {})
  .then(() => {
    console.log("Connected to MongoDB");
  })
  .catch((err) => {
    console.error("Error connecting to MongoDB:", err);
  });

io.on("connection", (socket) => {
  console.log("A user connected: " + socket.id);

  // Create game event
  socket.on(
    "create-game",
    async ({ playerName, roomName, rounds, roomSize }) => {
      try {
        const existingRoom = await RoomModel.findOne({ roomName: roomName });
        if (existingRoom) {
          socket.emit("error", {
            message:
              "Room name already exists. Please choose a different name.",
          });
          return;
        }
        let room = new RoomModel();
        const word = getRandomWord();
        room.word = word;
        room.roomName = roomName;
        room.rounds = rounds;
        room.roomSize = roomSize;
        room.players.push({
          name: playerName,
          socketID: socket.id,
          isHost: true,
        });
        await room.save();
        socket.join(roomName);
        io.to(roomName).emit("room-updated", room);
      } catch (err) {
        console.error("Error handling create-room event:", err);
      }
      // Handle game creation logic here
    },
  );

  // Join game event

  socket.on("join-game", async ({ playerName, roomName }) => {
    try {
      let room = await RoomModel.findOne({ roomName: roomName });
      if (!room) {
        socket.emit("error", {
          message: "Room not found. Please check the room name and try again.",
        });
        return;
      }
      if (room.isJoin === true) {
        let player = {
          name: playerName,
          socketID: socket.id,
        };
        room.players.push(player);
        socket.join(roomName);
        if (room.players.length === room.roomSize) {
          room.isJoin = false;
        }
        room.turn = room.players[room.turnIndex];
        room = await room.save();
        io.to(roomName).emit("room-updated", room);
      } else {
        socket.emit("error", {
          message: "The room is full. You cannot join this room.",
        });
      }
    } catch (err) {
      console.error("Error handling join-game event:", err);
    }
  });

  // Paint event - white board sockets
  socket.on("paint", ({ details, roomName }) => {
    io.to(roomName).emit("points", { details: details });
  });

  // Color change socket
  socket.on("color-change", ({ color, roomName }) => {
    io.to(roomName).emit("color-changed", { color: color });
  });

  // Clear canvas socket
  socket.on("clear-canvas", ({ roomName }) => {
    io.to(roomName).emit("canvas-cleared");
  });

  // Stroke width change socket
  socket.on("stroke-width-change", ({ strokeWidth, roomName }) => {
    io.to(roomName).emit("stroke-width-changed", { strokeWidth: strokeWidth });
  });

  // chat message socket
  socket.on(
    "send-message",
    ({ message, username, roomName, word, guessedUserCounter }) => {
      io.to(roomName).emit("new-message", {
        playerName: username,
        message: message,
        word: word,
        guessedUserCounter: guessedUserCounter,
      });
    },
  );

  // change turn socket
  socket.on("change-turn", async (roomName) => {
    try {
      let room = await RoomModel.findOne({ roomName: roomName });
      let idx = room.turnIndex;
      if (idx + 1 === room.players.length) {
        room.currentRound += 1;
      }
      if (room.currentRound <= room.rounds) {
        const word = getRandomWord();
        room.word = word;
        room.turnIndex = (idx + 1) % room.players.length;
        room.turn = room.players[room.turnIndex];
        room = await room.save();
        io.to(roomName).emit("change-turn", room);
      } else {
        io.to(roomName).emit("show-leaderboard", room.players);
      }
    } catch (err) {
      console.log(err);
    }
  });

  socket.on("disconnect", () => {
    console.log("A user disconnected: " + socket.id);
  });
});

app.get("/", (req, res) => {
  res.send("Hello World!");
});

server.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
