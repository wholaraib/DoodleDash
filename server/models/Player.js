const mongoose = require("mongoose");

const playerSchema = new mongoose.Schema({
  name: { type: String, trim: true },
  socketID: { type: String },
  isHost: { type: Boolean, default: false },
  score: { type: Number, default: 0 },
});

const PlayerModel = mongoose.model("Player", playerSchema);

module.exports = { PlayerModel, playerSchema };
