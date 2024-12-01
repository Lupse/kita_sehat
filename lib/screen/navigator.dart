import 'package:flutter/material.dart';
import 'package:kita_sehat/screen/beranda.dart';
import 'package:kita_sehat/screen/profile.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const HomePage(),
    const ProfileScreen(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBottomNavTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Library Warna
  Color hijauLevelOne = const Color(0XFF1E5631);
  Color hijauLevelThree = const Color(0XFF76BA1B);
  Color putih = const Color(0XFFFEFEFE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged, // Update indeks saat halaman berubah
        children: _pages, // Halaman-halaman yang akan ditampilkan
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: hijauLevelThree,
        currentIndex: _currentIndex, // Menandakan halaman yang aktif
        onTap: _onBottomNavTapped, // Fungsi saat item bottom nav dipilih
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
