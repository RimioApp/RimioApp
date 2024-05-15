import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/view/authPages/login.dart';
import 'package:Rimio/view/authPages/registro.dart';
import 'package:Rimio/view/models/favoritos_model.dart';
import 'package:Rimio/view/models/order_model.dart';
import 'package:Rimio/view/models/userOrders_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class OrderProvider with ChangeNotifier {
  final Map<String, OrdersModel> _userOrdersItems = {};
  Map<String,  OrdersModel> get getUserOrders {
    return _userOrdersItems;
  }

  final usersOrdersDb = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;
// Firebase
  Future<void> addToUserOrdersListFirebase({
    required String productId,
    required BuildContext context,
  }) async {

    final User? user = _auth.currentUser;
    if (user == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return Login();
      }));
      return;
    }
    final uid = user.uid;
    final orderId = const Uuid().v4();
    try {
      await usersOrdersDb.doc(uid).update({
        'userOrders': FieldValue.arrayUnion([
          {
            'orderId': orderId,
            'productId': productId,
          }
        ])
      });
      await fetchUserOrderslist();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchUserOrderslist() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      _userOrdersItems.clear();
      return;
    }
    try {
      final userDoc = await usersOrdersDb.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey('userOrders')) {
        return;
      }
      final length = userDoc.get("userOrders").length;
      for (int index = 0; index < length; index++) {
        _userOrdersItems.putIfAbsent(
            userDoc.get("userOrders")[index]['productId'],
                () => OrdersModel(
              orderId: userDoc.get("userOrders")[index]['orderId'],
              productId: userDoc.get("userOrders")[index]['productId'],
                  userId: '',
                  productName: '',
                  productImage1: '',
                  productPrice: '',
                  orderTime: Timestamp.now(),
            ));
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
