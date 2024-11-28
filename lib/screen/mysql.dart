import 'package:mysql1/mysql1.dart';
import 'package:bcrypt/bcrypt.dart';

class MySQLHelper {
  final ConnectionSettings settings = ConnectionSettings(
    host: 'localhost', // Ganti dengan alamat MySQL server Anda
    port: 3306,
    user: 'root',
    password: '', // Ganti dengan username MySQL Anda
    db: 'login_db', // Nama database yang Anda buat
  );

  Future<MySqlConnection> _connect() async {
    return await MySqlConnection.connect(settings);
  }

  // Fungsi untuk menyimpan pengguna baru ke database
  Future<bool> registerUser(
      String username, String email, String password) async {
    try {
      final connection = await _connect();

      // Enkripsi password dengan bcrypt
      String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      var result = await connection.query(
          'INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
          [username, email, hashedPassword]);

      await connection.close();

      return result.affectedRows != null && result.affectedRows! > 0;
    } catch (e) {
      print("Gagal Konek: $e");
      return false;
    }
  }

  Future<bool> verifyUser(String email, String password) async {
    final connection = await _connect();
    var results = await connection
        .query('SELECT password FROM users WHERE email = ?', [email]);
    await connection.close();

    if (results.isNotEmpty) {
      String storedPassword = results.first[0];
      return BCrypt.checkpw(password, storedPassword);
    }
    return false;
  }
}
