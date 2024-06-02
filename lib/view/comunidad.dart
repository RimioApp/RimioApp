import 'package:flutter/material.dart';

class Comunidad extends StatelessWidget {
  const Comunidad({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: const Center(
        child: Text('¡Próximamente!', style: TextStyle(fontSize: 30, color: Colors.white),),
      ),
    );
  }
}
