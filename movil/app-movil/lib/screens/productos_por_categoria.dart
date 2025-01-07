import 'package:flutter/material.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http;

class ProductosPorCategoriaPage extends StatefulWidget {
  final String categoriaId; 
  final String categoriaNombre; 

  const ProductosPorCategoriaPage({
    super.key,
    required this.categoriaId,
    required this.categoriaNombre,
  });

  @override
  _ProductosPorCategoriaPageState createState() =>
      _ProductosPorCategoriaPageState();
}

class _ProductosPorCategoriaPageState extends State<ProductosPorCategoriaPage> {
  static const String baseUrl =
      "http://127.0.0.1/clothes_app_php"; 

  List<Map<String, dynamic>> productos = [];
  List<int> favoritos = [];

  @override
  void initState() {
    super.initState();
    fetchProductosPorCategoria(widget.categoriaId);
  }

  Future<void> fetchProductosPorCategoria(String categoriaId) async {
    try {
      final response = await http.get(Uri.parse(
          "$baseUrl/auth/productos_por_categoria.php?categoria_id=$categoriaId"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            productos = List<Map<String, dynamic>>.from(data);
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
      appBar: AppBar(
        title: Text(
          widget.categoriaNombre,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.white), 
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: productos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                    color: Colors.grey[850],
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: Image.network(
                                  imagen,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.error, color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
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
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      favoritos.contains(id)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
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
    );
  }
}
