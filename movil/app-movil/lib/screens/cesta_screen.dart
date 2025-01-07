import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'bottom_nav_bar.dart';
import 'pago_screen.dart';

class CestaScreen extends StatefulWidget {
  final int userId;

  const CestaScreen({super.key, required this.userId});

  @override
  _CestaScreenState createState() => _CestaScreenState();
}

class _CestaScreenState extends State<CestaScreen> {
  late Future<Map<String, dynamic>> cestaFuture;

  @override
  void initState() {
    super.initState();
    cestaFuture = _fetchCestaData();
  }

  Future<Map<String, dynamic>> _fetchCestaData() async {
    print('userId: ${widget.userId}'); 

    final response = await http.get(Uri.parse(
        'http://127.0.0.1/clothes_app_php/auth/obtener_cesta.php?user_id=${widget.userId}'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print('Respuesta: $json'); 
      return json;
    } else {
      throw Exception('Failed to load cesta data');
    }
  }

  Future<void> _eliminarProducto(int productoId) async {
    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1/clothes_app_php/auth/obtener_cesta.php?user_id=${widget.userId}'),
      body: {
        'producto_id': productoId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success']) {
        setState(() {
          cestaFuture =
              _fetchCestaData(); 
        });
      } else {
        print('Error al eliminar el producto: ${responseData['message']}');
      }
    } else {
      print(
          'Error al eliminar el producto. Código de respuesta: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cesta de la Compra'),
        automaticallyImplyLeading: false, 
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: cestaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!['productos'] == null ||
              snapshot.data!['productos'].isEmpty) {
            return Center(child: Text('No hay productos en la cesta.'));
          } else {
            final productos = snapshot.data!['productos'];
            final total = snapshot.data!['total'];

            final totalDouble = double.tryParse(total.toString()) ?? 0.0;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      final producto = productos[index];
                      final nombre =
                          producto['nombre'] ?? 'Producto sin nombre';
                      final categoria = producto['categoria'] ?? 'Ropa';
                      final precioTotal = double.tryParse(
                              producto['precio_total'].toString()) ?? 
                          0.0;
                      final productoId = producto['product_id']; 
                      final imageUrl = producto['imagen_url'] ?? ''; 

                      return ListTile(
                        title: Text(nombre),
                        subtitle: Text('Categoría: $categoria'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('\$${precioTotal.toStringAsFixed(2)}'),
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                              onPressed: () async {
                                await _eliminarProducto(productoId);
                              },
                            ),
                          ],
                        ),
                        leading: (producto['imagen'] != null && producto['imagen'].isNotEmpty)
                            ? Image.network(
                                producto['imagen'], 
                                width: 50, 
                                height: 50, 
                                fit: BoxFit.cover,
                              )
                            : SizedBox(), 
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${totalDouble.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PagoScreen(userId: widget.userId),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Proceder al pago',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(
        style: 'gyaru',
        currentIndex: 3,
      ),
    );
  }
}
