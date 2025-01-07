// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login/login.dart';
import 'game_list.dart';
import 'mgatauhan.dart';
import 'studentdetails.dart';

class TeacherHome extends StatefulWidget {
  const TeacherHome({super.key});

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  int selectedIndex = 1;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/newbg.png',
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 150),
                // Search field
                TextField(
                  controller: searchController,
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Hanapin ang pangalan',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    fillColor: Colors.white.withOpacity(0.8),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>( 
                    stream: FirebaseFirestore.instance
                        .collection('quizResults')
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
                          child: Text('No students found'),
                        );
                      }

                      final results = snapshot.data!.docs;

                      // Use a set to store unique student names
                      final Map<String, Map<String, String>> studentsMap = {};

                      for (var doc in results) {
                        var studentName = doc.data()['name'];
                        var score = doc.data()['score'];
                        var kabanataAnswered = doc.data()['kabanataAnswered'];

                        // Ensure all fields are the correct type
                        if (studentName is String) {
                          String scoreText = '';
                          if (score is String) {
                            scoreText = score;
                          } else if (score is int) {
                            scoreText = score.toString();
                          } else {
                            scoreText = '0'; // Default value
                          }

                          // Update the student's information in the map
                          studentsMap[studentName] = {
                            'name': studentName,
                            'score': scoreText,
                            'kabanataAnswered': kabanataAnswered.toString(),
                          };
                        }
                      }

                      // Convert the map to a list and filter based on the search query
                      final students = studentsMap.values.toList();
                      final filteredStudents = students.where((student) {
                        final studentName = student['name'].toString().toLowerCase();
                        return studentName.contains(searchQuery.toLowerCase());
                      }).toList();

                      // Sort the students list alphabetically by student name
                      filteredStudents.sort((a, b) {
                        return (a['name'] as String).compareTo(b['name'] as String);
                      });

                      return ListView.builder(
                        itemCount: filteredStudents.length,
                        itemBuilder: (context, index) {
                          final student = filteredStudents[index];
                          final studentName = student['name'] ?? 'Unknown';
                          final score = student['score'] ?? '0';
                          final kabanataAnswered = student['kabanataAnswered'] ?? '0';

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)
                            ),
                            elevation: 5,
                            shadowColor: Colors.black,
                            margin: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: ListTile(
                              
                              leading: CircleAvatar(
                                backgroundColor: Colors.orange,
                                child: Text(
                                  studentName[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                studentName,
                                style: const TextStyle(fontSize: 18),
                              ),
                              onTap: () {
                                // Navigate to the details page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentDetailsPage(
                                        studentName: studentName),
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
              ],
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
                  builder: (context) => const TeacherTauhan()),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TeacherGameList()),
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
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('email');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have logged out successfully'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginView(),
      ),
    );
  }
}
