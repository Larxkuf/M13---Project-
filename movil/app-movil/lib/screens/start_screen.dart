import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color.fromARGB(255, 28, 28, 28),
          ),
          Positioned(
            top: 60, 
            right: 40, 
            bottom: 50, 
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 6,
                  height: 820,
                  color: Color.fromARGB(194, 53, 45, 212),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .start, 
                    crossAxisAlignment: CrossAxisAlignment
                        .center, 
                    mainAxisSize: MainAxisSize
                        .min, 
                    children: [
                      Transform.translate(
                        offset: Offset(0, -20),
                        child: Text(
                          'U',
                          style: GoogleFonts.ptSerif(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -65),
                        child: Text(
                          'r',
                          style: GoogleFonts.ptSerif(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -100),
                        child: Text(
                          'b',
                          style: GoogleFonts.ptSerif(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -142),
                        child: Text(
                          'a',
                          style: GoogleFonts.ptSerif(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -180),
                        child: Text(
                          'n',
                          style: GoogleFonts.ptSerif(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -205),
                        child: Text(
                          'C',
                          style: GoogleFonts.ptSerif(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -235),
                        child: Text(
                          'i',
                          style: GoogleFonts.ptSerif(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -285),
                        child: Text(
                          'r',
                          style: GoogleFonts.ptSerif(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -330),
                        child: Text(
                          'c',
                          style: GoogleFonts.ptSerif(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -370),
                        child: Text(
                          'u',
                          style: GoogleFonts.ptSerif(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -400),
                        child: Text(
                          'i',
                          style: GoogleFonts.ptSerif(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -440),
                        child: Text(
                          't',
                          style: GoogleFonts.ptSerif(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -60),
                        child: Text(
                          'E',
                          style: GoogleFonts.ptSerif(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -60),
                        child: Text(
                          't',
                          style: GoogleFonts.ptSerif(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    shape: BoxShape.rectangle,
                  ),
                  child: Center(
                    child: Text(
                      '>',
                      style: TextStyle(
                        fontSize: 40,
                        color: Color.fromARGB(255, 71, 79, 222),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
