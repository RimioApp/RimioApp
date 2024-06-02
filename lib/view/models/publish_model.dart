import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PublishModel with ChangeNotifier {
  final String publishId;
  final String productId;
  final Timestamp orderTime;

  PublishModel(
      {required this.publishId,
        required this.productId,
        required this.orderTime});

  factory PublishModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return PublishModel(
      productId: data["productId"],
      publishId: data['publishId'],
      orderTime: data['orderTime'],
    );
  }
}
