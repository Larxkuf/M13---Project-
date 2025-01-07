import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final String style;
  final int currentIndex;

  const BottomNavBar({
    super.key,
    required this.style,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color selectedItemColor;
    Color unselectedItemColor;

    if (style == 'gyaru') {
      backgroundColor = Colors.black;
      selectedItemColor = const Color.fromARGB(255, 42, 21, 177);
      unselectedItemColor = const Color.fromARGB(255, 255, 255, 255);
    } else if (style == 'star') {
      selectedItemColor = const Color.fromARGB(255, 255, 222, 4);
      unselectedItemColor = const Color.fromARGB(255, 255, 255, 255);
      backgroundColor = Colors.black;
    } else {
      backgroundColor = const Color.fromARGB(0, 0, 0, 0);
      selectedItemColor = const Color.fromARGB(0, 0, 0, 0);
      unselectedItemColor = const Color.fromARGB(179, 13, 0, 255);
    }

    return BottomNavigationBar(
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Transform.translate(
            offset: const Offset(0, 8),
            child: Icon(
              Icons.home,
              color:
                  currentIndex == 0 ? selectedItemColor : unselectedItemColor,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Transform.translate(
            offset: const Offset(0, 8),
            child: Icon(
              Icons.favorite,
              color:
                  currentIndex == 1 ? selectedItemColor : unselectedItemColor,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Transform.translate(
            offset: const Offset(0, 8),
            child: Icon(
              Icons.star,
              color:
                  currentIndex == 2 ? selectedItemColor : unselectedItemColor,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Transform.translate(
            offset: const Offset(0, 8),
            child: Icon(
              Icons.shopping_cart,
              color:
                  currentIndex == 3 ? selectedItemColor : unselectedItemColor,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Transform.translate(
            offset: const Offset(0, 8),
            child: Icon(
              Icons.account_circle,
              color:
                  currentIndex == 4 ? selectedItemColor : unselectedItemColor,
            ),
          ),
          label: '',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/favoritos');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/productos');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/carrito');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/perfil');
            break;
        }
      },
    );
  }
}
