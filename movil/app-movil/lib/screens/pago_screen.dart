import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PagoScreen extends StatefulWidget {
  final int userId;

  const PagoScreen({super.key, required this.userId});

  @override
  _PagoScreenState createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  String _metodoPago = 'PayPal';
  String _metodoEnvio = 'Domicilio';
  String _direccionTienda = '';
  final _direccionController = TextEditingController();
  final _codigoPostalController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _pisoYLetraController = TextEditingController();

  List<String> tiendas = [
    'Calle Calle 123',
    'Av. Bajo la Lluvia 742',
    'Calle Miranda 456'
  ];

  bool _validarCampos() {
    if (_metodoEnvio == 'Domicilio') {
      return _direccionController.text.isNotEmpty &&
          _codigoPostalController.text.isNotEmpty &&
          _provinciaController.text.isNotEmpty &&
          _ciudadController.text.isNotEmpty &&
          _pisoYLetraController.text.isNotEmpty;
    } else if (_metodoEnvio == 'Tienda') {
      return _direccionTienda.isNotEmpty;
    }
    return false;
  }

  Future<void> _registrarCompra() async {
    try {
      if (!_validarCampos()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Por favor complete todos los campos obligatorios.')),
        );
        return;
      }

      final String fechaCompra = DateTime.now().toIso8601String();
      final double total = 100.0; 

      final Map<String, dynamic> body = {
        'user_id': widget.userId.toString(),
        'metodo_pago': _metodoPago,
        'metodo_envio': _metodoEnvio,
        'direccion': _metodoEnvio == 'Domicilio'
            ? '${_direccionController.text}, Piso: ${_pisoYLetraController.text}, CP: ${_codigoPostalController.text}, ${_ciudadController.text}, ${_provinciaController.text}'
            : '',
        'direccion_tienda': _metodoEnvio == 'Tienda' ? _direccionTienda : '',
        'fecha_compra': fechaCompra,
        'total': total,
      };

      final url = Uri.parse(
          'http://127.0.0.1/clothes_app_php/auth/registrar_compra.php');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Respuesta del servidor: ${response.body}');
      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ThankYouScreen(),
          ),
        );
      } else {
        throw Exception('Error al registrar la compra: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Método de Pago')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seleccione el método de pago:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RadioListTile(
              title: Text('PayPal'),
              value: 'PayPal',
              groupValue: _metodoPago,
              onChanged: (value) {
                setState(() {
                  _metodoPago = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('Tarjeta de Crédito'),
              value: 'Tarjeta de Crédito',
              groupValue: _metodoPago,
              onChanged: (value) {
                setState(() {
                  _metodoPago = value!;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Seleccione el método de envío:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RadioListTile(
              title: Text('Envío a domicilio'),
              value: 'Domicilio',
              groupValue: _metodoEnvio,
              onChanged: (value) {
                setState(() {
                  _metodoEnvio = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('Recogida en tienda'),
              value: 'Tienda',
              groupValue: _metodoEnvio,
              onChanged: (value) {
                setState(() {
                  _metodoEnvio = value!;
                  _direccionTienda = tiendas.first;
                });
              },
            ),
            SizedBox(height: 20),
            if (_metodoEnvio == 'Domicilio') ...[
              TextField(
                controller: _direccionController,
                decoration: InputDecoration(labelText: 'Calle y número'),
              ),
              TextField(
                controller: _pisoYLetraController,
                decoration: InputDecoration(labelText: 'Piso y letra'),
              ),
              TextField(
                controller: _codigoPostalController,
                decoration: InputDecoration(labelText: 'Código Postal'),
              ),
              TextField(
                controller: _provinciaController,
                decoration: InputDecoration(labelText: 'Provincia'),
              ),
              TextField(
                controller: _ciudadController,
                decoration: InputDecoration(labelText: 'Ciudad'),
              ),
            ] else if (_metodoEnvio == 'Tienda') ...[
              DropdownButtonFormField<String>(
                value: _direccionTienda,
                items: tiendas.map((String tienda) {
                  return DropdownMenuItem<String>(
                    value: tienda,
                    child: Text(tienda),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _direccionTienda = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Seleccione la tienda'),
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registrarCompra,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.black,
              ),
              child: Text(
                'Confirmar compra',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/productos');
    });

    return Scaffold(
      body: Center(
        child: Text(
          'Gracias por tu compra',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
