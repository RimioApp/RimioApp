import 'package:Rimio/providers/vistoReciente_provider.dart';
import 'package:Rimio/widgets/productWidget.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VistosReciente extends StatelessWidget {
  const VistosReciente({super.key});

  final isEmpty = false;

  @override
  Widget build(BuildContext context) {

    final vistoRecienteProvider = Provider.of<VistoRecienteProvider>(context);

    return vistoRecienteProvider.getVisto.isEmpty
        ? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        shadowColor: Colors.purpleAccent,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_rounded, color: Colors.white,)),
        title: const Text('Vistos Recientemente', style: TextStyle(color: Colors.white),),
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
        title: Text('Vistos Recientemente (${vistoRecienteProvider.getVisto.length})', style: const TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 8, left: 8),
        child: DynamicHeightGridView(
          itemCount: vistoRecienteProvider.getVisto.length,
          crossAxisCount: 2,
          builder: (context, index){
            return ProductWidget(productId: vistoRecienteProvider.getVisto.values.toList()[index].productId,);
          },
        ),
      ),
    );
  }
}
