import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'SeleccionTallaScreen.dart'; 

class ProductoDetalleScreen extends StatefulWidget {
  final int productId;

  const ProductoDetalleScreen({super.key, required this.productId});

  @override
  _ProductoDetalleScreenState createState() => _ProductoDetalleScreenState();
}

class _ProductoDetalleScreenState extends State<ProductoDetalleScreen> {
  late Future<Map<String, dynamic>> productFuture;
  bool isFavorito = false; 

  @override
  void initState() {
    super.initState();
    productFuture = _fetchProductData();
    checkFavorito();
  }

  Future<Map<String, dynamic>> _fetchProductData() async {
    final response = await http.get(Uri.parse(
        'http://127.0.0.1/clothes_app_php/auth/producto_detalle.php?id=${widget.productId}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Future<void> checkFavorito() async {
    int usuarioId = 1; 

    try {
      final response = await http.get(Uri.parse(
          'http://127.0.0.1/clothes_app_php/auth/check_favorito.php?usuario_id=$usuarioId&producto_id=${widget.productId}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          isFavorito = data['is_favorito'];
        });
      } else {
        throw Exception('Error al verificar el favorito');
      }
    } catch (e) {
      print("Error al verificar favorito: $e");
    }
  }

  Future<void> toggleFavorito() async {
    int usuarioId = 1;

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1/clothes_app_php/auth/favoritos.php"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario_id': usuarioId,
          'producto_id': widget.productId,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        setState(() {
          isFavorito = !isFavorito; 
        });
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      print("Error al agregar/eliminar favorito: $e");
    }
  }

  Future<void> agregarACarrito(int userId, String talla) async {
    final url =
        Uri.parse("http://127.0.0.1/clothes_app_php/auth/agregar_carrito.php");
    final body = jsonEncode({
      'user_id': userId,
      'product_id': widget.productId,
      'talla': talla,
      'cantidad': 1,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto añadido al carrito')),
        );
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al añadir al carrito: $e')),
      );
    }
  }

  void irASeleccionarTalla() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeleccionTallaScreen(
          productId: widget.productId,
          agregarACarrito: agregarACarrito,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No product data found.'));
          } else {
            final productData = snapshot.data!['product'];
            final productImages = List<String>.from(snapshot.data!['images']);

            double precioOriginal =
                double.parse(productData['precio'].toString());
            double precioConDescuento = precioOriginal;

            if (productData['promocion_id'] != null) {
              double descuento =
                  double.parse(productData['descuento'].toString());
              precioConDescuento =
                  precioOriginal - (precioOriginal * descuento / 100);
            }

            return Stack(
              children: [
                PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: productImages.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      productImages[index],
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    );
                  },
                ),
                Positioned(
                  top: 5, 
                  left: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorito ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed:
                            toggleFavorito, 
                      ),
                    ],
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.2,
                  minChildSize: 0.2,
                  maxChildSize: 1.0, 
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productData['nombre'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Referencia: ${productData['referencia']}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Color: ${productData['color']}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (productData['promocion_id'] != null)
                                        Text(
                                          '\$${precioConDescuento.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors
                                                .red, 
                                          ),
                                        ),
                                      if (productData['promocion_id'] != null)
                                        Text(
                                          '\$${precioOriginal.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            decoration: TextDecoration
                                                .lineThrough, 
                                            color: Colors.black54,
                                          ),
                                        ),
                                      if (productData['promocion_id'] == null)
                                        Text(
                                          '\$${precioOriginal.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Colors.black,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  irASeleccionarTalla();
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity,
                                      50),
                                  backgroundColor:
                                      Colors.black, 
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), 
                                  ),
                                ),
                                child: Text(
                                  'Comprar Ya',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white, 
                                  ),
                                ),
                              ),

                              SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical:
                                            10), 
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey), 
                                        borderRadius: BorderRadius.circular(
                                            10), 
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            Icon(Icons.store,
                                                color: Colors.black),
                                            SizedBox(width: 5),
                                            Text(
                                              'Recogida en tienda ',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              'GRATIS',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical:
                                            10), 
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey), 
                                        borderRadius: BorderRadius.circular(
                                            10), 
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            Icon(Icons.local_shipping,
                                                color: Colors.black),
                                            SizedBox(width: 5),
                                            Text(
                                              'Envío a domicilio estándar ',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              'GRATIS',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InfoProdScreen(
                                            productId: widget.productId)),
                                  );
                                },
                                child: Text(
                                  'Acerca de este producto',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class InfoProdScreen extends StatelessWidget {
  final int productId;

  const InfoProdScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Información del Producto')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchProductData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No product data found.'));
          } else {
            final productData = snapshot.data!['product'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productData['descripcion'],
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchProductData() async {
    final response = await http.get(Uri.parse(
        'http://127.0.0.1/clothes_app_php/auth/producto_detalle.php?id=$productId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load product details');
    }
  }
}
