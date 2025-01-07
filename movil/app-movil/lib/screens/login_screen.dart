import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _errorMessage = '';
  final AuthService _authService =
      AuthService(); 

  Future<void> _login() async {
    final result = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (result['success']) {
      Navigator.pushReplacementNamed(
          context, '/home'); 
    } else {
      setState(() {
        _errorMessage = result['message']; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050096), 
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 21.0), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'INICIA SESIÓN PARA CONTINUAR',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, 
              ),
            ),
            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0), 
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle:
                      TextStyle(color: Color(0xFF050051)),
                  filled: true,
                  fillColor: Colors.white, 
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
                style: const TextStyle(
                    color: Colors.black), 
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
                  labelStyle:
                      TextStyle(color: Color(0xFF050051)), 
                  filled: true,
                  fillColor: Colors.white,
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
                style: const TextStyle(
                    color: Colors.black), 
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

            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 14, 13, 56), 
                minimumSize: const Size(
                    double.infinity, 50),
                padding: const EdgeInsets.symmetric(vertical: 15),
                side: const BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0)), 
                textStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255)), 
              ),
              child: const Text('Iniciar sesión'),
            ),

            const SizedBox(height: 10),

            Text(
              '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white, 
              ),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, '/register'); 
              },
              child: const Text(
                '¿No tienes una cuenta? Regístrate',
                style: TextStyle(color: Colors.white), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
