import 'package:Rimio/providers/order_provider.dart';
import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/providers/vistoReciente_provider.dart';
import 'package:Rimio/view/models/order_model.dart';
import 'package:Rimio/view/models/product_model.dart';
import 'package:Rimio/view/productDetails.dart';
import 'package:Rimio/view/searchPage.dart';
import 'package:Rimio/widgets/customButton.dart';
import 'package:Rimio/widgets/fav_button.dart';
import 'package:Rimio/widgets/itemTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key, required this.productId, required OrderModel,});

  final String productId;


  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {

    // final productModelProvider = Provider.of<ProductModel>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
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
