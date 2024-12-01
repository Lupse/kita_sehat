// ignore_for_file: prefer_final_fields, unused_field

import 'dart:async';
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kita_sehat/model/exercise.dart';
import 'package:kita_sehat/model/nutrition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiKey = "uZKlfaOqNdK4vTHceApbkw==XPsgWokaFrzxP301";
  List<Exercise> exercises = []; // Daftar data exercise
  List<Nutrition> nutritionData = []; // Menggunakan list model Nutrition
  TextEditingController searchController = TextEditingController();
  bool isLoading = false; // Flag untuk status loading
  String? username;
  bool searched = false;
  double _convertedAmount = 0.0;
  String? _toCurrency = 'IDR';
  String? _fromCurrency = 'IDR';
  String? selectedTimezone = 'WIB';
  late Timer _timer;

  // Fungsi untuk memulai timer pembaruan waktu setiap detik
  void _startRealTimeUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Memperbarui tampilan waktu setiap detik
      });
    });
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

  // Fungsi untuk mengonversi waktu sesuai dengan zona waktu
  String getFormattedTime(String timezone) {
    DateTime now = DateTime.now();
    late DateTime convertedTime;

    // Menghitung waktu berdasarkan zona waktu yang dipilih
    switch (timezone) {
      case 'WIB': // Waktu Indonesia Barat (UTC+7)
        convertedTime = now.toUtc().add(const Duration(hours: 7));
        break;
      case 'WITA': // Waktu Indonesia Tengah (UTC+8)
        convertedTime = now.toUtc().add(const Duration(hours: 8));
        break;
      case 'WIT': // Waktu Indonesia Timur (UTC+9)
        convertedTime = now.toUtc().add(const Duration(hours: 9));
        break;
      case 'London': // Waktu London (UTC)
        convertedTime =
            now.toUtc(); // Waktu UTC (London saat ini menggunakan UTC)
        break;
      default:
        convertedTime = now;
    }

    // Format waktu sesuai dengan zona waktu yang dipilih
    return DateFormat('HH:mm:ss').format(convertedTime);
  }

  // Nilai tukar statis dari IDR ke mata uang lain
  Map<String, double> exchangeRates = {
    'IDR': 1.0, // 1 IDR = 1 IDR
    'USD': 0.000064, // 1 IDR = 0.000064 USD
    'EUR': 0.000060, // 1 IDR = 0.000060 EUR
    'JPY': 0.0071, // 1 IDR = 0.0071 JPY
    'GBP': 0.000051, // 1 IDR = 0.000051 GBP
  };

  // Fungsi untuk memuat mata uang tujuan yang dipilih dari SharedPreferences
  Future<void> _loadSelectedCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCurrency = prefs.getString('selectedCurrency');
    if (savedCurrency != null) {
      setState(() {
        _toCurrency = savedCurrency;
      });
    }
    _convertCurrency();
  }

  // Fungsi untuk mengonversi mata uang
  void _convertCurrency() {
    double amount = double.tryParse('25000') ?? 0.0;
    double result =
        amount * exchangeRates[_toCurrency]! / exchangeRates[_fromCurrency]!;
    setState(() {
      _convertedAmount = result;
    });
  }

  // Fungsi notifikasi
  void showNotification(String title) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: title,
        body: 'Dont forget to do $title for today!',
      ),
    );
  }

  // Fungsi untuk mengambil data exercise dari API
  Future<void> fetchExerciseData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/exercises'),
      headers: {'X-Api-Key': apiKey},
    );

    if (response.statusCode == 200) {
      // Jika berhasil, parse data JSON dan update state
      setState(() {
        exercises = exerciseFromJson(response.body);
        isLoading = false;
      });
    } else {
      // Jika gagal, set loading ke false
      setState(() {
        isLoading = false;
      });
      print('Failed to load exercise data');
    }
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
  }

  // Fungsi untuk mencari data nutrisi berdasarkan query
  Future<void> fetchNutritionData(String query) async {
    if (query.isEmpty) {
      setState(() {
        nutritionData = [];
        isLoading = false; // Menyembunyikan loader jika query kosong
      });
      return;
    }

    setState(() {
      isLoading = true; // Menampilkan loader saat memulai pencarian
    });

    final response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/nutrition?query=$query'),
      headers: {'X-Api-Key': apiKey},
    );

    if (response.statusCode == 200) {
      // Memeriksa apakah respons JSON mengandung data atau tidak
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        setState(() {
          nutritionData = nutritionFromJson(
              response.body); // Mengonversi JSON ke objek model
          isLoading = false;
        });
      } else {
        setState(() {
          nutritionData = [];
          isLoading = false;
        });
        print('No data found for the query.');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to load nutrition data');
    }
  }

  @override
  void initState() {
    super.initState();
    loadSession();
    fetchExerciseData();
    _loadSelectedCurrency();
    _convertCurrency();
    _loadSelectedTimezone();
    _startRealTimeUpdates();
  }

  @override
  Widget build(BuildContext context) {
    // Library Warna
    Color hijauLevelOne = const Color(0XFF1E5631);
    Color hijauLevelThree = const Color(0XFF76BA1B);
    Color putih = const Color(0XFFFEFEFE);

    return Scaffold(
      backgroundColor: putih,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(top: 42.0, left: 35, right: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${getFormattedTime(selectedTimezone!)} $selectedTimezone',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: hijauLevelOne),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selamat Pagi, $username',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: hijauLevelOne),
                      ),
                      Text(
                        'Sleman, Yogyakarta.',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: hijauLevelOne),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.jpeg'),
                  )
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Cek Makanan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Text(
                'Cek Makanan Kamu',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: hijauLevelOne),
              ),
            ),
            const SizedBox(height: 12),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(72, 217, 217, 217),
                  borderRadius: BorderRadius.all(Radius.circular(26)),
                ),
                child: TextField(
                  controller: searchController,
                  cursorColor: hijauLevelOne,
                  decoration: InputDecoration(
                    suffix: SizedBox(
                      width: 25,
                      height: 25,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            searched = true;
                          });
                          fetchNutritionData(searchController.text);
                        },
                        icon: const Icon(Icons.search),
                        iconSize: 22,
                        color: Colors.black54,
                      ),
                    ),
                    hintText: 'e.g Apple',
                    hintStyle: const TextStyle(
                        fontFamily: 'Poppins', color: Colors.black45),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                    isDense: true,
                  ),
                ),
              ),
            ),

            // Search Items
            SizedBox(
              height: searched ? 200 : 40,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: nutritionData.length,
                      itemBuilder: (context, index) {
                        final item = nutritionData[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35.0),
                          child: Container(
                            height: 149,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(19)),
                                color: Color(0xffF1FFE7)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: hijauLevelOne),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Sugar (gr) : ${item.sugar}',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: hijauLevelOne),
                                          ),
                                          Text(
                                            'Fiber (gr) : ${item.fiber}',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: hijauLevelOne),
                                          ),
                                          Text(
                                            'Total Carbo : ${item.carbohydrates}',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: hijauLevelOne),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Sodium : ${item.sodium}',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: hijauLevelOne),
                                          ),
                                          Text(
                                            'Protein : ${item.cholesterol}',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: hijauLevelOne),
                                          ),
                                          Text(
                                            'Fat : ${item.fat}',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: hijauLevelOne),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),

            // Olahraga
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Text(
                'Yuk, Olahraga',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: hijauLevelOne),
              ),
            ),
            const SizedBox(height: 12),

            // Olahraga Items
            SizedBox(
              height: 150,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: exercises.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(19)),
                                color: Color(0xffF1FFE7)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 12),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exercise.name,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: hijauLevelOne),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tipe : ${exercise.type}',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: hijauLevelOne),
                                  ),
                                  Text(
                                    'Otot : ${exercise.muscle}',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: hijauLevelOne),
                                  ),
                                  Text(
                                    'Alat bantu : ${exercise.equipment}',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: hijauLevelOne),
                                  ),
                                  const SizedBox(height: 4),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 23,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  hijauLevelThree),
                                          foregroundColor:
                                              WidgetStatePropertyAll(putih),
                                        ),
                                        onPressed: () {
                                          showNotification(exercise.name);
                                        },
                                        child: const Text(
                                          'Reminder',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 11,
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 12),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Container(
                  height: 165,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                      color: hijauLevelThree),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          Text(
                            'Premium Plan',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: putih),
                          ),
                          Text(
                            'Dapatkam premium untuk informasi nutrisi yang lebih lengkap dan rekomendasi olahraga yang lebih banyak',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: putih),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Total : ${_convertedAmount.toStringAsFixed(2)} $_toCurrency',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: putih),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            height: 28,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: const WidgetStatePropertyAll(
                                      Color(0xffFF9D00)),
                                  foregroundColor:
                                      WidgetStatePropertyAll(putih),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Dapatkan Premium',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 22)
          ],
        ),
      ),
    );
  }
}
