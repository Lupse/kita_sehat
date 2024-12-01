// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:kita_sehat/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Session Var
  String? username;
  String? email;

  // Daftar zona waktu yang tersedia
  final List<String> timezones = ['WIB', 'WITA', 'WIT', 'London'];

  // Zona waktu default yang dipilih
  String selectedTimezone = 'WIB';

  // Fungsi untuk menyimpan zona waktu yang dipilih ke SharedPreferences
  Future<void> _saveSelectedTimezone(String timezone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedTimezone', timezone);
  }

  // Fungsi untuk memuat zona waktu yang dipilih dari SharedPreferences
  Future<void> _loadSelectedTimezone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTimezone = prefs.getString('selectedTimezone');
    if (savedTimezone != null) {
      setState(() {
        selectedTimezone = savedTimezone;
      });
    }
  }

  // Nilai tukar statis dari IDR ke mata uang lain
  Map<String, double> exchangeRates = {
    'IDR': 1.0, // 1 IDR = 1 IDR
    'USD': 0.000064, // 1 IDR = 0.000064 USD
    'EUR': 0.000060, // 1 IDR = 0.000060 EUR
    'JPY': 0.0071, // 1 IDR = 0.0071 JPY
    'GBP': 0.000051, // 1 IDR = 0.000051 GBP
  };

  // Controller untuk input jumlah uang
  final TextEditingController _amountController = TextEditingController();
  final String _fromCurrency = 'IDR';
  String _toCurrency = 'USD';
  double _convertedAmount = 0.0;

  // Fungsi untuk mengonversi mata uang
  void _convertCurrency() {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    double result =
        amount * exchangeRates[_toCurrency]! / exchangeRates[_fromCurrency]!;
    setState(() {
      _convertedAmount = result;
    });
  }

  // Fungsi untuk menyimpan mata uang tujuan yang dipilih ke SharedPreferences
  Future<void> _saveSelectedCurrency(String currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedCurrency', currency);
  }

  // Fungsi untuk memuat mata uang tujuan yang dipilih dari SharedPreferences
  Future<void> _loadSelectedCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCurrency = prefs.getString('selectedCurrency');
    if (savedCurrency != null) {
      setState(() {
        _toCurrency = savedCurrency;
      });
    }
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      email = prefs.getString('email');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSelectedCurrency(); // Memuat mata uang yang tersimpan saat halaman dibuka
    _loadSelectedTimezone();
    _loadSession();
  }

  // Library Warna
  Color hijau_level_one = const Color(0XFF1E5631);
  Color hijau_level_three = const Color(0XFF76BA1B);
  Color putih = const Color(0XFFFEFEFE);
  Color hitam = const Color(0XFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 97.0, left: 32, right: 42),
      child: Column(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.jpeg'),
            radius: 50,
          ),
          Text(
            username!,
            style: TextStyle(
                fontSize: 30,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: hijau_level_one),
          ),
          Text(
            email!,
            style: TextStyle(
                fontSize: 15, fontFamily: 'Poppins', color: hijau_level_one),
          ),
          const SizedBox(
            height: 52,
          ),
          Text(
            'Kritik dan Saran :',
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                color: hijau_level_one,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 350,
            child: Text(
              'Mobile sangat Asik, makasih pak bagus! Bismillah Mobile A',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15, fontFamily: 'Poppins', color: hijau_level_one),
            ),
          ),
          const SizedBox(height: 42),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mata Uang',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    color: hijau_level_one),
              ),

              // Dropdown untuk memilih mata uang tujuan
              DropdownButton<String>(
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    color: hijau_level_one),
                alignment: Alignment.centerRight,
                value: _toCurrency,
                onChanged: (String? newValue) {
                  setState(() {
                    _toCurrency = newValue!;
                    _saveSelectedCurrency(newValue);
                  });
                },
                items: exchangeRates.keys
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Waktu',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    color: hijau_level_one),
              ),
              // Dropdown untuk memilih zona waktu
              DropdownButton<String>(
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    color: hijau_level_one),
                alignment: Alignment.centerRight,
                value: selectedTimezone,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTimezone = newValue!;
                    // Menyimpan pilihan zona waktu ke SharedPreferences
                    _saveSelectedTimezone(newValue);
                  });
                },
                items:
                    timezones.map<DropdownMenuItem<String>>((String timezone) {
                  return DropdownMenuItem<String>(
                    value: timezone,
                    child: Text(timezone),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 42),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.red)),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: Text(
                  'Keluar Akun',
                  style: TextStyle(
                      fontSize: 15, fontFamily: 'Poppins', color: putih),
                )),
          )
        ],
      ),
    );
  }
}
