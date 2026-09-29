import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Wajib dipanggil sebelum pakai plugin native (seperti Firebase)
  WidgetsFlutterBinding.ensureInitialized();

  // Menyalakan koneksi ke Firebase, pakai konfigurasi dari flutterfire configure tadi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      home: const WeightScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Body Target')),
      body: const Center(
        child: Text('Firebase berhasil terhubung! 🎉'),
      ),
    );
  }
}