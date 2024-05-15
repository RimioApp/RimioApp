import 'package:Rimio/widgets/bottomCheckOut.dart';
import 'package:Rimio/widgets/cartWidget.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  final isEmpty = false;

  @override
  Widget build(BuildContext context) {
    return isEmpty? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        shadowColor: Colors.purpleAccent,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_rounded, color: Colors.white,)),
        title: const Text('Tu Carrito', style: TextStyle(color: Colors.white),),
      ),
      body: const Center(
        child: Text('Sin artículos', style: TextStyle(fontSize: 22, color: Colors.deepPurple),),
      ),
    ) : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 5,
        shadowColor: Colors.purpleAccent,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_rounded, color: Colors.white,)),
        title: const Text('Tu Carrito (6)', style: TextStyle(color: Colors.white),),
        actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.delete_rounded, color: Colors.white,))],
      ),
      body: ListView.builder(
        itemCount: 6,
          itemBuilder: (context, index){
          return const CartWidget();
      }),
      bottomSheet: const BottomCheckOut(),
    );
  }
}
