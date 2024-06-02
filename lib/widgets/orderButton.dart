import 'package:Rimio/providers/favoritos_provider.dart';
import 'package:Rimio/providers/order_provider.dart';
import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/view/models/favoritos_model.dart';
import 'package:Rimio/view/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    this.bkgColor = Colors.transparent,
    this.size = 20,
    required this.productId,

  });
  final Color bkgColor;
  final double size;
  final String productId;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

  @override
  Widget build(BuildContext context) {

    final orderProvider = Provider.of<OrderProvider>(context);

    return GestureDetector(
      onTap: () async {

      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: widget.bkgColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}