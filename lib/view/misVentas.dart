import 'package:Rimio/providers/venta_provider.dart';
import 'package:Rimio/widgets/ventaWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MisVentas extends StatelessWidget {
  const MisVentas({super.key});

  final isEmpty = false;

  @override
  Widget build(BuildContext context) {

    final ventaProvider = Provider.of<VentaProvider>(context);

    return ventaProvider.getUserVenta.isEmpty
        ? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        shadowColor: Colors.purpleAccent,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_rounded, color: Colors.white,)),
        title: const Text('Mis Ventas', style: TextStyle(color: Colors.white),),
      ),
      body: const Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sin artículos vendidos', style: TextStyle(fontSize: 22, color: Colors.deepPurple),),
            SizedBox(height: 10,),
          ],
        ),
      ),
    ) : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 5,
        shadowColor: Colors.purpleAccent,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_rounded, color: Colors.white,)),
        title: Text('Mis Ventas (${ventaProvider.getUserVenta.length})', style: const TextStyle(color: Colors.white),),
      ),
      body: ListView.separated(
        itemCount: ventaProvider.getUserVenta.length,
        itemBuilder: (BuildContext context, int index) {
          return VentaWidget(
            productId: ventaProvider.getUserVenta.values.toList()[index].productId,
            VentaModel: null,);},
        separatorBuilder: (BuildContext context, int index) {return const Divider();},
      ),
    );
  }
}

