import 'dart:convert';

// Model untuk data nutrisi
class Nutrition {
  final String name;
  final double fat;
  final double carbohydrates;
  final double sugar;
  final double fiber;
  final double sodium;
  final double cholesterol;

  // Constructor untuk inisialisasi objek
  Nutrition({
    required this.name,
    required this.fiber,
    required this.sodium,
    required this.cholesterol,
    required this.sugar,
    required this.fat,
    required this.carbohydrates,
  });

  // Membuat objek Nutrition dari JSON
  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      name: json['name'] ?? '', // Menangani null values
      sugar: _parseToDouble(json['sugar_g']),
      fiber: _parseToDouble(json['fiber_g']),
      sodium: _parseToDouble(json['sodium_g']),
      cholesterol: _parseToDouble(json['cholesterol_mg']),
      fat: _parseToDouble(json['fat']),
      carbohydrates: _parseToDouble(json['carbohydrates_total_g']),
    );
  }

  // Fungsi untuk mengonversi nilai menjadi double jika memungkinkan
  static double _parseToDouble(dynamic value) {
    if (value is String) {
      // Jika value adalah String, coba untuk mengonversinya menjadi double
      return double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      // Jika value sudah berupa num (int atau double), langsung return
      return value.toDouble();
    }
    return 0.0; // Default jika tidak dapat dikonversi
  }

  // Mengubah objek Nutrition menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fat': fat,
      'sugar': sugar,
      'fiber': fiber,
      'carbohydrates': carbohydrates,
      'sodium': sodium,
      'cholesterol': cholesterol,
    };
  }
}

// Fungsi untuk mengonversi respons JSON menjadi list objek Nutrition
List<Nutrition> nutritionFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Nutrition>.from(jsonData.map((x) => Nutrition.fromJson(x)));
}

// Fungsi untuk mengonversi list objek Nutrition menjadi JSON
String nutritionToJson(List<Nutrition> data) {
  final dyn = List<dynamic>.from(data.map((item) => item.toJson()));
  return json.encode(dyn);
}
