import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bottom_nav_bar.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<Map<String, dynamic>> _userData;
  final int userId = 1;

  @override
  void initState() {
    super.initState();
    _userData = fetchUserData(userId);
  }

  Future<Map<String, dynamic>> fetchUserData(int userId) async {
    const String baseUrl = "http://127.0.0.1/clothes_app_php";
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/auth/get_user_data.php?user_id=$userId"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          return data;
        } else {
          throw Exception('Error al obtener los datos del usuario');
        }
      } else {
        throw Exception(
            'Error al cargar los datos del usuario: ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      return {};
    }
  }

  Future<void> updateUserData(int userId, String email, String country,
      String language, String currency) async {
    final url =
        Uri.parse('http://127.0.0.1/clothes_app_php/auth/update_user_data.php');

    try {
      final response = await http.post(url, body: {
        'id': userId
            .toString(), 
        'email': email,
        'country': country,
        'language': language,
        'currency': currency,
      });

      final responseData = json.decode(response.body);
      print('Response: ${responseData['message']}');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final userData = snapshot.data ?? {};

          if (userData.isEmpty) {
            return const Center(
                child: Text('No se pudo cargar los datos del usuario.'));
          }

          return ListView(
            padding: const EdgeInsets.all(10),
            children: [
              Text(
                '  Hola, ${userData['email'] ?? 'Correo no disponible'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MisComprasScreen(userId: userId),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.grey[200],
                    side: BorderSide(color: Colors.black),
                  ),
                  child: const Text(
                    'Mis compras',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserDetailsScreen(userData: userData),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.grey[200],
                    side: BorderSide(color: Colors.black),
                  ),
                  child: const Text(
                    'Datos personales',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    minimumSize: Size(0, 50),
                  ),
                  child: const Text(
                    'Cerrar sesión',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        style: 'gyaru',
        currentIndex: 4,
      ),
    );
  }
}

class MisComprasScreen extends StatefulWidget {
  final int userId;

  const MisComprasScreen({super.key, required this.userId});

  @override
  _MisComprasScreenState createState() => _MisComprasScreenState();
}

class _MisComprasScreenState extends State<MisComprasScreen> {
  late Future<List<Map<String, dynamic>>> _compras;

  @override
  void initState() {
    super.initState();
    _compras = fetchMisCompras(widget.userId); 
  }

  Future<List<Map<String, dynamic>>> fetchMisCompras(int userId) async {
    const String baseUrl =
        "http://127.0.0.1/clothes_app_php"; 
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/auth/mis_compras.php?user_id=$userId"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data.containsKey('compras')) {
          return List<Map<String, dynamic>>.from(data['compras']);
        } else {
          throw Exception(
              'Error al obtener las compras: formato de respuesta inválido');
        }
      } else {
        throw Exception('Error al cargar las compras: ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Compras')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _compras,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final compras = snapshot.data ?? [];

          if (compras.isEmpty) {
            return const Center(child: Text('No tienes compras registradas.'));
          }

          return ListView.builder(
            itemCount: compras.length,
            itemBuilder: (context, index) {
              final compra = compras[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: ListTile(
                  title: Text('Compra #${compra['id']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha: ${compra['fecha_compra']}'),
                      Text('Método de pago: ${compra['metodo_pago']}'),
                      Text('Método de envío: ${compra['metodo_envio']}'),
                      Text('Total: \$${compra['total']}'),
                      Text('Dirección: ${compra['direccion']}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        style: 'gyaru',
        currentIndex: 4,
      ),
    );
  }
}

class UserDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserDetailsScreen({super.key, required this.userData});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late TextEditingController _idController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _dniController;
  late TextEditingController _countryController;
  late TextEditingController _languageController;
  late TextEditingController _currencyController;

  @override
  void initState() {
    super.initState();
    _idController =
        TextEditingController(text: widget.userData['id']?.toString());
    _emailController = TextEditingController(text: widget.userData['email']);
    _passwordController =
        TextEditingController(text: widget.userData['password']);
    _dniController = TextEditingController(text: widget.userData['dni']);
    _countryController =
        TextEditingController(text: widget.userData['country']);
    _languageController =
        TextEditingController(text: widget.userData['language']);
    _currencyController =
        TextEditingController(text: widget.userData['currency']);
  }

  @override
  void dispose() {
    _idController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dniController.dispose();
    _countryController.dispose();
    _languageController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    const String baseUrl = "http://127.0.0.1/clothes_app_php";
    final Map<String, String> updatedData = {
      'id': _idController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'dni': _dniController.text,
      'country': _countryController.text,
      'language': _languageController.text,
      'currency': _currencyController.text,
    };

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/update_user_data.php"),
        body: updatedData,
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Datos actualizados con éxito')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al actualizar los datos')),
          );
        }
      } else {
        throw Exception('Error al conectar con el servidor');
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar los datos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Datos personales")),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          ListTile(
            title: const Text('ID'),
            subtitle: TextFormField(
              controller: _idController,
              enabled: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Correo electrónico'),
            subtitle: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingresa tu correo electrónico',
              ),
            ),
          ),
          ListTile(
            title: const Text('País'),
            subtitle: TextFormField(
              controller: _countryController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingresa tu país',
              ),
            ),
          ),
          ListTile(
            title: const Text('Idioma'),
            subtitle: TextFormField(
              controller: _languageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingresa tu idioma preferido',
              ),
            ),
          ),
          ListTile(
            title: const Text('Moneda'),
            subtitle: TextFormField(
              controller: _currencyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingresa tu moneda preferida',
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Guardar cambios'),
          ),
        ],
      ),
    );
  }
}
