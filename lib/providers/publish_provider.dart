import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/view/authPages/login.dart';
import 'package:Rimio/view/authPages/registro.dart';
import 'package:Rimio/view/models/favoritos_model.dart';
import 'package:Rimio/view/models/publish_model.dart';
import 'package:Rimio/view/models/userOrders_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PublishProvider with ChangeNotifier {
  final Map<String, PublishModel> _userPublishItems = {};
  Map<String,  PublishModel> get getUserPublish {
    return _userPublishItems;
  }

  final usersPublishDb = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;
// Firebase
  Future<void> addToUserPublishListFirebase({
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
    final publishId = const Uuid().v4();
    try {
      await usersPublishDb.doc(uid).update({
        'userPublish': FieldValue.arrayUnion([
          {
            'publishId': publishId,
            'productId': productId,
          }
        ])
      });
      await fetchUserPublishlist();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeUserPublishItemFromFirestore({
    required String publishId,
    required String productId,

  }) async {
    final User? user = _auth.currentUser;
    try {
      await usersPublishDb.doc(user!.uid).update({
        'userPublish': FieldValue.arrayRemove([
          {
            'publishId': publishId,
            'productId': productId,
          }
        ])
      });
      _userPublishItems.remove(productId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchUserPublishlist() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      _userPublishItems.clear();
      return;
    }
    try {
      final userDoc = await usersPublishDb.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey('userPublish')) {
        return;
      }
      final length = userDoc.get("userPublish").length;
      for (int index = 0; index < length; index++) {
        _userPublishItems.putIfAbsent(
            userDoc.get("userPublish")[index]['productId'],
                () => PublishModel(
              publishId: userDoc.get("userPublish")[index]['publishId'],
              productId: userDoc.get("userPublish")[index]['productId'],
                  orderTime: Timestamp.now(),
            ));
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
