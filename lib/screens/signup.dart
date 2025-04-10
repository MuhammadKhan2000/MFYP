import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isPassVisible = true,
      isRemembeMe = false,
      isConfirmPassVisible = true,
      isUserNameEmpty = false,
      isConfirmEmpty = false,
      isPassEmpty = false;
  TextEditingController txtUsername = TextEditingController(),
      txtPassword = TextEditingController(),
      txtConfirmPassword = TextEditingController();
  FocusNode userFocus = FocusNode(),
      passwordFocus = FocusNode(),
      confirmPasswordFocus = FocusNode();
  showToast(String message, double size) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: size,
    );
  }

  Future<void> signUp() async {
    String username = txtUsername.text.trim();
    String password = txtPassword.text.trim();
    String confirmPassword = txtConfirmPassword.text.trim();

    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showToast('All fields are required', 16);
      return;
    }

    if (password != confirmPassword) {
      showToast('Passwords do not match', 16);
      return;
    }

    const String apiUrl =
        // 'http://192.168.41.189:5000/api/auth/signup'; // For emulator, use 'http://10.0.2.2:5000/signup'
                                                      // for local , use 'http://127.0.0.1:5000/signup'
        'http://192.168.236.189:5000/api/auth/signup';
    try {
      // Prepare the request body
      Map<String, String> body = {
        'username': username,
        'password': password,
        'ConfirmPassword': confirmPassword,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      // Handle the response based on status code
    if (response.statusCode == 200) {
      showToast('User already exists', 16);
    } else if (response.statusCode == 201) {
      showToast('User created successfully', 16);
      Navigator.pop(context); // Go back to the sign-in page
    } else if (response.statusCode == 400) {
      showToast('Signup failed,Password must be at least 8 characters long and include a number and a special character ', 16);
    } else {
      showToast('Unexpected error occurred', 16);
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
    if (txtConfirmPassword.text.isEmpty) {
      FocusScope.of(context).requestFocus(confirmPasswordFocus);
      setState(() {
        isConfirmEmpty = true;
      });
      showToast('Required: Confirm Password', 16);
      return;
    }
    if (txtConfirmPassword.text != txtPassword.text) {
      // FocusScope.of(context).requestFocus(confirmPasswordFocus);
      // setState(() {
      //   isConfirmEmpty = true;
      // });
      showToast('Password and Confirm Password are not same.', 16);
      return;
    }
    signUp();
  }

  @override
  Widget build(BuildContext context) {
    w(x) => MediaQuery.of(context).size.width * (x / 490);
    h(y) => MediaQuery.of(context).size.height * (y / 890);
    // bool isWideScreen = MediaQuery.of(context).size.width > 890;

    return Scaffold(appBar: AppBar(
        title: Text(
          "Back",
        
          style: GoogleFonts.poppins(
              fontSize: h(19),
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_outlined, color: Colors.white),
        ),
        backgroundColor: Colors.green,
        toolbarHeight: 45,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(w(10)),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: h(40), horizontal: w(20)),
              // width: w(400) : double.infinity,
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(color: Colors.black12, width: .50),
                // gradient: LinearGradient(
                //     colors: [Colors.blue.withOpacity(.5), Colors.white30],
                //     begin: Alignment.topCenter,
                //     end: Alignment.bottomCenter),
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
                  // Logo
                  Image.asset(
                    'assets/images/applogo.png',
                    height: h(150),
                  ),
                  // SizedBox(height: h(20)),

                  // Welcome Text
                  Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: w(22),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  SizedBox(height: h(5)),

                  // Subtitle
                  Text(
                    '* sign indicating mandatory',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        letterSpacing: 1,
                        fontSize: w(10),
                        color: Colors.grey[600]),
                  ),
                  SizedBox(height: h(30)),

                  // Username Field
                  SizedBox(
                    height: h(45),
                    child: TextField(
                      controller: txtUsername,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(passwordFocus);
                      },
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
                        // labelText: 'Username',
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

                  // Password Field
                  SizedBox(
                    height: h(45),
                    child: TextField(
                      controller: txtPassword,
                      focusNode: passwordFocus,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(confirmPasswordFocus);
                      },
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
                        // labelText: 'Username',
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

                  SizedBox(height: h(20)),
                  SizedBox(
                    height: h(45),
                    child: TextField(
                      controller: txtConfirmPassword,
                      focusNode: confirmPasswordFocus,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        validateForm();
                      },
                      cursorWidth: w(2),
                      cursorHeight: h(16),
                      cursorColor: Colors.red,
                      textAlign: TextAlign.left,
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          setState(() {
                            isConfirmEmpty = false;
                          });
                        }
                      },
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontSize: w(16)),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: w(8), bottom: h(9), right: w(10)),
                        // labelText: 'Username',
                        prefixIcon: Icon(
                          Icons.lock,
                          size: w(20),
                          color: isConfirmEmpty ? Colors.red : null,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            !isConfirmPassVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: isConfirmEmpty ? Colors.red : null,
                          ),
                          onPressed: () {
                            setState(() {
                              isConfirmPassVisible = !isConfirmPassVisible;
                            });
                          },
                          iconSize: w(20),
                        ),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        hintStyle: GoogleFonts.poppins(
                            color:
                                !isConfirmEmpty ? Colors.grey[400] : Colors.red,
                            fontSize: w(16)),
                        hintText: 'Confirm Password*',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: isConfirmPassVisible,
                      obscuringCharacter: '*',
                    ),
                  ),
                  SizedBox(height: h(20)),
                  // Login Button
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
                      'Sign Up',
                      style: GoogleFonts.poppins(
                        fontSize: w(16),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
