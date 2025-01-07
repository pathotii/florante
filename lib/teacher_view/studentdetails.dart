// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Make sure intl is imported

class StudentDetailsPage extends StatelessWidget {
  final String studentName;

  const StudentDetailsPage({super.key, required this.studentName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/Add a heading (5).png', // Background image
            fit: BoxFit.cover, // This ensures the image covers the entire screen
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 15),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.orange),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        // Kabanata list
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>( 
            stream: FirebaseFirestore.instance
                .collection('quizResults')
                .where('name', isEqualTo: studentName) // Handle case sensitivity
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Error fetching data'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No kabanata taken'),
                );
              }

              final results = snapshot.data!.docs;

              // Sort the results based on kabanataAnswered (numerically)
              results.sort((a, b) {
                final kabanataA = a['kabanataAnswered'] ?? 0;
                final kabanataB = b['kabanataAnswered'] ?? 0;
                return (kabanataA as int).compareTo(kabanataB as int);
              });

              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final data = results[index].data();
                  final kabanata = data['kabanataAnswered'] ?? 0;
                  final quizTaken = data['quizTaken'] ?? 'Not Taken';
                  final email = data['email'] ?? 'No Email';
                  final score = data['score'] ?? 'No Score';
                  final dateTaken = data['dateTaken'] ?? 'No Date';

                  // Ensure proper date format if valid
                  String formattedDate = dateTaken;
                  try {
                    if (dateTaken is String) {
                      final parsedDate = DateTime.tryParse(dateTaken);
                      if (parsedDate != null) {
                        // Convert to Philippine Time (UTC+8)
                        final philippinesTime = parsedDate.toUtc().add(Duration(hours: 8));

                        // Format the date to the desired format
                        formattedDate = DateFormat('MMM dd, yyyy - hh:mm a').format(philippinesTime);
                      }
                    }
                  } catch (e) {
                    formattedDate = 'Invalid Date';
                  }

                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: ListTile(
                      title: Text("Kabanata $kabanata"),
                      trailing: Text(
                        quizTaken,
                        style: TextStyle(
                          color: quizTaken == 'Taken'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        // Show dialog with details
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Kabanata $kabanata'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text('Score:\n$score', style: TextStyle(
                                  fontSize: 18,
                                ),), 
                                Text('\nDate:\n$formattedDate', style: TextStyle(
                                  fontSize: 18,
                                ),), // Use formatted date here
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}
