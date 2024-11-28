import 'package:flutter/material.dart';
import 'package:kita_sehat/screen/register.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        _opacity = 1.0; //fade-in
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.0; // fade-out
      });
      Future.delayed(const Duration(milliseconds: 3000), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Register()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 2000), // Durasi animasi
          opacity: _opacity,
          curve: Curves.easeInOut, // Kurva animasi
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/splash.png',
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
