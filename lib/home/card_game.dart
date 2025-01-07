import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import '../database_table/cardmodel.dart'; // Ensure this file contains your CardModel

class MatchingGame extends StatefulWidget {
  const MatchingGame({super.key});

  @override
  _MatchingGameState createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  late List<CardModel> cards;
  List<CardModel> flippedCards = []; // Store flipped cards
  List<CardModel> matchedCards = []; // Store matched cards (matched pairs)
  int matchedPairs = 0; // Count of matched pairs
  int moves = 0; // Count of moves
  bool isProcessing = false; // Prevent multiple flips at once
  late Timer _timer; // Timer to handle countdown
  int _remainingTime = 120; // 2 minutes in seconds

  // Image paths for the game (duplicated for matching)
  final List<String> imagePaths1 = [
    'assets/images/Aladin-removebg-preview.png',
    'assets/images/Antenor-removebg-preview.png',
    'assets/images/Count_Adolfo-removebg-preview.png',
    'assets/images/Duke_Briseo-removebg-preview.png',
    'assets/images/Flerida-removebg-preview.png',
    'assets/images/FloranteCharacter-removebg-preview-Photoroom.png',
    'assets/images/General_Miramolin-removebg-preview.png',
    'assets/images/General_Osmalik-removebg-preview.png',
    'assets/images/King_Linceo-removebg-preview.png',
    'assets/images/King_of_Crotona-removebg-preview.png',
    'assets/images/Laura-removebg-preview.png',
    'assets/images/Menandro-removebg-preview.png',
    'assets/images/Princess_Floresca-removebg-preview.png',
    'assets/images/Sultan_Ali-Adab-removebg-preview.png',
  ];

  // Create a second list of identical images
  final List<String> imagePaths2 = [
    'assets/images/Aladin-removebg-preview.png',
    'assets/images/Antenor-removebg-preview.png',
    'assets/images/Count_Adolfo-removebg-preview.png',
    'assets/images/Duke_Briseo-removebg-preview.png',
    'assets/images/Flerida-removebg-preview.png',
    'assets/images/FloranteCharacter-removebg-preview-Photoroom.png',
    'assets/images/General_Miramolin-removebg-preview.png',
    'assets/images/General_Osmalik-removebg-preview.png',
    'assets/images/King_Linceo-removebg-preview.png',
    'assets/images/King_of_Crotona-removebg-preview.png',
    'assets/images/Laura-removebg-preview.png',
    'assets/images/Menandro-removebg-preview.png',
    'assets/images/Princess_Floresca-removebg-preview.png',
    'assets/images/Sultan_Ali-Adab-removebg-preview.png',
  ];

  final String cardBackImage =
      'assets/images/bgtauhan.png'; // The background image

  @override
  void initState() {
    super.initState();
    cards = createCards(imagePaths1, imagePaths2); // Initialize the cards
    _startTimer(); // Start the countdown timer
  }

  // Function to create cards with duplicates for matching
  List<CardModel> createCards(
      List<String> imagePaths1, List<String> imagePaths2) {
    List<CardModel> cardList = [];

    // Combine both image lists (original and duplicate) to create card pairs
    for (int i = 0; i < imagePaths1.length; i++) {
      cardList.add(CardModel(id: i, image: imagePaths1[i]));
      cardList.add(CardModel(
          id: i + imagePaths1.length,
          image: imagePaths2[i])); // Duplicate each card
    }

    // Shuffle the cards
    cardList.shuffle();

    return cardList;
  }

  // Start the timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
          // Show dialog when time is up
          _showTimeUpDialog();
        }
      });
    });
  }

  // Handle the flip of a card
  void flipCard(int index) {
    if (isProcessing || cards[index].isFlipped)
      return; // Ignore if already flipped or processing

    setState(() {
      cards[index].isFlipped = true;
      flippedCards.add(cards[index]); // Store the flipped card
      moves++;
    });

    // Print the flippedCards content
    print('Flipped Cards: ${flippedCards.map((card) => card.id).toList()}');

    if (flippedCards.length == 2) {
      // We have two cards flipped, now compare them
      print(
          'Comparing cards: ${flippedCards[0].image} vs ${flippedCards[1].image}');

      if (flippedCards[0].image == flippedCards[1].image) {
        // Cards match
        matchedPairs++;
        matchedCards
            .addAll(flippedCards); // Add matched cards to matchedCards list
        print('Matched Cards: ${matchedCards.map((card) => card.id).toList()}');

        // Clear flippedCards after match
        flippedCards.clear();

        if (matchedPairs == imagePaths1.length) {
          // Game is completed
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('You Win!'),
                content: Text('You matched all pairs in $moves moves!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      resetGame();
                    },
                    child: const Text('Play Again'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Cards don't match, flip them back after a short delay
        isProcessing = true;
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            // Flip the cards back
            flippedCards[0].isFlipped = false;
            flippedCards[1].isFlipped = false;
            flippedCards.clear(); // Reset the flipped cards list
            isProcessing = false;
          });
        });
      }
    }
  }

  // Reset the game
  void resetGame() {
    setState(() {
      cards = createCards(imagePaths1, imagePaths2);
      matchedPairs = 0;
      moves = 0;
      flippedCards.clear();
      matchedCards.clear(); // Clear the matched cards as well
      _remainingTime = 120; // Reset timer to 2 minutes
    });

    // Restart the timer
    _startTimer();
  }

  // Show dialog when time is up
  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Time Up!'),
          content: Text(
            'You didn\'t finish matching all the cards in time.\n\n'
            'Moves: $moves\nMatched Pairs: $matchedPairs',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetGame(); // Reset the game after time is up
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _remainingTime ~/ 60;
    int seconds = _remainingTime % 60;

    return Scaffold(
      appBar: AppBar(title: const Text('Matching Game')),
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/Add a heading (5).png', // Background image
            fit:
                BoxFit.cover, // This ensures the image covers the entire screen
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Moves: $moves',
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Time: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 cards per row
                  childAspectRatio: 1,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      flipCard(index); // Call flipCard on tap
                    },
                    child: Card(
                      margin: const EdgeInsets.all(8),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: cards[index].isFlipped
                            ? Image.asset(
                                cards[index].image,
                                key: ValueKey(cards[index].id),
                                fit: BoxFit
                                    .cover, // Ensures the front image covers the card
                              )
                            : Container(
                                key: const ValueKey('back'),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(cardBackImage),
                                    fit: BoxFit
                                        .cover, // Ensures the back image covers the card
                                  ),
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
