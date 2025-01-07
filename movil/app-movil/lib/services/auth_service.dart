import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String baseUrl =
      'http://127.0.0.1/clothes_app_php/auth';

  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String country,
    String language,
    String currency,
    String dni, 
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email.trim(),
          'password': password.trim(),
          'country': country.trim(),
          'language': language.trim(),
          'currency': currency.trim(),
          'dni': dni.trim(),
        }),
      );
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'success': false,
          'message':
              'Error de conexión: Código de estado ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'success': false, 'message': 'Error de conexión'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
