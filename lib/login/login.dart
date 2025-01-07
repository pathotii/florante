import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';
import '../../SQFLite/database_helper.dart';
import '../database_table/user_details.dart';
import '../home/home.dart';
import '../signin/signin.dart';
import '../teacher_view/teacher_home.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool keepMeLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: media.height * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: media.width * 0.07),
                    child: Text(
                      "Kumusta?",
                      style: TextStyle(color: TColor.gray, fontSize: 16),
                    ),
                  ),
                  Text(
                    "Maligayang Pagbabalik!",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  RoundTextField(
                    hitText: "Email",
                    icon: "assets/images/email.png",
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Punan ang patlang para sa email';
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'kailangang tama ang pormat ng email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                  RoundTextField(
                    hitText: "Password",
                    icon: "assets/images/lock.png",
                    obscureText: !isPasswordVisible,
                    rigtIcon: TextButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 20,
                        height: 20,
                        child: Image.asset(
                          isPasswordVisible
                              ? "assets/images/hide_password.png"
                              : "assets/images/show_password.png",
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          color: TColor.gray,
                        ),
                      ),
                    ),
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Punan ang patlang para sa password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Checkbox(
                        value: keepMeLoggedIn,
                        onChanged: (value) {
                          setState(() {
                            keepMeLoggedIn = value!;
                          });
                        },
                      ),
                      const Text("Panatilihing naka-login ang User"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: media.width * 0.04),
                        child: Text(
                          "Nakalimutan ang password?",
                          style: TextStyle(
                              color: TColor.gray,
                              fontSize: 12,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  RoundButton(
                    title: "Mag login",
                    type: RoundButtonType.bgGradient,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        print("Form validated, attempting login...");
                        final email = _emailController.text;
                        final password = _passwordController.text;

                        // Validate login and get the user type
                        final userType = await _validateLogin(email, password);

                        if (userType != null) {
                          print("Login successful, userType: $userType");

                          // Proceed with login: Store the email and isLoggedIn status in SharedPreferences
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          // Save email to check login status later
                          await prefs.setString('email', email);

                          // Save isLoggedIn flag based on whether 'Keep me logged in' is checked
                          await prefs.setBool('isLoggedIn', keepMeLoggedIn);

                          // Fetch the firstName from the database
                          DatabaseHelper dbHelper = DatabaseHelper();
                          UserDetails? userDetails =
                              await dbHelper.getUserByEmail(email);

                          if (userDetails != null) {
                            // Navigate to the correct home page with the firstName
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Home(firstName: userDetails.firstName, email: userDetails.email,),
                              ),
                              (Route<dynamic> route) =>
                                  false, // Clear navigation stack
                            );
                          } else {
                            print('User not found in the database');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Kumusta Po? Guro')),
                            );
                          }
                        } else {
                          print("Login failed, invalid credentials");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Invalid email or password')),
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SignUpView(), // Replace with your actual sign-in view
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Wala pang account?",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          " Mag register",
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the stored email and login status from SharedPreferences
    String email = prefs.getString('email') ??
        ''; // If email is not set, it defaults to an empty string
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Only proceed if both isLoggedIn and email exist
    if (isLoggedIn && email.isNotEmpty) {
      // Check if the email belongs to the teacher (teacher has no account in the database)
      if (email == 'florante_educ2024@gmail.com') {
        // Show a Snackbar indicating navigating to the Teacher side
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Navigating to the Teacher side...'),
            backgroundColor: Colors.green,
          ),
        );

        // Delay the navigation by 2 seconds
        await Future.delayed(const Duration(seconds: 2));

        // Navigate to TeacherHome
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const TeacherHome(),
          ),
        );
      } else {
        // Fetch the user details from the database for a regular user (Student)
        DatabaseHelper dbHelper = DatabaseHelper();
        UserDetails? userDetails = await dbHelper.getUserByEmail(email);

        if (userDetails != null) {
          // Show a Snackbar indicating navigating to the Student side
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Navigating to the Student side...'),
              backgroundColor: Colors.blue,
            ),
          );

          // Delay the navigation by 2 seconds
          await Future.delayed(const Duration(seconds: 2));

          // Navigate to Home for the student with the first name
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(firstName: userDetails.firstName, email: userDetails.email,),
            ),
          );
        } else {
          // Show a Snackbar if the user is not found in the database
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User not found in the database'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // If no email or isLoggedIn is false, prompt for login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please keep your account "Logged In" first'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _validateLogin(String email, String password) async {
    // Pre-saved teacher credentials
    const String teacherEmail = 'florante_educ2024@gmail.com';
    const String teacherPassword = 'florante2024';

    // Check if the entered email and password match the teacher's credentials
    if (email == teacherEmail && password == teacherPassword) {
      // If credentials match, navigate to TeacherHome
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TeacherHome()),
      );
      return 'Teacher';
    }

    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> result = await db.query(
      'user_details',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return result.first['user_type'];
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
