import 'package:flutter/material.dart';

class SobreNosotrosScreen extends StatelessWidget {
  const SobreNosotrosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: Text('Sobre Nosotros'),
        backgroundColor: const Color.fromARGB(255, 224, 227, 229),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenido a UrbanCircuit',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 16),
              Text(
                '¿Quiénes somos?',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 8),
              Text(
                'UrbanCircuit es una marca joven y dinámica que se dedica a ofrecer productos de alta calidad para los amantes del estilo urbano. Nos especializamos en ropa, accesorios y tecnología, con un enfoque en la innovación y el diseño.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 16),
              Text(
                'Nuestra Misión',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 8),
              Text(
                'Ofrecer productos de vanguardia que inspiren confianza y estilo en cada uno de nuestros clientes. Nuestro objetivo es transformar la forma en que las personas se visten, sienten y se expresan a través de nuestros productos.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 16),
              Text(
                'Nuestros Valores',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 8),
              Text(
                '- Innovación\n- Calidad\n- Compromiso con el cliente\n- Estilo único\n- Sostenibilidad',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 16),
              Text(
                'Contáctanos',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 8),
              Text(
                'Si deseas saber más sobre nuestros productos o cualquier consulta, no dudes en ponerte en contacto con nosotros a través de nuestro formulario de contacto.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
