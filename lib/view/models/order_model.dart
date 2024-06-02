import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrdersModel with ChangeNotifier {
  final String orderId;
  final String userId;
  final String productId;
  final String productName;
  final String productImage1;
  final String productPrice;
  final Timestamp orderTime;

  OrdersModel(
      {required this.orderId,
        required this.userId,
        required this.productId,
        required this.productName,
        required this.productImage1,
        required this.productPrice,
        required this.orderTime});

  factory OrdersModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return OrdersModel(
      productId: data["productId"],
      productName: data['productName'],
      productImage1: data['productImage'],
      productPrice: data['productPrice'],
      orderId: data['orderId'],
      userId: data['userID'],
      orderTime: data['orderTime'],
    );
  }
}
