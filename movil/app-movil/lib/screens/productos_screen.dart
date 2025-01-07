import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'bottom_nav_bar.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  static const String baseUrl = "http://127.0.0.1/clothes_app_php";
  List<Map<String, dynamic>> productos = [];
  List<Map<String, dynamic>> productosFiltrados = [];
  List<int> favoritos = []; 

  List<String> categoria = [];
  String filtroBusqueda = "";
  String categoriaSeleccionada = "";

  @override
  void initState() {
    super.initState();
    fetchProductos();
    fetchCategoria();
  }

  Future<void> fetchProductos() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/auth/productos.php"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            productos = List<Map<String, dynamic>>.from(data);
            productosFiltrados = productos.isEmpty
                ? []
                : productos; 
          });
        } else {
          throw Exception("Respuesta inesperada del servidor.");
        }
      } else {
        throw Exception(
            "Error al cargar los productos: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchCategoria() async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/auth/categorias.php"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            categoria = List<String>.from(data.map((e) => e['nombre']));
          });
        } else {
          throw Exception("Error al cargar categorías.");
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void filtrarProductos() {
    setState(() {
      productosFiltrados = productos.where((producto) {
        bool coincideBusqueda = producto['nombre']
            .toLowerCase()
            .contains(filtroBusqueda.toLowerCase());
        bool coincideCategoria = categoriaSeleccionada.isEmpty ||
            producto['categoria'] == categoriaSeleccionada;
        return coincideBusqueda && coincideCategoria;
      }).toList();
    });
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
          if (favoritos.contains(productoId)) {
            favoritos.remove(productoId);
          } else {
            favoritos.add(productoId); 
          }
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Todos los Productos"),
        backgroundColor: const Color.fromARGB(255, 83, 85, 221),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Buscar por nombre...",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      setState(() {
                        filtroBusqueda = text;
                        filtrarProductos();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          productosFiltrados.isEmpty
              ? const Center(
                  child:
                      CircularProgressIndicator()) 
              : Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: productosFiltrados.length,
                    itemBuilder: (context, index) {
                      final producto = productosFiltrados[index];
                      final nombre = producto['nombre'];
                      final imagen = producto['imagen'];
                      final productId =
                          producto['id'];  

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/productoDetalle',
                            arguments:
                                productId, 
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
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
                                    horizontal: 8.0, vertical: 0.0),
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
                                      icon: Icon(
                                        favoritos.contains(productId)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          toggleFavorito(productId),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        style: 'star',
        currentIndex: 2,
      ),
    );
  }
}
