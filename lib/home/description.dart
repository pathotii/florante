import 'package:florante/home/home.dart';
import 'package:flutter/material.dart';
import 'quiz.dart';

class Description extends StatefulWidget {
  final String firstName;
  final String bookname;
  final List<Map<String, dynamic>> questions;
  final int kabanataIndex;

  const Description({
    super.key,
    required this.firstName,
    required this.bookname,
    required this.questions,
    required this.kabanataIndex,
  });

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  int _textFormatIndex = 0;
  final List<TextAlign> _textAlignments = [TextAlign.justify, TextAlign.left];

  @override
  Widget build(BuildContext context) {
    String text =
        """Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras fermentum lectus lacus, in cursus sem volutpat non. Sed nisi ex, vestibulum quis lobortis et, scelerisque hendrerit velit. Maecenas convallis volutpat quam a luctus. Morbi metus massa, cursus in arcu et, dapibus iaculis odio. Quisque suscipit, erat ac ornare iaculis, nibh sapien semper dui, imperdiet cursus turpis libero ut justo. Duis in tincidunt neque, eu iaculis nulla. In lorem dolor, porttitor hendrerit dui feugiat, convallis tincidunt lectus. Nullam auctor, lorem ut consectetur dictum, quam mauris eleifend arcu, eu fermentum urna neque sit amet ante. Maecenas libero felis, consectetur at metus eu, vestibulum sollicitudin erat. Nullam euismod sapien eu dui mollis, vel imperdiet urna commodo. Maecenas semper elementum magna, eu commodo quam finibus non. Mauris condimentum nisl leo, quis dignissim augue gravida et. Pellentesque tincidunt vitae erat nec interdum. Praesent a dui sagittis, luctus metus nec, accumsan eros. Sed quis scelerisque velit, ut ultrices tellus. Praesent dignissim lacus a lectus suscipit sagittis. Aliquam luctus nibh at consectetur rutrum. Proin congue mauris elementum varius placerat. Pellentesque vulputate ante eu nunc placerat, eu egestas elit ornare. Nullam ac ipsum ultrices ante venenatis faucibus vehicula quis risus. Vestibulum ut turpis quis sapien dictum mattis eget iaculis nisl. In porttitor felis eu metus eleifend pulvinar. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus tristique nulla sed felis sollicitudin consequat.\n
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras fermentum lectus lacus, in cursus sem volutpat non. Sed nisi ex, vestibulum quis lobortis et, scelerisque hendrerit velit. Maecenas convallis volutpat quam a luctus. Morbi metus massa, cursus in arcu et, dapibus iaculis odio. Quisque suscipit, erat ac ornare iaculis, nibh sapien semper dui, imperdiet cursus turpis libero ut justo. Duis in tincidunt neque, eu iaculis nulla. In lorem dolor, porttitor hendrerit dui feugiat, convallis tincidunt lectus. Nullam auctor, lorem ut consectetur dictum, quam mauris eleifend arcu, eu fermentum urna neque sit amet ante. Maecenas libero felis, consectetur at metus eu, vestibulum sollicitudin erat. Nullam euismod sapien eu dui mollis, vel imperdiet urna commodo. Maecenas semper elementum magna, eu commodo quam finibus non. Mauris condimentum nisl leo, quis dignissim augue gravida et. Pellentesque tincidunt vitae erat nec interdum. Praesent a dui sagittis, luctus metus nec, accumsan eros. Sed quis scelerisque velit, ut ultrices tellus. Praesent dignissim lacus a lectus suscipit sagittis. Aliquam luctus nibh at consectetur rutrum. Proin congue mauris elementum varius placerat. Pellentesque vulputate ante eu nunc placerat, eu egestas elit ornare. Nullam ac ipsum ultrices ante venenatis faucibus vehicula quis risus. Vestibulum ut turpis quis sapien dictum mattis eget iaculis nisl. In porttitor felis eu metus eleifend pulvinar. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus tristique nulla sed felis sollicitudin consequat.""";
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Added to make the whole content scrollable
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
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
                                  builder: (context) => Home(firstName: widget.firstName,), // Replace with your home screen widget
                                ),
                              );
                            },
                            child: Container(
                              padding:
                                  EdgeInsets.all(constraints.maxHeight * 0.18),
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
                                    height: constraints.maxHeight * 0.85 * 0.7,
                                    width: constraints.maxWidth * 0.35,
                                    child: FittedBox(
                                      child: Text(
                                        widget.bookname,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.85 * 0.3,
                                    width: constraints.maxWidth * 0.35,
                                    child: FittedBox(
                                      child: Text(
                                        "Kabanata ${widget.kabanataIndex + 1}", // Display chapter number
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color:
                                              Color.fromARGB(255, 235, 174, 83),
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
                Container(
                  padding: EdgeInsets.all(size.height * 0.02),
                  height: size.height * 0.81,
                  width: size.width,
                  child: SingleChildScrollView(
                    child: Center(
                      child: Text(
                        text,
                        textAlign: _textAlignments[
                            _textFormatIndex % _textAlignments.length],
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to QuizPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuizPage(
                                bookname: widget.bookname,
                                questions: widget.questions,
                                kabanataIndex: widget.kabanataIndex,
                                firstName: widget.firstName,
                              )), // Redirect to quiz.dart
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
                  child: const Text(
                    "Take Quiz",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
