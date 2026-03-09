class RoomData {
  final String playerName;
  final String roomName;
  final int rounds;
  final int roomSize;

  RoomData({
    required this.playerName,
    required this.roomName,
    required this.rounds,
    required this.roomSize,
  });

  Map<String, dynamic> toMap() => {
    "playerName": playerName,
    "roomName": roomName,
    "rounds": rounds,
    "roomSize": roomSize,
  };
}