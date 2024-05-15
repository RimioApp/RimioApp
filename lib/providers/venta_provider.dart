import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/view/authPages/login.dart';
import 'package:Rimio/view/authPages/registro.dart';
import 'package:Rimio/view/models/favoritos_model.dart';
import 'package:Rimio/view/models/venta_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class VentaProvider with ChangeNotifier {
  final Map<String, VentaModel> _userVentaItems = {};
  Map<String,  VentaModel> get getUserVenta {
    return _userVentaItems;
  }

  final usersVentaDb = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;
// Firebase
  Future<void> addToUserVentaListFirebase({
    required String productId,
    required BuildContext context,
    required String userId,
    required String? displayName,
    required String? userEmail,
    required Timestamp? ventaTime,
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
      await usersVentaDb.doc(userId).update({
        'userVenta': FieldValue.arrayUnion([
          {
            'ventaId': orderId,
            'productId': productId,
            'userId': uid,
            'displayName': displayName,
            'userEmail': userEmail,
            'ventaTime': ventaTime,
          }
        ])
      });
      print(userId);
      await fetchUserVentalist();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchUserVentalist() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      _userVentaItems.clear();
      return;
    }
    try {
      final userDoc = await usersVentaDb.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey('userVenta')) {
        return;
      }
      final length = userDoc.get("userVenta").length;
      for (int index = 0; index < length; index++) {
        _userVentaItems.putIfAbsent(
            userDoc.get("userVenta")[index]['productId'],
                () => VentaModel(
                  ventaId: userDoc.get("userVenta")[index]['ventaId'],
                  productId: userDoc.get("userVenta")[index]['productId'],
                  userId: '',
                  productName: '',
                  productImage1: '',
                  productPrice: '',
                  ventaTime: Timestamp.now(),
                  userName: '',
                  displayName: '',
                  userEmail: '',
            ));
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
