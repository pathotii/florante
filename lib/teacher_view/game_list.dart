import 'package:flutter/material.dart';
import 'guessthecharacter.dart';
import 'matchinggame.dart';

class TeacherGameList extends StatefulWidget {

  const TeacherGameList({super.key});

  @override
  _TeacherGameListState createState() => _TeacherGameListState();
}

class _TeacherGameListState extends State<TeacherGameList> {
  late List<Map<String, dynamic>> games;

  @override
  void initState() {
    super.initState();
    // Initialize the games list inside initState
    games = [
      {
        'title': 'Guess the Character',
        'route': const TeacherGuessTheCharacterQuiz()
      },
      {'title': 'Card Flipping', 'route': const TeacherMatchingGame()},
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
