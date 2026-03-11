import 'package:doodledash/models/room_data.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../screens/paint_screen.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  String _selectedRounds = "2";
  String _selectedRoomSize = "2";

  void createRoom() {
    if (_nameController.text.isEmpty || _roomNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text('Please enter both your name and a room name.'),
          ),
        ),
      );
      return;
    } else {
      final data = CreateRoomData(
        playerName: _nameController.text,
        roomName: _roomNameController.text,
        rounds: int.parse(_selectedRounds),
        roomSize: int.parse(_selectedRoomSize),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              PaintScreen(roomData: data, screenType: ScreenType.create),
        ),
      );
    }
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      items: items
          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1565C0),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Create a Room',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Set up your room and invite friends to play.',
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),
              CustomTextField(label: 'Your name', controller: _nameController),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Room name',
                controller: _roomNameController,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Number of rounds',
                value: _selectedRounds,
                items: ["2", "3", "5", "10", "15"],
                onChanged: (value) => setState(() => _selectedRounds = value!),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Room size',
                value: _selectedRoomSize,
                items: ["2", "3", "4", "5", "6", "7", "8"],
                onChanged: (value) =>
                    setState(() => _selectedRoomSize = value!),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: createRoom,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Create Room'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
