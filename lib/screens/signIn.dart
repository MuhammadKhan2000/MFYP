import 'package:cargowings/screens/home.dart';
import 'package:cargowings/screens/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isPassVisible = true,
      isRemembeMe = false,
      isUserNameEmpty = false,
      isPassEmpty = false;
  TextEditingController txtUsername = TextEditingController(),
      txtPassword = TextEditingController();
  FocusNode userFocus = FocusNode(), passwordFocus = FocusNode();
  showToast(String message, double size) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity:
          ToastGravity.BOTTOM, // You can set this to TOP, BOTTOM, or CENTER
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: size,
    );
  }

  Future<void> signIn() async {
    String username = txtUsername.text.trim();
    String password = txtPassword.text.trim();

    // Check if the fields are empty
    if (username.isEmpty || password.isEmpty) {
      showToast('Username and Password are required', 16);
      return;
    }

    // const String apiUrl = 'http://192.168.41.189:5000/api/auth/login'; // Adjust this if needed
    const String apiUrl = 'http://192.168.236.189:5000/api/auth/login'; // Adjust this if needed
    try {
      // Prepare the request body
      Map<String, String> body = {
        'username': username,
        'password': password,
      };

      // Send a POST request to the API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      // Check the response status
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['message'] == 'Login successful') {
          showToast('Login Successful', 16);
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => Home()));
          print("User ID: ${responseData['user_id']}");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (ctx) => Home()));
          // You can navigate to the next page here if needed
        } else {
          showToast('Invalid credentials', 16);
        }
      } else {
        showToast('Login failed. Please try again.', 16);
      }
    } catch (error) {
      print('Error: $error');
      showToast('Error connecting to the server', 16);
    }
  }

  validateForm() {
    if (txtUsername.text.isEmpty) {
      FocusScope.of(context).requestFocus(userFocus);
      setState(() {
        isUserNameEmpty = true;
      });
      showToast('Required: Username', 16);
      return;
    }
    if (txtPassword.text.isEmpty) {
      FocusScope.of(context).requestFocus(passwordFocus);
      setState(() {
        isPassEmpty = true;
      });
      showToast('Required: Password', 16);
      return;
    }
    signIn();
  }

  @override
  Widget build(BuildContext context) {
    w(x) => MediaQuery.of(context).size.width * (x / 490);
    h(y) => MediaQuery.of(context).size.height * (y / 890);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(w(10)),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: h(40), horizontal: w(20)),
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(color: Colors.black12, width: .50),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    blurStyle: BlurStyle.normal,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/applogo.png',
                    height: h(150),
                  ),
                  Text(
                    'Sign In',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: w(22),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  SizedBox(height: h(5)),
                  Text(
                    'Please sign in to continue',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        letterSpacing: 1,
                        fontSize: w(10),
                        color: Colors.grey[600]),
                  ),
                  SizedBox(height: h(30)),
                  SizedBox(
                    height: h(45),
                    child: TextField(
                      controller: txtUsername,
                      textInputAction: TextInputAction.next,
                      cursorWidth: w(2),
                      focusNode: userFocus,
                      cursorHeight: h(16),
                      cursorColor: Colors.red,
                      textAlign: TextAlign.left,
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          setState(() {
                            isUserNameEmpty = false;
                          });
                        }
                      },
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontSize: w(16)),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: w(8), bottom: h(9), right: w(10)),
                        prefixIcon: Icon(
                          Icons.person,
                          size: w(20),
                          color: isUserNameEmpty ? Colors.red : null,
                        ),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        hintStyle: GoogleFonts.poppins(
                            color: !isUserNameEmpty
                                ? Colors.grey[400]
                                : Colors.red,
                            fontSize: w(16)),
                        hintText: 'Username*',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: h(20)),
                  SizedBox(
                    height: h(45),
                    child: TextField(
                      controller: txtPassword,
                      focusNode: passwordFocus,
                      textInputAction: TextInputAction.next,
                      cursorWidth: w(2),
                      cursorHeight: h(16),
                      cursorColor: Colors.red,
                      textAlign: TextAlign.left,
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          setState(() {
                            isPassEmpty = false;
                          });
                        }
                      },
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontSize: w(16)),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: w(8), bottom: h(9), right: w(10)),
                        prefixIcon: Icon(
                          Icons.lock,
                          size: w(20),
                          color: isPassEmpty ? Colors.red : null,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            !isPassVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: isPassEmpty ? Colors.red : null,
                          ),
                          onPressed: () {
                            setState(() {
                              isPassVisible = !isPassVisible;
                            });
                          },
                          iconSize: w(20),
                        ),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        hintStyle: GoogleFonts.poppins(
                            color: !isPassEmpty ? Colors.grey[400] : Colors.red,
                            fontSize: w(16)),
                        hintText: 'Password*',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: isPassVisible,
                      obscuringCharacter: '*',
                    ),
                  ),
                  SizedBox(height: h(10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Row(
                      //   children: [
                      //     Checkbox(
                      //       value: isRemembeMe,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           isRemembeMe = value!;
                      //         });
                      //       },
                      //       checkColor: Colors.white,
                      //       visualDensity: VisualDensity.compact,
                      //       side: BorderSide(width: w(1)),
                      //     ),
                      //     Text(
                      //       'Remember me',
                      //       style: GoogleFonts.poppins(
                      //           fontSize: w(8), color: Colors.black),
                      //     ),
                      //   ],
                      // ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (ctx) => SignUp()));
                          // showToast('Sorry, Under Development', w(16));
                        },
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.poppins(
                              fontSize: w(8),
                              color: Colors.green,
                              letterSpacing: 0.50,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h(20)),
                  ElevatedButton(
                    onPressed: () {
                      validateForm();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: h(15)),
                      backgroundColor: Colors.green[400],
                      shadowColor: Colors.green,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.poppins(
                        fontSize: w(16),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: h(20)),
                  Row(
                    children: [
                      Expanded(
                          child:
                              Divider(thickness: 1, color: Colors.green[100])),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w(8)),
                        child: Text(
                          'or',
                          style: GoogleFonts.poppins(
                              fontSize: w(14), color: Colors.grey[600]),
                        ),
                      ),
                      Expanded(
                          child:
                              Divider(thickness: 1, color: Colors.green[100])),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Don’t have an account? ',
                        style: GoogleFonts.poppins(
                            letterSpacing: 0.20,
                            fontSize: w(16),
                            color: Colors.grey[400]),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: GoogleFonts.poppins(
                                fontSize: w(16),
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => const SignUp()));
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
