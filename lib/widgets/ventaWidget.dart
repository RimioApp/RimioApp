import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/providers/venta_provider.dart';
import 'package:Rimio/providers/vistoReciente_provider.dart';
import 'package:Rimio/view/models/product_model.dart';
import 'package:Rimio/view/models/venta_model.dart';
import 'package:Rimio/view/productDetails.dart';
import 'package:Rimio/view/searchPage.dart';
import 'package:Rimio/widgets/customButton.dart';
import 'package:Rimio/widgets/fav_button.dart';
import 'package:Rimio/widgets/itemTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VentaWidget extends StatefulWidget {
  const VentaWidget({super.key, required this.productId, required VentaModel,});

  final String productId;


  @override
  State<VentaWidget> createState() => _VentaWidgetState();
}

class _VentaWidgetState extends State<VentaWidget> {

  final _auth = FirebaseAuth.instance;
  final usersVentaDb = FirebaseFirestore.instance.collection("users");
  final Map<String, VentaModel> _userVentaItems = {};
  Map<String,  VentaModel> get getUserVenta {
    return _userVentaItems;
  }

  @override
  Widget build(BuildContext context) {

    // final productModelProvider = Provider.of<ProductModel>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productsProvider.findByProdId(widget.productId);

    return Column(
      children: [
        ListTile(
          leading: Image.network(getCurrentProduct!.productImage1),
          title: Text(getCurrentProduct.productTitle),
          subtitle: Text('ID: ${getCurrentProduct.productId}'),
          trailing: Text('\$${getCurrentProduct.productPrice}'),
        ),
      ],
    );
  }
}
