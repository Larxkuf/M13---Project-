import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'bottom_nav_bar.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  _FavoritosScreenState createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  static const String baseUrl =
      "http://127.0.0.1/clothes_app_php"; 

  List<Map<String, dynamic>> productos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFavoritos();
  }

  Future<void> fetchFavoritos() async {
    int usuarioId = 1;

    try {
      final response = await http.get(
          Uri.parse("$baseUrl/auth/mis_favoritos.php?usuario_id=$usuarioId"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            productos = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
        } else {
          throw Exception("Respuesta inesperada del servidor.");
        }
      } else {
        throw Exception(
            "Error al cargar los productos favoritos: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al obtener los favoritos: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> toggleFavorito(int productoId) async {
    int usuarioId = 1;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/favoritos.php"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario_id': usuarioId,
          'producto_id': productoId,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        setState(() {
          productos.removeWhere((producto) => producto['id'] == productoId);
        });
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      print("Error al agregar/eliminar favorito: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(
        title: const Text("Mis Favoritos"),
        backgroundColor: const Color.fromARGB(255, 223, 223, 223),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : productos.isEmpty
              ? const Center(
                  child: Text(
                    "No has añadido nada todavía.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final producto = productos[index];
                    final id = producto['id'];
                    final nombre = producto['nombre'];
                    final imagen = producto['imagen'];

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/productoDetalle',
                          arguments: id,
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Image.network(
                                      imagen,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          nombre,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => toggleFavorito(id),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: BottomNavBar(
        style: 'gyaru',
        currentIndex: 1,
      ),
    );
  }
}
