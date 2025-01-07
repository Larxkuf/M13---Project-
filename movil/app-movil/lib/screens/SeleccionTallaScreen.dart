import 'package:flutter/material.dart';

class SeleccionTallaScreen extends StatelessWidget {
  final int productId;
  final Future<void> Function(int userId, String talla) agregarACarrito;

  const SeleccionTallaScreen(
      {super.key, required this.productId, required this.agregarACarrito});

  final int userId =
      1;  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Talla'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Selecciona una talla para el producto',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: ['XS', 'S', 'M', 'L', 'XL'].map((talla) {
                return ElevatedButton(
                  onPressed: () {
                    agregarACarrito(userId, talla);
                    Navigator.pop(context); 
                  },
                  child: Text(talla),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
