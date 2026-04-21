abstract class RoomData {
  String get roomName;
  Map<String, dynamic> toMap();
}

class CreateRoomData extends RoomData {
  final String playerName;
  final String roomName;
  final int rounds;
  final int roomSize;

  CreateRoomData({
    required this.playerName,
    required this.roomName,
    required this.rounds,
    required this.roomSize,
  });

  @override
  Map<String, dynamic> toMap() => {
    "playerName": playerName,
    "roomName": roomName,
    "rounds": rounds,
    "roomSize": roomSize,
  };
}

class JoinRoomData extends RoomData {
  final String playerName;
  final String roomName;

  JoinRoomData({
    required this.playerName,
    required this.roomName,
  });

  @override
  Map<String, dynamic> toMap() => {
    "playerName": playerName,
    "roomName": roomName,
  };
}