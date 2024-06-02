import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/view/authPages/login.dart';
import 'package:Rimio/view/models/favoritos_model.dart';
import 'package:Rimio/view/models/vistoReciente_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class VistoRecienteProvider with ChangeNotifier {
  final Map<String, VistoRecienteModel> _vistoItems = {};
  Map<String, VistoRecienteModel> get getVisto {
    return _vistoItems;
  }

  void addVistoReciente({required String productId}) {

    _vistoItems.putIfAbsent(
        productId,
            () => VistoRecienteModel(vistoId: const Uuid().v4(), productId: productId)
    );

    notifyListeners();
  }

  final userstDb = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;
// Firebase
  Future<void> addToVistolistFirebase({
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
    final vistoID = const Uuid().v4();
    try {
      await userstDb.doc(uid).update({
        'userVisto': FieldValue.arrayUnion([
          {
            'vistoId': vistoID,
            'productId': productId,
          }
        ])
      });
      await fetchVistolist();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchVistolist() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      _vistoItems.clear();
      return;
    }
    try {
      final userDoc = await userstDb.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey('userVisto')) {
        return;
      }
      final length = userDoc.get("userVisto").length;
      for (int index = 0; index < length; index++) {
        _vistoItems.putIfAbsent(
            userDoc.get("userVisto")[index]['productId'],
                () => VistoRecienteModel(
              vistoId: userDoc.get("userVisto")[index]['vistoId'],
              productId: userDoc.get("userVisto")[index]['productId'],
            ));
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> clearVistoFromFirebase() async {
    final User? user = _auth.currentUser;
    try {
      await userstDb.doc(user!.uid).update({
        'userVisto': [],
      });
      // await fetchCart();
      _vistoItems.clear();
    } catch (e) {
      rethrow;
    }
  }


  bool isProdinVisto({required String productId}) {
    return _vistoItems.containsKey(productId);
  }

  void clearLocalVisto() {
    _vistoItems.clear();
    notifyListeners();
  }

  void removeOneVisto({required String productId}) {
    _vistoItems.remove(productId);
    notifyListeners();
  }
}
