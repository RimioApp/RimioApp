import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProductModel with ChangeNotifier{
  final String productId,
      userId,
      userEmail,
      displayName,
      userImage,
      userPhone,
      userLocation,
      productTitle,
      productPrice,
      productCategory,
      productState,
      productDescription,
      productImage1;
  final String? productImage2,
      productImage3,
      productImage4;
  int userPoints;
  bool servicio;
  Timestamp? createdAt;
  bool? publicar,
        vendido,
        calificado;


  ProductModel({
    required this.productId,
    required this.userId,
    required this.userEmail,
    required this.displayName,
    required this.userImage,
    required this.userPhone,
    required this.userLocation,
    required this.userPoints,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productState,
    required this.productDescription,
    required this.productImage1,
    this.productImage2,
    this.productImage3,
    this.productImage4,
    this.createdAt,
    this.publicar,
    required this.servicio,
    this.vendido,
    this.calificado,});

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    // data.containsKey("")
    return ProductModel(
      productId: data["productId"],
      userId: data["userId"],
      userEmail: data["userEmail"],
      displayName: data["displayName"],
      userImage: data["userImage"],
      userPhone: data['userPhone'],
      userLocation: data['userLocation'],
      userPoints: data['userPoints'],
      productTitle: data['productTitle'],
      productPrice: data['productPrice'],
      productCategory: data['productCategory'],
      productState: data['productState'],
      productDescription: data['productDescription'],
      productImage1: data['productImage1'],
      productImage2: data['productImage2'],
      productImage3: data['productImage3'],
      productImage4: data['productImage4'],
      createdAt: data['createdAt'],
      publicar: data['publicar'],
      servicio: data['servicio'],
      vendido: data['vendido'],
      calificado: data['calificado'],
    );
  }
}

