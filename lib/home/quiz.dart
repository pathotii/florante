import 'dart:async';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login/login.dart';
import 'home.dart';
import 'tauhan.dart';

class GuessTheCharacterQuiz extends StatefulWidget {
  final String firstName;
  final String email;

  const GuessTheCharacterQuiz({super.key, required this.firstName, required this.email});

  @override
  _GuessTheCharacterQuizState createState() => _GuessTheCharacterQuizState();
}

class _GuessTheCharacterQuizState extends State<GuessTheCharacterQuiz> {
  final List<Map<String, dynamic>> characters = [
    {
      'image': 'assets/images/FloranteCharacter-removebg-preview-Photoroom.png',
      'options': ['Florante', 'Adolfo', 'Aladin', 'Menandro'],
      'correctAnswer': 'Florante',
    },
    {
      'image': 'assets/images/Laura-removebg-preview.png',
      'options': ['Laura', 'Flerida', 'Adolfo', 'Prinsesa Floresca'],
      'correctAnswer': 'Laura',
    },
    {
      'image': 'assets/images/Count_Adolfo-removebg-preview.png',
      'options': ['Adolfo', 'Florante', 'Aladin', 'Duke Briseo'],
      'correctAnswer': 'Adolfo',
    },
    {
      'image': 'assets/images/Aladin-removebg-preview.png',
      'options': ['Adolfo', 'Florante', 'Aladin', 'Duke Briseo'],
      'correctAnswer': 'Aladin',
    },
    {
      'image': 'assets/images/Flerida-removebg-preview.png',
      'options': ['Prinsesa Laura', 'Florante', 'Adolfo', 'Flerida'],
      'correctAnswer': 'Flerida',
    },
    {
      'image': 'assets/images/Menandro-removebg-preview.png',
      'options': ['Menandro', 'Florante', 'Aladin', 'Duke Linceo'],
      'correctAnswer': 'Menandro',
    },
    {
      'image': 'assets/images/Duke_Briseo-removebg-preview.png',
      'options': ['Haring Briseo', 'Antenor', 'Aladin', 'Duke Briseo'],
      'correctAnswer': 'Duke Briseo',
    },
    {
      'image': 'assets/images/Princess_Floresca-removebg-preview.png',
      'options': ['Prinsesa Floresca', 'Aladin', 'Laura', 'Flerida'],
      'correctAnswer': 'Prinsesa Floresca',
    },
    {
      'image': 'assets/images/King_Linceo-removebg-preview.png',
      'options': ['Adolfo', 'Florante', 'Haring Linceo', 'Duke Briseo'],
      'correctAnswer': 'Haring Linceo',
    },
    {
      'image': 'assets/images/Antenor-removebg-preview.png',
      'options': ['Adolfo', 'Antenor', 'Aladin', 'Ali-Adab'],
      'correctAnswer': 'Antenor',
    },
    {
      'image': 'assets/images/General_Miramolin-removebg-preview.png',
      'options': ['Adolfo', 'Florante', 'Aladin', 'Heneral Miramolin'],
      'correctAnswer': 'Heneral Miramolin',
    },
    {
      'image': 'assets/images/General_Osmalik-removebg-preview.png',
      'options': [
        'Heneral Osmalik',
        'Heneral Miramolin',
        'Hari ng Krotona',
        'Heneral Florante'
      ],
      'correctAnswer': 'Heneral Osmalik',
    },
    {
      'image': 'assets/images/Sultan_Ali-Adab-removebg-preview.png',
      'options': ['Sultan Ali-Adab', 'Florante', 'Aladin', 'Duke Briseo'],
      'correctAnswer': 'Sultan Ali-Adab',
    },
    {
      'image': 'assets/images/King_of_Crotona-removebg-preview.png',
      'options': [
        'Hari ng Krotona',
        'Ama ng Krotona',
        'Heneral Osmalik',
        'Duke Briseo'
      ],
      'correctAnswer': 'Hari ng Krotona',
    },
  ];
  int selectedIndex = 1;
  int _currentQuestionIndex = 0;
  int _score = 0;
  String _userAnswer = '';
  int _timer = 15;
  late Timer _countdownTimer;
  final FlipCardController _flipCardController = FlipCardController();
  bool _isAnswered = false;
  bool _showNextCard = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timer > 0) {
        setState(() {
          _timer--;
        });
      } else {
        _nextCard();
      }
    });
  }

  void _nextCard() {
    setState(() {
      _showNextCard = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showNextCard = false;
      });
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < characters.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _timer = 15; // Reset the timer for the next question
        _isAnswered = false; // Reset the answered flag
      });
    } else {
      _showEndGameDialog();
    }
  }

  void _showEndGameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Tapos na!',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: 'AnandaBlack',
              fontSize: 12,
            ),
          ),
          content: Text(
            'Ang iyong score ay: $_score',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'Bumalik sa Homepage',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'AnandaBlack',
                    fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  void _startTimerOnFlip() {
    // Start the timer only if it's not already running
    if (_timer == 15 && !_countdownTimer.isActive) {
      _startTimer();
    }
  }

  void _nextQuestionWithAnswer(String answer) {
    if (_isAnswered) return;

    setState(() {
      _userAnswer = answer;
      _isAnswered = true;
      if (answer == characters[_currentQuestionIndex]['correctAnswer']) {
        _score++;
      }
    });

    _flipCardController.toggleCard();
    Future.delayed(const Duration(seconds: 2), () {
      _nextCard();
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    // Ensure characters list is not empty
    if (characters.isEmpty) {
      return Center(child: Text("Walang Karakter"));
    }

    final slide = characters[_currentQuestionIndex];
    final options = slide['options'] ?? [];

    // Debugging: Check if the options are valid
    if (options.isEmpty) {
      print('Warning: No options available for current question');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/bg4th.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: media.width * 0.02),
              child: AnimatedSwitcher(
                duration: const Duration(seconds: 2), // Smooth slide transition
                child: _showNextCard
                    ? const SizedBox.shrink()
                    : FlipCard(
                        key: ValueKey<int>(_currentQuestionIndex +
                            slide['name']
                                .hashCode), // Ensure unique key using hashCode
                        controller: _flipCardController,
                        direction: FlipDirection.HORIZONTAL,
                        onFlip: _startTimerOnFlip,
                        front: Container(
                          width: media.width * 0.9,
                          height: media.height * 0.6,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage("assets/images/bgtauhan.png"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(media.width * 0.05),
                            child: Image.asset(
                              slide['image'],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        back: Container(
                          width: media.width * 0.9,
                          height: media.height * 0.6,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage("assets/images/bgtauhan.png"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 55, vertical: 25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sino ang Karakter?",
                                    style: TextStyle(
                                      fontFamily: 'Blacksword',
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: media.width * 0.05),
                                  Text(
                                    'Time left: $_timer',
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  SizedBox(height: media.width * 0.05),
                                  // ListView for options
                                  Expanded(
                                    child: options.isNotEmpty
                                        ? ListView.builder(
                                            itemCount: options.length,
                                            itemBuilder: (context, i) {
                                              final option = options[i];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0),
                                                child: SizedBox(
                                                  width: media.width * 0.5,
                                                  child: ElevatedButton(
                                                    onPressed: _isAnswered
                                                        ? null
                                                        : () {
                                                            _nextQuestionWithAnswer(
                                                                option);
                                                          },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 15),
                                                      backgroundColor: Colors
                                                          .white
                                                          .withOpacity(0.8),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      option,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'AnandaBlack',
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.black
                                                            .withOpacity(0.8),
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : const Text(
                                            'No options available.',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.red),
                                          ),
                                  ),
                                  SizedBox(height: media.width * 0.05),
                                  if (_isAnswered)
                                    Text(
                                      _userAnswer == slide['correctAnswer']
                                          ? 'Correct!'
                                          : 'Wrong! The correct answer is ${slide['correctAnswer']}.',
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.red),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
          Positioned(
            bottom: media.height * 0.05,
            left: media.width * 0.1,
            right: media.width * 0.1,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/bgtauhan.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Score: $_score',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quizzes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mga Tauhan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout_outlined),
            label: 'Logout',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Tauhan(
                        firstName: widget.firstName, email: widget.email,
                      )),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Home(firstName: widget.firstName, email: '',)),
            );
          } else if (index == 3) {
            _handleLogout();
          }
        },
      ),
    );
  }

  Future<void> _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Set 'isLoggedIn' to false to indicate the user is logged out
    await prefs.setBool('isLoggedIn', false);

    // Remove the stored email from SharedPreferences
    await prefs.remove('email');

    // Optionally, remove other stored data like tokens, user-specific info
    await prefs.remove('userToken'); // Example: remove user token if stored

    // Show a Snackbar indicating the user has logged out
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have logged out successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to the login screen or another appropriate page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const LoginView(), // Assuming LoginPage is your login screen
      ),
    );
  }
}
