// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kita_sehat/model/user_model.dart';
import 'package:kita_sehat/screen/beranda.dart';
import 'package:kita_sehat/screen/navigator.dart';
import 'package:kita_sehat/screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  void login() async {
    final eml = email.text;
    final psw = password.text;

    // Inputfield kosong
    if (eml.isEmpty || psw.isEmpty) {
      return;
    }

    final box = await Hive.openBox<User>('users');
    final user = box.get(eml);

    if (user != null && user.password == psw) {
      // Login berhasil
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Login Success'),
        backgroundColor: hijau_level_three,
      ));

      // Menyimpan info login dengan sharedpreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogin', true);
      await prefs.setString('username', user.username);
      await prefs.setString('email', user.email);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const NavigatorScreen()));
    } else {
      // Login gagal
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Invalid credentials'),
          backgroundColor: hijau_level_three));
    }
  }

  // Library Warna
  Color hijau_level_one = const Color(0XFF1E5631);
  Color hijau_level_three = const Color(0XFF76BA1B);
  Color putih = const Color(0XFFFEFEFE);
  Color hitam = const Color(0XFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Kita',
                    style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: hijau_level_one),
                  ),
                  Text(
                    'Sehat',
                    style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: hijau_level_three),
                  )
                ],
              ),
            ),
            Text(
              'Semua bisa sehat mulai sekarang',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 15, color: hitam),
            ),
            const SizedBox(height: 32),
            // Form Fields for Registration
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  // Email Field
                  SizedBox(
                    width: 360,
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: "Email",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pastikan bagian ini terisi ya!';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Password Field
                  SizedBox(
                    width: 360,
                    child: TextFormField(
                      controller: password,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: "Masukan Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pastikan bagian ini terisi ya!';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Login Button
                  SizedBox(
                    width: 360,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(hijau_level_one),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      onPressed: login,
                      child: Text(
                        "Masuk",
                        style: GoogleFonts.poppins(fontSize: 16, color: putih),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun? ',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()));
                        },
                        child: const Text(
                          'Register disini.',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Color(0xffFF9D00)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
