import 'package:Rimio/view/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {

  UserModel? userModel;
  UserModel? get getUserModel {
    return userModel;
  }

  Future<UserModel?> fetchUserInfo() async {

    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null){
      return null;
    }
    String uid = user.uid;
    try{
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final userDocDict = userDoc.data() as Map<String, dynamic>?;

      userModel = UserModel(
          userId: userDoc.get('userId'),
          userName: userDoc.get('userName'),
          userLastName: userDoc.get('userLastName'),
          displayName: userDoc.get('displayName'),
          phone: userDoc.get('phone'),
          location: userDoc.get('location'),
          userImage: userDoc.get('userImage'),
          userEmail: userDoc.get('userEmail'),
          createdAt: userDoc.get('createdAt'),
          points: userDoc.get('points'),
          userWish: userDocDict!.containsKey("userWish") ? userDoc.get("userWish") : [],);
      return userModel;
    } on FirebaseException catch(e){
      rethrow;
    }catch(e){
      rethrow;
    }
  }
}