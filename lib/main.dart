import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kita_sehat/model/user_model.dart';
import 'package:kita_sehat/screen/splash.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter()); // Daftarkan adapter untuk User
  await Hive.openBox<User>('users');

  // Inisialisasi notifikasi
  AwesomeNotifications().initialize(
    null, // Icon aplikasi
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic notifications',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
  );

  // Permission untuk notifikasi
  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.request();
    if (status.isGranted) {
      print("Notifikasi diizinkan.");
    } else {
      print("Notifikasi tidak diizinkan.");
    }
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Splash());
  }
}
