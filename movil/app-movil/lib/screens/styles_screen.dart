import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  Future<Map<String, dynamic>> fetchUserData(int userId) async {
    const String baseUrl = "http://127.0.0.1/clothes_app_php";
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/auth/user_data.php?user_id=$userId"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map) {
          return Map<String, dynamic>.from(data);
        } else {
          throw Exception('Error al obtener los datos del usuario');
        }
      } else {
        throw Exception('Error al cargar los datos del usuario: ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final int userId = 1; 

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final user = snapshot.data ?? {};

          if (user.isEmpty) {
            return const Center(child: Text('No se pudo cargar los datos del usuario.'));
          }

          return ListView(
            padding: const EdgeInsets.all(10),
            children: [
              Text(
                '¡Hola, ${user['nombre']}!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Correo: ${user['email']}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Mis compras'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MisComprasScreen(userId: userId),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text('Nombre: ${user['nombre']}'),
              ),
              ListTile(
                title: Text('País: ${user['country']}'),
              ),
              ListTile(
                title: Text('Idioma: ${user['language']}'),
              ),
              const Divider(),
              ListTile(
                title: const Text('Cerrar sesión'),
                onTap: () {
                  Navigator.pushNamed(context, '/login'); 
                },
              ),
            ],
          );
        },
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
    const String baseUrl = "http://127.0.0.1/clothes_app_php";
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/auth/mis_compras.php?user_id=$userId"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else {
          throw Exception('Error al obtener las compras');
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
              return ListTile(
                title: Text('Compra #${compra['id']}'),
                subtitle: Text('Fecha: ${compra['fecha_compra']}'),
                trailing: Text('\$${compra['total']}'),
              );
            },
          );
        },
      ),
    );
  }
}
