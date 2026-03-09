const { playerSchema } = require("./Player.js");

const mongoose = require("mongoose");

const roomSchema = new mongoose.Schema({
  word: { type: String },
  roomName: { type: String, required: true, unique: true, trim: true },
  rounds: { type: Number, required: true, default: 2 },
  roomSize: { type: Number, required: true, default: 2 },
  currentRound: { type: Number, required: true, default: 1 },
  players: [playerSchema],
  isJoin: {
    type: Boolean,
    default: true,
  },
  turn: playerSchema,
  turnIndex: {
    type: Number,
    default: 0,
  },
});

const RoomModel = mongoose.model("Room", roomSchema);

module.exports = RoomModel;
