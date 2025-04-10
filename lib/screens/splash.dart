import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cargowings/screens/signIn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeIn),
    );

    _controller!.forward();
    Timer(const Duration(milliseconds: 5000), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => const SignIn()));
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    w(x) => MediaQuery.of(context).size.width * (x / 490);
    h(y) => MediaQuery.of(context).size.height * (y / 890);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation!,
              child: SizedBox(
                width: w(150),
                height: h(150),
                child: Image.asset('assets/images/applogo.png'),
              ),
            ),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Welcome to Cargo Wings',
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: w(16),
                    fontStyle: FontStyle.italic,
                  ),
                  cursor: '',
                  curve: Curves.decelerate,
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: 1,
            ),
          ],
        ),
      ),
    );
  }
}
