// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:kita_sehat/model/user_model.dart';
import 'package:kita_sehat/screen/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController re_password = TextEditingController();
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  void register() async {
    final eml = email.text;
    final usn = username.text;
    final psw = password.text;
    final cnfpsw = re_password.text;

    // Blank Textfield
    if (eml.isEmpty || usn.isEmpty || psw.isEmpty) {
      return;
    }

    // Password & confirm password doesnt match
    if (psw != cnfpsw) {
      return;
    }

    final user = User(email: eml, username: usn, password: psw);
    final box = await Hive.openBox<User>('users');

    // Simpan data pengguna
    box.put(eml, user);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
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
                  // Username Field
                  SizedBox(
                    width: 360,
                    child: TextFormField(
                      controller: username,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: "Username",
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
                  const SizedBox(height: 15),
                  // Re-enter Password Field
                  SizedBox(
                    width: 360,
                    child: TextFormField(
                      controller: re_password,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: "Masukan Kembali Password",
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
                  // Register Button
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
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          register();
                        } else {
                          // Jika form tidak valid, tampilkan pesan error
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Invalid credentials')));
                        }
                      },
                      child: Text(
                        "Daftar",
                        style: GoogleFonts.poppins(fontSize: 16, color: putih),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sudah punya akun? ',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text(
                    'Masuk disini.',
                    style: TextStyle(
                        fontFamily: 'Poppins', color: Color(0xffFF9D00)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
