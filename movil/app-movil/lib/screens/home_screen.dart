import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'bottom_nav_bar.dart'; 
import 'productos_por_categoria.dart';
import 'sobre_nosotros.dart';
import 'colecciones_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> colecciones = [];
  List<dynamic> categorias = [];
  List<dynamic> productos = [];
  List<dynamic> productosFiltrados = [];
  List<dynamic> promociones = []; 
  final PageController _pageControllerColecciones = PageController();
  final PageController _pageControllerCategorias = PageController(
    viewportFraction: 0.33, 
  );

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    const String url =
        'http://127.0.0.1/clothes_app_php/api.php'; 
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final List<String> coleccionesFiltradas = [
          'TechY',
          'MachineShoes',
          'Future'
        ];
        setState(() {
          colecciones = (data['colecciones'] ?? [])
              .where((coleccion) =>
                  coleccionesFiltradas.contains(coleccion['nombre']))
              .toList();

          productos = data['productos'] ?? [];
          productosFiltrados =
              productos; 
          categorias = data['categorias'] ?? []; 
          promociones = data['promociones'] ?? []; 
        });
      } else {
        _showErrorSnackbar('Error al cargar los datos del servidor');
      }
    } catch (e) {
      _showErrorSnackbar('Error al conectar con el servidor');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Color _getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  Widget _buildColeccionesCarousel() {
    return colecciones.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            height: 760, 
            child: PageView.builder(
              controller: _pageControllerColecciones,
              itemCount: colecciones.length,
              itemBuilder: (context, index) {
                final coleccion = colecciones[index];
                return GestureDetector(
                  onTap: () {
                    int coleccionId = int.parse(coleccion['id']
                        .toString()); 
                    print('Navegando a colección: ${coleccion['nombre']}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ColeccionesScreen(
                          coleccionId: coleccionId, 
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          coleccion['imagen'].startsWith('http')
                              ? coleccion[
                                  'imagen'] 
                              : 'http://127.0.0.1/clothes_app_php/images/${coleccion['imagen']}', 
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            Color errorColor = _getRandomColor();
                            return Container(
                              color: errorColor,
                              child: const Center(
                                child: Icon(Icons.error,
                                    size: 50, color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }

  Widget _buildCategoriasCarousel() {
    return categorias.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            height: 200, 
            child: PageView.builder(
              controller: _pageControllerCategorias,
              itemCount: categorias.length,
              physics:
                  const ClampingScrollPhysics(),
              padEnds: false, 
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductosPorCategoriaPage(
                          categoriaId: categoria['id'].toString(),
                          categoriaNombre: categoria['nombre'],
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        child: Image.network(
                          categoria['imagen'].startsWith('http')
                              ? categoria['imagen']
                              : 'http://127.0.0.1/clothes_app_php/images/${categoria['imagen']}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double
                              .infinity, 
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey,
                              child: const Center(
                                child: Icon(Icons.error,
                                    size: 50, color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.black
                              .withOpacity(0.5),
                          child: Text(
                            categoria['nombre'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.white, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: Icon(Icons.help_outline, color: Colors.black),
            title: const Text(
              'Ayuda',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Ayuda'),
                    content: Text('Lo siento, todavía no hay contenido.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cerrar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Divider(color: Colors.grey, thickness: 1),
          ListTile(
            leading: Icon(Icons.error_outline, color: Colors.black),
            title: const Text(
              'Sobre Nosotros',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SobreNosotrosScreen()),
              );
            },
          ),
          Divider(color: Colors.grey, thickness: 1),
          ListTile(
            leading: Icon(Icons.contact_page_outlined, color: Colors.black),
            title: const Text(
              'Contacto',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Información de Contacto'),
                    content: Text(
                      'Dirección: Avenida de los Álamos 54, Barcelona\nTeléfono: 544-88-59-87',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cerrar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Divider(color: Colors.grey, thickness: 1),
          const SizedBox(height: 20), 
          Container(
            color: Colors.grey[200], 
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0, 
                  runSpacing: 2.0,
                  children: [
                    GestureDetector(
                      onTap: () {
                      },
                      child: const Text(
                        'Términos y condiciones de compra',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const Text('·', style: TextStyle(color: Colors.black)),
                    GestureDetector(
                      onTap: () {
                      },
                      child: const Text(
                        'Política de privacidad',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const Text('·', style: TextStyle(color: Colors.black)),
                    GestureDetector(
                      onTap: () {
                      },
                      child: const Text(
                        'Política de cookies',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),  
          Center(
            child: Column(
              children: const [
                Text(
                  'UrbanCircuit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), 
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildColeccionesCarousel(),
            _buildCategoriasCarousel(),
            _buildFooter(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        style: 'gyaru',
        currentIndex: 0, 
      ),
    );
  }
}
