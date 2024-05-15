import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class VentaModel with ChangeNotifier {
  final String orderId;
  final String userId;
  final String productId;
  final String productName;
  final String productImage;
  final String productPrice;
  final Timestamp orderTime;

  VentaModel(
      {required this.orderId,
        required this.userId,
        required this.productId,
        required this.productName,
        required this.productImage,
        required this.productPrice,
        required this.orderTime});
}