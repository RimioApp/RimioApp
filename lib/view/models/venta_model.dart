import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class VentaModel with ChangeNotifier {
  final String ventaId;
  final String userId;
  final String userName;
  final String displayName;
  final String userEmail;
  final String productId;
  final String productName;
  final String productImage1;
  final String productPrice;
  final Timestamp ventaTime;

  VentaModel(
      {required this.ventaId,
        required this.userId,
        required this.userName,
        required this.displayName,
        required this.userEmail,
        required this.productId,
        required this.productName,
        required this.productImage1,
        required this.productPrice,
        required this.ventaTime});

  factory VentaModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return VentaModel(
      productId: data["productId"],
      productName: data['productName'],
      productImage1: data['productImage'],
      productPrice: data['productPrice'],
      ventaId: data['orderId'],
      userId: data['userId'],
      userName: data['userName'],
      displayName: data['displayName'],
      userEmail: data['userEmail'],
      ventaTime: data['orderTime'],
    );
  }
}
