import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/view/authPages/login.dart';
import 'package:Rimio/view/authPages/registro.dart';
import 'package:Rimio/view/models/favoritos_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FavoritosProvider with ChangeNotifier {
  final Map<String, FavoritosModel> _favoritosItems = {};
  Map<String, FavoritosModel> get getFavoritos {
    return _favoritosItems;
  }

  final userstDb = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;
// Firebase
  Future<void> addToWishlistFirebase({
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
    final favoritosId = const Uuid().v4();
    try {
      await userstDb.doc(uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            'favoritosId': favoritosId,
            'productId': productId,
          }
        ])
      });
      await fetchWishlist();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchWishlist() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      _favoritosItems.clear();
      return;
    }
    try {
      final userDoc = await userstDb.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey('userWish')) {
        return;
      }
      final length = userDoc.get("userWish").length;
      for (int index = 0; index < length; index++) {
        _favoritosItems.putIfAbsent(
          userDoc.get("userWish")[index]['productId'],
              () => FavoritosModel(
              favoritosId: userDoc.get("userWish")[index]['favoritosId'],
              productId: userDoc.get("userWish")[index]['productId'],
        ));
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeWishlistItemFromFirestore({
    required String favoritosId,
    required String productId,

  }) async {
    final User? user = _auth.currentUser;
    try {
      await userstDb.doc(user!.uid).update({
        'userWish': FieldValue.arrayRemove([
          {
            'favoritosId': favoritosId,
            'productId': productId,
          }
        ])
      });
      // await fetchCart();
      _favoritosItems.remove(productId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearWishlistFromFirebase() async {
    final User? user = _auth.currentUser;
    try {
      await userstDb.doc(user!.uid).update({
        'userWish': [],
      });
      // await fetchCart();
      _favoritosItems.clear();
    } catch (e) {
      rethrow;
    }
  }


  void addOrRemoveFromFavoritos({required String productId}) {
    if (_favoritosItems.containsKey(productId)){
     _favoritosItems.remove(productId);
    }else{
      _favoritosItems.putIfAbsent(
          productId,
              () => FavoritosModel(favoritosId: const Uuid().v4(), productId: productId)
      );
    }
    notifyListeners();
  }

  bool isProdinFav({required String productId}) {
    return _favoritosItems.containsKey(productId);
  }

  void clearLocalFav() {
    _favoritosItems.clear();
    notifyListeners();
  }

  void removeOneItem({required String productId}) {
    _favoritosItems.remove(productId);
    notifyListeners();
  }
}
