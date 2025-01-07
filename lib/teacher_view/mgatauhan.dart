import 'package:florante/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login.dart';
import 'game_list.dart';
import 'teacher_home.dart';

class TeacherTauhan extends StatefulWidget {

  const TeacherTauhan({super.key});

  @override
  State<TeacherTauhan> createState() => _TeacherTauhanState();
}

class _TeacherTauhanState extends State<TeacherTauhan> {
  int selectedIndex = 2; // Index for the bottom navigation
  int carouselIndex = 0; // New index for the carousel
  final PageController _pageController =
      PageController(viewportFraction: 0.7, initialPage: 0);

  // List of character images and their descriptions
  final List<Map<String, String>> characters = [
    {
      'image': 'assets/images/FloranteCharacter-removebg-preview-Photoroom.png',
      'name': 'Florante',
      'description':
          'Makisig na binatang anak ni Duke Briseo at Prinsesa Floresca. Siya ang pangunahing tauhan ng awit. Halal na Heneral ng hukbo ng Albanya. Magiting na bayani, mandirigma at heneral ng hukbong magtatanggol sa pagsalakay ng mga Persiyano at Turko.'
    },
    {
      'image': 'assets/images/Laura-removebg-preview.png',
      'name': 'Laura',
      'description':
          'Anak ni Haring Linceo at ang natatanging pag-ibig ni Florante. Tapat ang puso sa pag-ibig ngunit aägawin ng buhong na si Adolfo.'
    },
    {
      'image': 'assets/images/Count_Adolfo-removebg-preview.png',
      'name': 'Adolfo',
      'description':
          'Anak ng magiting na si Konde Sileno ng Albanya. Kabaligtaran ng kanyang ama, si Adolfo ay isang taksil at lihim na may inggit kay Florante mula nang magkasama sila sa Atenas. Siya ang mahigpit na karibal ni Florante sa pag-aaral at popularidad sa Atenas. Ang malaking balakid sa pag-iibigan nina Florante at Laura, at aagaw sa trono ni Haring Linceo ng Albanya.'
    },
    {
      'image': 'assets/images/Aladin-removebg-preview.png',
      'name': 'Aladin',
      'description':
          'Isang gererong Moro at prinsipe ng Persiya. Anak ni Sultan Ali-adab. Mahigpit na kaaway ng bayan at relihiyon ni Florante, ngunit magiging tagapagligtas ni Florante.'
    },
    {
      'image': 'assets/images/Flerida-removebg-preview.png',
      'name': 'Flerida',
      'description':
          'isang matapang na babaeng Moro na tatakas sa Persiya para hanapin sa kagubatan ang kasintahang si Aladin. Siya ay magiging tagapagligtas ni Laura mula kay Adolfo.'
    },
    {
      'image': 'assets/images/Menandro-removebg-preview.png',
      'name': 'Menandro',
      'description':
          'ang matapat na kaibigan ni Florante. Mabait at laging kasa- kasama ni Florante sa digmaan'
    },
    {
      'image': 'assets/images/Duke_Briseo-removebg-preview.png',
      'name': 'Duke Briseo',
      'description':
          'ang mabait na ama ni Florante. Taga-payo ni Haring Linceo ng Albanya.'
    },
    {
      'image': 'assets/images/Princess_Floresca-removebg-preview.png',
      'name': 'Prinsesa Floresca',
      'description': 'ang mahal na ina ni Florante.'
    },
    {
      'image': 'assets/images/King_Linceo-removebg-preview.png',
      'name': 'Haring Linceo',
      'description': 'hari ng Albanya at arma ni Prinsesa Laura.'
    },
    {
      'image': 'assets/images/Antenor-removebg-preview.png',
      'name': 'Antenor',
      'description':
          'ang mabait na guro sa Atenas. Guro nina Florante, Menandro at Adolfo. Amain ni Menandro.'
    },
    {
      'image': 'assets/images/General_Miramolin-removebg-preview.png',
      'name': 'Heneral Miramolin',
      'description': ' Heneral ng mga Turko na lumusob sa Albanya.'
    },
    {
      'image': 'assets/images/General_Osmalik-removebg-preview.png',
      'name': 'Heneral Osmalik',
      'description':
          'ang Heneral ng Persya na lumusob sa Krotona. Siya ay napatay ni Florante.'
    },
    {
      'image': 'assets/images/Sultan_Ali-Adab-removebg-preview.png',
      'name': 'Sultan Ali Adab',
      'description':
          'Ang ama ni Aladin na umagaw sa kanyang magandang kasintahang si Flerida.'
    },
    {
      'image': 'assets/images/King_of_Crotona-removebg-preview.png',
      'name': 'Hari ng Krotona',
      'description': 'Ama ni Prinsesa Floresca at lolo ni Florante.'
    },
  ];

  @override
  void initState() {
    super.initState();
    // Add a listener to the PageController to update the carouselIndex when the page changes
    _pageController.addListener(() {
      if (_pageController.page?.toInt() != carouselIndex) {
        setState(() {
          carouselIndex = _pageController.page?.toInt() ?? 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/bg4th.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: PageView.builder(
              controller: _pageController,
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final slide = characters[index];
                return Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: media.width * 0.02),
                    child: FlipCard(
                      direction: FlipDirection.HORIZONTAL, // Flip horizontally
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
                            slide["image"]!,
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
                            padding: EdgeInsets.all(media.width * 0.05),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  slide["name"]!,
                                  style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Container(
                                  width: media.width * 0.3,
                                  height: 1,
                                  color: TColor.white,
                                ),
                                SizedBox(height: media.width * 0.03),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    slide["description"]!,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              onPageChanged: (index) {
                // Update the carouselIndex when page changes
                setState(() {
                  carouselIndex = index;
                });
              },
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
        currentIndex: selectedIndex, // Keep this for navigation
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });

          if (index == 1) {
            // Navigate to the Tauhan page when "Mga Tauhan" is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TeacherHome()),
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
