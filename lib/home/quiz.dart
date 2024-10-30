import 'package:flutter/material.dart';
import 'description.dart';

class QuizPage extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final int kabanataIndex;
  final String bookname;
  final String firstName;

  const QuizPage({
    super.key,
    required this.firstName,
    required this.questions,
    required this.bookname,
    required this.kabanataIndex,
  });

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = -1; // Track the selected option
  int currentQuestionIndex = 0; // Track the current question

  List<int> selectedAnswers = []; // Track user's answers
  int score = 0; // Track score

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextQuestion() {
    if (selectedIndex == -1) {
      // No option has been selected
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Panuto!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/questioned.png', // Path to your image
                height: 150,
                width: 180,
              ),
              const SizedBox(height: 10),
              const Text(
                'Pumili ng isang sagot bago magpatuloy!',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w200,
                ),
              ), // Message in Filipino
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return; // Exit the method if no answer is selected
    }

    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        selectedAnswers.add(selectedIndex); // Store selected answer
        currentQuestionIndex++;
        selectedIndex = -1; // Reset selection for the next question
      });
    } else {
      // Store the last answer
      selectedAnswers.add(selectedIndex);
      score = calculateScore();
      showScoreDialog();

      setState(() {
        currentQuestionIndex = 0;
        selectedIndex = -1; // Reset selection
        selectedAnswers.clear(); // Clear answers for the next quiz
      });
    }
  }

  int calculateScore() {
    int correctAnswers = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      // Convert correctAnswerIndex to int for comparison
      if (selectedAnswers[i] ==
          int.parse(widget.questions[i]['correctAnswerIndex'])) {
        correctAnswers++;
      }
    }
    return correctAnswers;
  }

  void showScoreDialog() {
    double percentage = (score / widget.questions.length) * 100;

    // Set the end value for the animation
    _animation =
        Tween<double>(begin: 0, end: percentage).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward(); // Start the animation

    showDialog(
      context: context,
      builder: (context) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return AlertDialog(
              title: const Text('Nakumpleto mo ang Pagsusulit!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Ito ang iyong score ${widget.firstName}'),
                  const SizedBox(height: 5),
                  Center(
                    child:
                    Text('Your score: $score/${widget.questions.length}')),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: _animation.value / 100, // Use animated value
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('${_animation.value.toStringAsFixed(1)}%'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Description(
                        bookname: widget.bookname,
                        questions: widget.questions,
                        kabanataIndex: widget.kabanataIndex,
                        firstName: widget.firstName,
                      ),
                    )); // Navigate to description.dart
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionData = widget.questions[currentQuestionIndex];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Stack(
          children: [
            // Background image
            Image.asset(
              'assets/images/question_group.png', // Your background image
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 75),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Mga Katanungan ${currentQuestionIndex + 1}/${widget.questions.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      questionData['question'],
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.brown[600],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Display options dynamically
                  for (int i = 0; i < questionData['options'].length; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = i; // Set selected option
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: selectedIndex == i
                                ? Colors.orange[300]
                                : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: selectedIndex == i
                                  ? Colors.orange[300]!
                                  : Colors.orange,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              questionData['options'][i],
                              style: TextStyle(
                                color: selectedIndex == i
                                    ? Colors.white
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),

                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.orange),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                          ),
                          child: const Text(
                            'Bumalik',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            nextQuestion();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                          ),
                          child: Text(
                            currentQuestionIndex < widget.questions.length - 1
                                ? 'Sunod'
                                : 'Finish',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
