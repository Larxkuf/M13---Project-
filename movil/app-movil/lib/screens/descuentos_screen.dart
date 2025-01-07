import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductosConDescuentoPage extends StatelessWidget {
  final String descuento; 

  const ProductosConDescuentoPage({super.key, required this.descuento});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('$descuento% de Descuento'),
      ),
      body: FutureBuilder(
        future: _fetchProductosConDescuento(descuento),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay productos disponibles.'));
          } else {
            final productos = snapshot.data!;

            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return Card(
                  child: Column(
                    children: [
                      Image.network(producto['imagen']),
                      Text(producto['nombre']),
                      Text('${producto['precio']}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<dynamic>> _fetchProductosConDescuento(String descuento) async {
    const url = 'http://127.0.0.1/clothes_app_php/api.php'; 

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final productos = data['productos'] ?? [];
        return productos.where((producto) {
          return producto['descuento'] == descuento;
        }).toList();
      } else {
        throw Exception('Error al cargar productos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
