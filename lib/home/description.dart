import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:florante/home/home.dart';
import 'package:flutter/material.dart';
import 'quizproper.dart';

class Description extends StatefulWidget {
  final String firstName;
  final String email;
  final String bookname;
  final int kabanataIndex;
  final List<Map<String, dynamic>> preSavedItems;
  final Map<int, List<Map<String, dynamic>>> talasalitaan;
  final Map<int, List<Map<String, String>>> aralMensahe;

  const Description({
    super.key,
    required this.firstName,
    required this.bookname,
    required this.kabanataIndex,
    required this.preSavedItems,
    required this.talasalitaan,
    required this.aralMensahe,
    required this.email,
  });

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  late String selectedBuod;
  late List<Map<String, String>> selectedAralMensahe;
  bool hasTakenQuiz = false;

  

  @override
  void initState() {
    super.initState();
    checkIfQuizTaken();
    selectedBuod = widget.preSavedItems[widget.kabanataIndex]['buod'] ??
        'No Buod available';
    selectedAralMensahe = widget.aralMensahe[widget.kabanataIndex + 1] ?? [];
  }

  Future<void> checkIfQuizTaken() async {
    try {
      // Retrieve the documents once using `get`
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('quizResults')
          .where('email', isEqualTo: widget.email)
          .where('kabanataAnswered', isEqualTo: widget.kabanataIndex + 1)
          .where('quizTaken', isEqualTo: 'Taken') // Check for the 'Taken' field
          .get();

      print(
          "Firestore Query Snapshot: ${snapshot.docs.map((doc) => doc.data()).toList()}");

      // Check if the documents are empty or not and update the state accordingly
      setState(() {
        hasTakenQuiz = snapshot.docs.isNotEmpty;
      });
    } catch (e) {
      print("Error checking quiz result: $e");
      setState(() {
        hasTakenQuiz = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    List<Map<String, dynamic>> selectedTalasalitaan =
        widget.talasalitaan[widget.kabanataIndex + 1] ?? [];

    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/Add a heading (5).png', // Background image
            fit:
                BoxFit.cover, // This ensures the image covers the entire screen
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                children: [
                  // Header with back button and book info
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.01),
                    height: size.height * 0.085,
                    width: size.width,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                // Navigate back to the home screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Home(
                                      firstName: widget.firstName,
                                      email: widget.email,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(
                                    constraints.maxHeight * 0.18),
                                height: constraints.maxHeight * 0.8,
                                width: constraints.maxWidth * 0.15,
                                child: const FittedBox(
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 90),
                              child: SizedBox(
                                height: constraints.maxHeight * 0.85,
                                width: constraints.maxWidth * 0.51,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          constraints.maxHeight * 0.85 * 0.6,
                                      width: constraints.maxWidth * 0.54,
                                      child: FittedBox(
                                        child: Center(
                                          child: Text(
                                            widget.bookname,
                                            style: const TextStyle(
                                              fontFamily: 'AnandaBlack',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 45,
                                              color: Colors.orange,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      height:
                                          constraints.maxHeight * 0.85 * 0.3,
                                      width: constraints.maxWidth * 0.38,
                                      child: FittedBox(
                                        child: Text(
                                          "Kabanata ${widget.kabanataIndex + 1}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                            color: Color.fromARGB(
                                                255, 235, 174, 83),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // Combined Buod, AralMensahe, and Talasalitaan inside the same container
                  Container(
                    padding: EdgeInsets.all(size.height * 0.02),
                    width: size.width,
                    child: Column(
                      children: [
                        // Display the Buod
                        Center(
                          child: Text(
                            selectedBuod, // Display the selected buod
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Divider(color: Colors.orange),

                        // Display AralMensahe
                        if (selectedAralMensahe.isEmpty)
                          const Text(
                            "No aral mensahe available for this chapter.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: FlipCard(
                              direction: FlipDirection.HORIZONTAL,
                              front: Card(
                                elevation: 9,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: Colors.white.withOpacity(0.8),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Mensahe', // Title for the front side
                                        style: TextStyle(
                                          fontFamily: 'AnandaBlack',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        selectedAralMensahe[1]['mensahe'] ??
                                            '', // The content of Mensahe
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              back: Card(
                                elevation: 9,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: Colors.white.withOpacity(0.8),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Aral', // Title for the back side
                                        style: TextStyle(
                                          fontFamily: 'AnandaBlack',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        selectedAralMensahe[0]['aral'] ??
                                            '', // The content of Aral
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const Divider(
                            color: Colors
                                .orange), // Space between AralMensahe and Talasalitaan

                        const Text(
                          "Talasalitaan", // Heading for the vocabulary list
                          style: TextStyle(
                            fontFamily: 'AnandaBlack',
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // List of talasalitaan for the selected kabanata
                        if (selectedTalasalitaan.isEmpty)
                          const Text(
                            "No talasalitaan available for this chapter.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          )
                        else
                          ListView.builder(
                            shrinkWrap:
                                true, // To make it scrollable within the screen size
                            physics:
                                const NeverScrollableScrollPhysics(), // Disable scrolling for this list, use the outer scroll view
                            itemCount: selectedTalasalitaan.length,
                            itemBuilder: (context, index) {
                              var word = selectedTalasalitaan[index]['word'];
                              var meaning =
                                  selectedTalasalitaan[index]['meaning'];
                              return Card(
                                elevation: 9,
                                color: Colors.white.withOpacity(0.8),
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  title: Text(
                                    word,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(
                                    meaning,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  // Button for quiz navigation
                  SizedBox(
                    width: hasTakenQuiz ? 350 : 280, // Adjust the width as needed
                    child: ElevatedButton(
                      onPressed: hasTakenQuiz
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizPage(
                                    firstName: widget.firstName,
                                    kabanataIndex: widget.kabanataIndex,
                                    email: widget.email,
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        elevation: 15,
                        shadowColor: Colors.black,
                        backgroundColor: Colors.orange.withOpacity(0.99),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        hasTakenQuiz
                            ? 'You have already taken the quiz'
                            : 'Take Quiz',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
