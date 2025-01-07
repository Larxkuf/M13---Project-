import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/start_screen.dart';
import 'screens/productos_por_categoria.dart'; 
import 'screens/favoritos_screen.dart';
import 'screens/productos_screen.dart';
import 'screens/producto_detalle_screen.dart'; 
import 'screens/cesta_screen.dart';
import 'screens/pago_screen.dart'; 
import 'screens/user_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clothes App',
      initialRoute: '/start', 
      routes: {
        '/start': (context) => const StartScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/favoritos': (context) => const FavoritosScreen(),
        '/productos': (context) => const ProductosScreen(),
        '/carrito': (context) {
          final userId =
              1;
          return CestaScreen(userId: userId);
        },
        '/productosPorCategoria': (context) {
          final Map<String, String> args =
              ModalRoute.of(context)?.settings.arguments as Map<String, String>;
          return ProductosPorCategoriaPage(
            categoriaId: args['categoriaId']!,
            categoriaNombre: args['categoriaNombre']!,
          );
        },
        '/productoDetalle': (context) {
          final productId = ModalRoute.of(context)?.settings.arguments as int?;
          if (productId == null) {
            return Scaffold(
              body: Center(child: Text('Error: ID del producto no encontrado')),
            );
          }
          return ProductoDetalleScreen(productId: productId);
        },
        '/pago': (context) {
          final userId = ModalRoute.of(context)?.settings.arguments as int?;
          if (userId == null) {
            return Scaffold(
              body: Center(child: Text('Error: ID del usuario no encontrado')),
            );
          }
          return PagoScreen(userId: userId);
        },
        '/perfil': (context) =>
            const UserScreen(), 
      },
    );
  }
}
