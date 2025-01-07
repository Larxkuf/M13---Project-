import 'package:flutter/material.dart';
import '../services/auth_service.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dniController =
      TextEditingController(); 

  String _errorMessage = ''; 
  final AuthService _authService =
      AuthService(); 

  String? _selectedCountry;
  String? _selectedLanguage;
  String? _selectedCurrency;

  final List<String> countries = [
    'España',
    'México',
    'EEUU',
    'Argentina'
  ]; 
  final List<String> languages = [
    'Español',
  ]; 
  final List<String> currencies = ['EUR']; 

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Las contraseñas no coinciden';
      });
      return;
    }

    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _dniController.text.isEmpty ||
        _selectedCountry == null ||
        _selectedLanguage == null ||
        _selectedCurrency == null) {
      setState(() {
        _errorMessage = 'Todos los campos son requeridos';
      });
      return;
    }

    final result = await _authService.register(
      _emailController.text.trim(), 
      _passwordController.text.trim(), 
      _selectedCountry!, 
      _selectedLanguage!, 
      _selectedCurrency!,
      _dniController.text.trim(), 
    );

    if (result['success']) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      setState(() {
        _errorMessage = result['message']; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 64, 77, 189), 
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 50.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Ingresa los datos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0), 
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)),
                  filled: true,
                  fillColor:
                      const Color.fromARGB(255, 151, 165, 242), 
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(
                            0xFF050051)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0), 
              child: TextField(
                controller: _dniController, 
                decoration: InputDecoration(
                  labelText: 'DNI',
                  labelStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)), 
                  filled: true,
                  fillColor:
                      const Color.fromARGB(255, 151, 165, 242), 
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(
                            0xFF050051)), 
                  ),
                ),
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.black), 
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0), 
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)), 
                  filled: true,
                  fillColor:
                      const Color.fromARGB(255, 151, 165, 242), 
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(
                            0xFF050051)), 
                  ),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.black), 
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0), 
              child: TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirmar contraseña',
                  labelStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)), 
                  filled: true,
                  fillColor:
                      const Color.fromARGB(255, 151, 165, 242), 
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(
                            0xFF050051)), 
                  ),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.black), 
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0), 
              child: DropdownButtonFormField<String>(
                value: _selectedCountry,
                hint: const Text('Selecciona tu país'),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                },
                items: countries.map((String country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'País',
                  labelStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)), 
                  filled: true,
                  fillColor:
                      const Color.fromARGB(255, 151, 165, 242), 
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(
                            0xFF050051)), 
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0), 
              child: DropdownButtonFormField<String>(
                value: _selectedLanguage,
                hint: const Text('Selecciona tu idioma'),
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                },
                items: languages.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Idioma',
                  labelStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)), 
                  filled: true,
                  fillColor:
                      const Color.fromARGB(255, 151, 165, 242),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(
                            0xFF050051)), 
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0),
              child: DropdownButtonFormField<String>(
                value: _selectedCurrency,
                hint: const Text('Selecciona tu moneda'),
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value;
                  });
                },
                items: currencies.map((String currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Moneda',
                  labelStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)), 
                  filled: true,
                  fillColor:
                      const Color.fromARGB(255, 151, 165, 242), 
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(
                            0xFF050051)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor:
                      Color.fromARGB(255, 230, 228, 255), 
                ),
                child: const Text('Crear cuenta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
