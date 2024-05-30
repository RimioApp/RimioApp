import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinkProvider {
  Future<String> createLink(refCode) async {
    final String url = "https://com.rimiomusic.rimio?ref=$refCode";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
        link: Uri.parse(url),
        androidParameters: const AndroidParameters(
            packageName: "com.rimiomusic.rimio", minimumVersion: 0),
        uriPrefix: 'https://rimio.page.link');

    final FirebaseDynamicLinks link = await FirebaseDynamicLinks.instance;

    final refLink = await link.buildShortLink(parameters);

    return refLink.shortUrl.toString();
  }

  ///init Dynamic Link
  void initDynamicLink(BuildContext context) async {
    final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (instanceLink != null) {
      final Uri refLink = instanceLink.link;

      // Share.share("this is the link ${refLink.data.toString()}");
    }

    FirebaseDynamicLinks.instance.onLink.listen((event) {
      String query = event.link.query.toString().replaceAll("ref=", "");

      String decodedData = utf8.decode(base64Decode(query));
      var map = jsonDecode(decodedData);
      //{\"\":\"/ProductDetails\",\"\":\"f2c97d8d-44b0-4b25-b97e-88b18fbf750b\"}
      String routeName = map['routeName'];
      String productId = map['productId'];

      Future.delayed(const Duration(seconds: 2)).then((value) {
        Navigator.pushNamed(context, routeName, arguments: productId);
      });

      print("Decoded String: $decodedData");
    });
  }
}
