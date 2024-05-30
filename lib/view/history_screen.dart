import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/productWidget.dart';
import 'models/product_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ProductModel> productList = [];

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      productList = await getUserProducts();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        shadowColor: Colors.purpleAccent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            )),
        title: const Text(
          'Historia',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: productList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 8, left: 8),
              child: DynamicHeightGridView(
                itemCount: productList.length,
                crossAxisCount: 2,
                builder: (context, index) {
                  return ProductWidget(
                    productId: productList[index].productId,
                    isUserHistory: true,
                  );
                },
              ),
            )
          : const Center(
              child: Text(
                'Sin artículos',
                style: TextStyle(fontSize: 22, color: Colors.deepPurple),
              ),
            ),
    );
  }

  Future<List<ProductModel>> getUserProducts() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var docs = await FirebaseFirestore.instance
        .collection("products")
        .where("userId", isEqualTo: userId)
        .get();

    List<ProductModel> modelList = [];

    for (int index = 0; index < docs.size; index++) {
      var value = docs.docs[index].data();
      ProductModel model = ProductModel.fromFirestore(docs.docs[index]);
      modelList.add(model);
    }
    print("");
    return modelList;
  }
}
