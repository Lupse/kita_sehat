import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kita_sehat/screen/beranda.dart';
import 'package:kita_sehat/screen/login.dart';
import 'package:kita_sehat/screen/register.dart';
import 'package:kita_sehat/screen/splash.dart';

void main() async {
  await Hive.initFlutter();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
