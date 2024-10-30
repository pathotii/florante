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
  bool keepMeLoggedIn = false; // For the "Keep me logged in" checkbox

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check if the user is already logged in
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
                      "Kumusta,",
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
                      const Text("Keep me logged in"),
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
                        final email = _emailController.text;
                        final password = _passwordController.text;

                        // Your login validation logic
                        final userType = await _validateLogin(email, password);
                        if (userType != null) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          // Save the login status and user token
                          await prefs.setBool('isLoggedIn', true);
                          await prefs.setString(
                              'userToken', 'some_unique_token');

                          // Save 'keep me logged in' state if checked
                          if (keepMeLoggedIn) {
                            await prefs.setBool('keepMeLoggedIn', true);
                          }

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return userType == 'Student'
                                    ? const Home(firstName: 'Patrick',)
                                    : const Home(firstName: 'Patrick',);
                              },
                            ),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          // Show error message if login is invalid
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
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool keepMeLoggedIn = prefs.getBool('keepMeLoggedIn') ?? false;

    if (isLoggedIn && keepMeLoggedIn) {
      // Automatically log in if 'Keep me logged in' was selected
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home(firstName: '',)),
      );
    }
  }

  Future<String?> _validateLogin(String email, String password) async {
    final dbHelper = DatabaseHelper();
    List<UserDetails> userList = await dbHelper.users();

    for (var user in userList) {
      if (user.email == email && user.password == password) {
        return user.userType;
      }
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
