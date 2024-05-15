import 'package:Rimio/providers/favoritos_provider.dart';
import 'package:Rimio/providers/publish_provider.dart';
import 'package:Rimio/view/models/product_model.dart';
import 'package:Rimio/view/publicarItem/editOrUploadProductScreen.dart';
import 'package:Rimio/view/searchPage.dart';
import 'package:Rimio/widgets/bottomCheckOut.dart';
import 'package:Rimio/widgets/cartWidget.dart';
import 'package:Rimio/widgets/customButton.dart';
import 'package:Rimio/widgets/productWidget.dart';
import 'package:Rimio/widgets/publish_widget.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MisPublicaciones extends StatelessWidget {
  const MisPublicaciones({super.key});

  final isEmpty = false;

  @override
  Widget build(BuildContext context) {

    final publishProvider = Provider.of<PublishProvider>(context);

    return publishProvider.getUserPublish.isEmpty
        ? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        shadowColor: Colors.purpleAccent,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_rounded, color: Colors.white,)),
        title: const Text('Mis Publicaciones', style: TextStyle(color: Colors.white),),
      ),
      body: const Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sin artículos', style: TextStyle(fontSize: 22, color: Colors.deepPurple),),
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
        title: Text('Mis Publicaciones (${publishProvider.getUserPublish.length})', style: const TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 8, left: 8),
        child: DynamicHeightGridView(
          itemCount: publishProvider.getUserPublish.length,
          crossAxisCount: 2,
          builder: (context, index){
            return PublishWidget(productId: publishProvider.getUserPublish.values.toList()[index].productId,);
          },
        ),
      ),
    );
  }
}

