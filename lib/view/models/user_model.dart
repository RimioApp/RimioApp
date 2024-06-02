import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  final String userId, userName, userLastName, displayName, phone, location, userImage, userEmail;
  final String? password;
  final Timestamp createdAt;
  final List userWish;
  final List? userVenta;
  final List? userPublish;
  final int points;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userLastName,
    required this.displayName,
    required this.phone,
    required this.location,
    this.password,
    this.userVenta,
    this.userPublish,
    required this.userImage,
    required this.userEmail,
    required this.createdAt,
    required this.userWish,
    required this.points});

}