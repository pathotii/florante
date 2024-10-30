import 'package:flutter/material.dart';
import '../home/description.dart';

class Home extends StatefulWidget {
  final String firstName;

  const Home({super.key, required this.firstName});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 2;
  bool aiOverlayVisible = true;
  int? selectedItem;

  final List<List<Map<String, dynamic>>> questions = [
    // Kabanata 1
    [
      {
        'question': 'What is the main theme of Kabanata 1?',
        'options': ['Correct', 'Theme B', 'Theme C', 'Theme D'],
        'correctAnswerIndex': '0'
      },
      {
        'question': 'Who is the main character in Kabanata 1?',
        'options': ['Character A', 'Correct', 'Character C', 'Character D'],
        'correctAnswerIndex': '1'
      },
      {
        'question': 'What is your favorite food?',
        'options': ['Character A', 'Correct', 'Character C', 'Character D'],
        'correctAnswerIndex': '1'
      },
      {
        'question': 'Where is your favorite place?',
        'options': ['Character A', 'Correct', 'Character C', 'Character D'],
        'correctAnswerIndex': '1'
      }
    ],
    // Kabanata 2
    [
      {
        'question': 'What event occurs in Kabanata 2?',
        'options': ['Event A', 'Event B', 'Event C', 'Event D']
      },
      {
        'question': 'What lesson can be learned from Kabanata 2?',
        'options': ['Lesson A', 'Lesson B', 'Lesson C', 'Lesson D']
      }
    ],
    // Kabanata 3
    [
      {
        'question': 'What event occurs in Kabanata 3?',
        'options': ['Event A', 'Event B', 'Event C', 'Event D']
      },
      {
        'question': 'What lesson can be learned from Kabanata 3?',
        'options': ['Lesson A', 'Lesson B', 'Lesson C', 'Lesson D']
      }
    ],
    // Kabanata 4
    [
      {
        'question': 'What event occurs in Kabanata 4?',
        'options': ['Event A', 'Event B', 'Event C', 'Event D']
      },
      {
        'question': 'What lesson can be learned from Kabanata 4?',
        'options': ['Lesson A', 'Lesson B', 'Lesson C', 'Lesson D']
      }
    ],
    // Kabanata 5
    [
      {
        'question': 'What event occurs in Kabanata 5?',
        'options': ['Event A', 'Event B', 'Event C', 'Event D']
      },
      {
        'question': 'What lesson can be learned from Kabanata 5?',
        'options': ['Lesson A', 'Lesson B', 'Lesson C', 'Lesson D']
      }
    ],
    // Kabanata 6
    [
      {
        'question': 'What event occurs in Kabanata 6?',
        'options': ['Event A', 'Event B', 'Event C', 'Event D']
      },
      {
        'question': 'What lesson can be learned from Kabanata 6?',
        'options': ['Lesson A', 'Lesson B', 'Lesson C', 'Lesson D']
      }
    ],
    // Kabanata 7
    [
      {
        'question': 'What event occurs in Kabanata 7?',
        'options': ['Event A', 'Event B', 'Event C', 'Event D']
      },
      {
        'question': 'What lesson can be learned from Kabanata 7?',
        'options': ['Lesson A', 'Lesson B', 'Lesson C', 'Lesson D']
      }
    ],
    // Add more questions for additional Kabanata
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/Android Large - 1.png',
            fit: BoxFit.cover,
          ),
          if (aiOverlayVisible)
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
          AbsorbPointer(
            absorbing: aiOverlayVisible,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false, // Remove back button
                  centerTitle: true,
                  elevation: 0,
                  expandedHeight: media.width * 0.88,
                  flexibleSpace: const FlexibleSpaceBar(
                    background: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedItem = index;
                          });
                        },
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(aiOverlayVisible ? 0.3 : 0.9),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.orange,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/florante.png',
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        'Kabanata ${index + 1}',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Title ${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.brown,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: questions.length,
                  ),
                ),
              ],
            ),
          ),
          if (selectedItem != null)
            Positioned(
              top: 110,
              left: 10,
              right: 10,
              child: AbsorbPointer(
                absorbing: aiOverlayVisible,
                child: Opacity(
                  opacity: aiOverlayVisible ? 0.3 : 1.0,
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.orange, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/florante.png',
                                  width: 80,
                                  height: 80,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'KABANATA ${selectedItem! + 1}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Lorem Ipsum Dolor Sit Sit Lorem Ipsum Dolor Sit Sit Lorem Ipsum Dolor Sit Sit Lorem Ipsum Dolor Sit Sit Lorem Ipsum Dolor Sit Sit Lorem Ipsum Dolor Sit Sit Lorem Ipsum Dolor Sit Sit...',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.brown),
                                        textAlign: TextAlign.justify,
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (selectedItem != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Description(
                                              bookname: 'Book Title',
                                              kabanataIndex: selectedItem!,
                                              questions:
                                                  questions[selectedItem!],
                                              firstName: widget.firstName,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(
                                          color: Colors.orange),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                    ),
                                    child: const Text(
                                      'Open',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedItem = null;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                    ),
                                    child: const Text(
                                      'Close',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // AI Button (Right)
          Positioned(
            top: 40,
            right: 0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    aiOverlayVisible =
                        true; // Show the overlay when button is pressed
                  });
                },
                style: ElevatedButton.styleFrom(
                  elevation: 15,
                  shadowColor: Colors.black,
                  backgroundColor: Colors.orange.withOpacity(0.99),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          if (aiOverlayVisible)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 48),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18), // Default style
                            children: [
                              const TextSpan(
                                  text: "Magandang Araw, ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                              TextSpan(
                                text: "${widget.firstName}!",
                                style: const TextStyle(
                                    fontWeight: FontWeight
                                        .bold), // Bold style for the name
                              ),
                              const TextSpan(
                                  text: "\n\nAko ang iyong AI Assistant.",
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.navigate_next_outlined,
                              color: Colors.black),
                          onPressed: () {
                            setState(() {
                              aiOverlayVisible = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Image.asset(
                      'assets/images/florante.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Salitalaan',
          ),
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
            label: 'Profile',
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
        },
      ),
    );
  }
}
