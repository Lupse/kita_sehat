import 'dart:convert';

// Model untuk data Exercise
class Exercise {
  final String name;
  final String type;
  final String muscle;
  final String equipment;

  // Constructor untuk inisialisasi objek
  Exercise({
    required this.name,
    required this.type,
    required this.muscle,
    required this.equipment,
  });

  // Membuat objek Exercise dari JSON
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      muscle: json['muscle'] ?? '',
      equipment: json['equipment'] ?? '',
    );
  }

  // Mengubah objek Exercise menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'muscle': muscle,
      'equipment': equipment,
    };
  }
}

// Fungsi untuk mengonversi respons JSON menjadi list objek Exercise
List<Exercise> exerciseFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Exercise>.from(jsonData.map((x) => Exercise.fromJson(x)));
}

// Fungsi untuk mengonversi list objek Exercise menjadi JSON
String exerciseToJson(List<Exercise> data) {
  final dyn = List<dynamic>.from(data.map((item) => item.toJson()));
  return json.encode(dyn);
}
