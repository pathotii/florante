import 'package:flutter/material.dart';
import 'card_game.dart'; // Import Card Flipping game screen
import 'quiz.dart'; // Import Guess the Character game screen

class GameList extends StatefulWidget {
  final String firstName;
  final String email;

  const GameList({super.key, required this.firstName, required this.email});

  @override
  _GameListState createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  late List<Map<String, dynamic>> games;

  @override
  void initState() {
    super.initState();
    // Initialize the games list inside initState
    games = [
      {
        'title': 'Guess the Character',
        'route': GuessTheCharacterQuiz(firstName: widget.firstName, email: widget.email,)
      },
      {'title': 'Card Flipping', 'route': const MatchingGame()},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game List'),
      ),
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/Add a heading (5).png', // Background image
            fit:
                BoxFit.cover, // This ensures the image covers the entire screen
          ),
        ),
        ListView.builder(
          itemCount: games.length, // Number of games in the list
          itemBuilder: (context, index) {
            final game = games[index];

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(game['title']),
                onTap: () {
                  // Navigate to the selected game screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => game['route']),
                  );
                },
              ),
            );
          },
        ),
      ]),
    );
  }
}
