import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';
import '../../SQFLite/database_helper.dart';
import 'package:email_validator/email_validator.dart';
import '../common_widget/round_dropdown.dart';
import '../database_table/user_details.dart';
import '../home/home.dart';
import '../login/login.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isCheck = false;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  String _userType = 'Student';

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
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
                    "Gumawa ng account",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: media.width * 0.05),
                  RoundDropdownField(
                    hitText: "Select User",
                    icon: "assets/images/user_text.png",
                    items: const ['Student', 'Teacher'],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Punan ang patlang para sa usertype';
                      }
                      return null;
                    },
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    onChanged: (String? newValue) {
                      setState(() {
                        _userType = newValue ?? 'Student';
                      });
                    },
                  ),
                  SizedBox(height: media.width * 0.01),
                  RoundTextField(
                    hitText: "Pangalang Ginagamit",
                    icon: "assets/images/user_text.png",
                    controller: _firstNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Punan ang patlang para sa first name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.width * 0.04),
                  RoundTextField(
                    hitText: "Apelyido",
                    icon: "assets/images/user_text.png",
                    controller: _lastNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Punan ang patlang para sa last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.width * 0.04),
                  RoundTextField(
                    hitText: "Email",
                    icon: "assets/images/email.png",
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Punan ang patlang para sa email';
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'kailangang tama ang pormat ng email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.width * 0.04),
                  RoundTextField(
                    hitText: "Password",
                    icon: "assets/images/lock.png",
                    obscureText: _obscurePassword,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Punan ang patlang para sa password';
                      }
                      return null;
                    },
                    rigtIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: TColor.gray,
                        size: 20,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isCheck = !isCheck;
                          });
                        },
                        icon: Icon(
                          isCheck
                              ? Icons.check_box_outlined
                              : Icons.check_box_outline_blank_outlined,
                          color: TColor.gray,
                          size: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "By continuing you accept our Privacy Policy and\nTerm of Use",
                          style: TextStyle(color: TColor.gray, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: media.width * 0.2),
                  RoundButton(
                    title: "Mag register",
                    type: RoundButtonType.bgGradient,
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && isCheck) {
                        // Create a UserDetails object
                        UserDetails userDetails = UserDetails(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                          userType: _userType,
                        );

                        // Call the database helper to insert user details
                        DatabaseHelper dbHelper = DatabaseHelper();

                        // Check if the email already exists
                        final existingUsers = await dbHelper.fetchUsers();
                        bool emailExists = existingUsers.any(
                            (user) => user['email'] == _emailController.text);

                        if (emailExists) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Email already registered!')),
                          );
                          return;
                        }

                        await dbHelper.insertUserDetails(userDetails);
                        print("User Registered: ");
                        print("First Name: ${userDetails.firstName}");
                        print("Last Name: ${userDetails.lastName}");
                        print("Email: ${userDetails.email}");
                        print("User Type: ${userDetails.userType}");

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home(
                                    firstName: _firstNameController.text, email: _emailController.text,
                                  )),
                        );
                      }
                    },
                  ),
                  SizedBox(height: media.width * 0.04),
                  TextButton(
                    onPressed: () async {
                      DatabaseHelper dbHelper = DatabaseHelper();
                      List<Map<String, dynamic>> users =
                          await dbHelper.fetchUsers();
                          
                      print(users);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Meron ng account? ",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Mag-login",
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.width * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
