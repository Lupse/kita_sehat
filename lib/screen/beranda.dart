// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_fonts/google_fonts.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final String apiKey = "uZKlfaOqNdK4vTHceApbkw==XPsgWokaFrzxP301";
//   List<dynamic> nutritionData = [];
//   List<dynamic> exerciseData = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchNutritionData();
//     fetchExerciseData();
//   }

//   // Fetch data from the nutrition API
//   Future<void> fetchNutritionData() async {
//     final response = await http.get(
//       Uri.parse(
//           'https://api.api-ninjas.com/v1/nutrition?query=apple'), // Contoh query untuk apel
//       headers: {'X-Api-Key': apiKey},
//     );
//     if (response.statusCode == 200) {
//       setState(() {
//         nutritionData = json.decode(response.body);
//       });
//     } else {
//       print('Failed to load nutrition data');
//     }
//   }

//   // Fetch data from the exercise API
//   Future<void> fetchExerciseData() async {
//     final response = await http.get(
//       Uri.parse(
//           'https://api.api-ninjas.com/v1/exercises?name=push-up'), // Contoh query untuk push-up
//       headers: {'X-Api-Key': apiKey},
//     );
//     if (response.statusCode == 200) {
//       setState(() {
//         exerciseData = json.decode(response.body);
//       });
//     } else {
//       print('Failed to load exercise data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Warna hijau untuk tombol dan header
//     Color hijau = Color(0XFF1E5631);
//     Color putih = Colors.white;
//     Color hitam = Color(0XFF1E1E1E);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: hijau,
//         title: Text('Aplikasi Sehat', style: GoogleFonts.poppins(fontSize: 22)),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             // Kartu Nutrisi
//             Card(
//               elevation: 5,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text('Nutrisi',
//                         style: GoogleFonts.poppins(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                   ),
//                   nutritionData.isEmpty
//                       ? Center(child: CircularProgressIndicator())
//                       : ListView.builder(
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemCount: nutritionData.length,
//                           itemBuilder: (context, index) {
//                             var item = nutritionData[index];
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16.0, vertical: 8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Makanan: ${item["food_name"]}',
//                                       style: GoogleFonts.poppins(fontSize: 16)),
//                                   Text('Kalori: ${item["sugar_mg"]} kcal',
//                                       style: GoogleFonts.poppins(fontSize: 16)),
//                                   Divider(),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             // Kartu Olahraga
//             Card(
//               elevation: 5,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text('Olahraga',
//                         style: GoogleFonts.poppins(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                   ),
//                   exerciseData.isEmpty
//                       ? Center(child: CircularProgressIndicator())
//                       : ListView.builder(
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemCount: exerciseData.length,
//                           itemBuilder: (context, index) {
//                             var item = exerciseData[index];
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16.0, vertical: 8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Olahraga: ${item["name"]}',
//                                       style: GoogleFonts.poppins(fontSize: 16)),
//                                   Text('Jenis: ${item["type"]}',
//                                       style: GoogleFonts.poppins(fontSize: 16)),
//                                   Divider(),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiKey = "uZKlfaOqNdK4vTHceApbkw==XPsgWokaFrzxP301";
  List<dynamic> nutritionData = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false; // Flag untuk status loading

  @override
  void initState() {
    super.initState();
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
      setState(() {
        nutritionData = json.decode(response.body);
        isLoading = false; // Menyembunyikan loader setelah data berhasil dimuat
      });
    } else {
      setState(() {
        isLoading = false; // Menyembunyikan loader jika terjadi error
      });
      print('Failed to load nutrition data');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Warna hijau untuk tombol dan header
    Color hijau = Color(0XFF1E5631);
    Color putih = Colors.white;
    Color hitam = Color(0XFF1E1E1E);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: hijau,
        title: Text('Aplikasi Sehat', style: GoogleFonts.poppins(fontSize: 22)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pencarian Makanan
            TextField(
              controller: searchController,
              onChanged: (query) {
                fetchNutritionData(
                    query); // Memanggil API setiap ada perubahan input
              },
              decoration: InputDecoration(
                labelText: 'Cari Makanan',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Menampilkan loader jika masih loading
            if (isLoading) Center(child: CircularProgressIndicator()),

            // Kartu Nutrisi berdasarkan pencarian
            if (!isLoading && nutritionData.isEmpty)
              Center(child: Text('Tidak ada data ditemukan')),
            if (!isLoading && nutritionData.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: nutritionData.length,
                  itemBuilder: (context, index) {
                    var item = nutritionData[index];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Makanan: ${item["name"]}',
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Kalori: ${item["calories"]} kcal',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Protein: ${item["protein"]} g',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Karbohidrat: ${item["carbohydrates"]} g',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Lemak: ${item["fat"]} g',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
