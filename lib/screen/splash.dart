import 'package:flutter/material.dart';
import 'package:kita_sehat/screen/beranda.dart';
import 'package:kita_sehat/screen/login.dart';
import 'package:kita_sehat/screen/navigator.dart';
import 'package:kita_sehat/screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool? isLogin = false;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    loadSession();
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
        if (isLogin!) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavigatorScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      });
    });
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLogin = prefs.getBool('isLogin');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 2000), // Durasi animasi
            opacity: _opacity,
            curve: Curves.easeInOut, // Kurva animasi
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Splash.png',
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
