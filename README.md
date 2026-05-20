# 🎨 DoodleDash

DoodleDash is a real-time multiplayer scribble game built using Flutter, Node.js, MongoDB, and Socket.IO.

Players can create private rooms, invite friends using a room code, draw secret words, guess in real time, and compete for the highest score across multiple rounds.

---

# ✨ Features

* 🎮 Real-time multiplayer gameplay
* 🏠 Create and join private game rooms
* ✏️ Live synchronized drawing canvas
* 💬 Real-time chat system
* 🧠 Word guessing mechanics
* 🏆 Score tracking & winner leaderboard
* ⏳ Multiple rounds support
* 👥 Configurable room size
* ⚡ Low-latency gameplay using WebSockets

---

# 📱 Screenshots

<img width="300" height="600" alt="Simulator Screenshot - iPhone 17 - 2026-05-17 at 22 53 40" src="https://github.com/user-attachments/assets/e65e02fe-ca0e-4b1a-8670-9fa19e0064ea" />


---

# 🛠️ Tech Stack

## Frontend

* Flutter
* Dart

## Backend

* Node.js
* Express.js

## Database

* MongoDB

## Real-time Communication

* Socket.IO

---

# ⚙️ How It Works

1. A player creates a custom room.
2. Friends join using the room code.
3. Players wait together in a live lobby.
4. One player draws a secret word.
5. Other players guess using the chat.
6. Points are awarded for correct guesses.
7. After all rounds, the player with the highest score wins.

---

# 🧠 Challenges Solved

* Real-time canvas synchronization
* Multiplayer state management
* Live chat processing
* Timer synchronization
* Handling player disconnects gracefully
* Smooth drawing performance with minimal lag

---

# 🚀 Getting Started

## Prerequisites

Make sure you have installed:

* Flutter SDK
* Node.js
* MongoDB

---

## Clone the Repository

```bash
git clone https://github.com/wholaraib/DoodleDash.git
cd DoodleDash
```

---

# 📦 Frontend Setup

```bash
flutter pub get
flutter run
```

---

# 🔧 Backend Setup

```bash
cd server
npm install
npm start
```

---

# 🌐 Environment Variables

Create a `.env` file in the backend folder and add:

```env
MONGO_URI=your_mongodb_connection_string
PORT=3000
```

---

# 🤝 Contributing

Contributions, ideas, and feedback are always welcome!

Feel free to fork the repository and submit a pull request.

---

# 📜 License

This project is licensed under the MIT License.

---

# 👨‍💻 Author

Built with ❤️ by Laraib
