import 'package:Rimio/providers/order_provider.dart';
import 'package:Rimio/view/searchPage.dart';
import 'package:Rimio/widgets/customButton.dart';
import 'package:Rimio/widgets/orderWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MisCompras extends StatelessWidget {
  const MisCompras({super.key});

  final isEmpty = false;

  @override
  Widget build(BuildContext context) {

    final orderProvider = Provider.of<OrderProvider>(context);

    return orderProvider.getUserOrders.isEmpty
        ? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        shadowColor: Colors.purpleAccent,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_rounded, color: Colors.white,)),
        title: const Text('Mis Compras', style: TextStyle(color: Colors.white),),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sin artículos', style: TextStyle(fontSize: 22, color: Colors.deepPurple),),
            const SizedBox(height: 10,),
            CustomButton(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context){
                    return SearchPage();
                  }));
                },
                height: 50,
                width: 180,
                color: Colors.deepPurple,
                radius: 50,
                text: '¡Empieza YA!',
                fontSize: 20,
                textColor: Colors.white,
                shadow: 0,
                colorShadow: Colors.transparent),
          ],
        ),
      ),
    ) : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 5,
        shadowColor: Colors.purpleAccent,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_rounded, color: Colors.white,)),
        title: Text('Mis Compras (${orderProvider.getUserOrders.length})', style: TextStyle(color: Colors.white),),
      ),
      body: ListView.separated(
        itemCount: orderProvider.getUserOrders.length,
        itemBuilder: (BuildContext context, int index) {
          return OrderWidget(
            productId: orderProvider.getUserOrders.values.toList()[index].productId,
            OrderModel: orderProvider.getUserOrders.values.toList()[index].orderTime,
            );},
        separatorBuilder: (BuildContext context, int index) {return Divider();},
      ),
    );
  }
}

