import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/main_screen.dart';
import 'services/notification_service.dart';

void main() async {
  // Wajib dipanggil sebelum pakai plugin native (seperti Firebase)
  WidgetsFlutterBinding.ensureInitialized();

  // Menyalakan koneksi ke Firebase, pakai konfigurasi dari flutterfire configure tadi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Body Target',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}