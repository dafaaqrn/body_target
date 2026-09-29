import 'package:flutter/material.dart';
import 'weight_screen.dart';
import 'exercise_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Menyimpan tab mana yang sedang aktif (0 = tab pertama, 1 = tab kedua, dst)
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan, urutannya harus sama dengan
  // urutan item di BottomNavigationBar di bawah
  final List<Widget> _screens = const [
    _HomePlaceholder(),
    WeightScreen(),
    ExerciseScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack menjaga state tiap halaman, jadi kalau pindah tab
      // lalu balik lagi, datanya tidak reset/reload dari awal
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
            bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_weight),
            label: 'Berat Badan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Olahraga',
          ),
                    BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Pengingat',
          ),
        ],
      ),
    );
  }
}

// Halaman sementara untuk tab Beranda, akan kita isi lebih lengkap nanti
class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Body Target')),
      body: const Center(
        child: Text('Halaman beranda, segera hadir 🚧'),
      ),
    );
  }
}