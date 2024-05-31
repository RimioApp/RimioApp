import 'dart:convert';

import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/providers/vistoReciente_provider.dart';
import 'package:Rimio/view/productDetails.dart';
import 'package:Rimio/widgets/customButton.dart';
import 'package:Rimio/widgets/dynamic_link.dart';
import 'package:Rimio/widgets/fav_button.dart';
import 'package:Rimio/widgets/itemTile.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget(
      {super.key, required this.productId, this.isUserHistory = false});

  final String productId;
  final bool isUserHistory;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  late String textToShare;
  late String imageUrl;

  Future<void> shareToWhatsApp(String text, String imageUrl) async {
    final String whatsAppUrl =
        'whatsapp://send?text=$text&source=$imageUrl&data=$imageUrl';

    try {
      await launch(whatsAppUrl);
    } catch (e) {
      print('Could not launch $whatsAppUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final productModelProvider = Provider.of<ProductModel>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productsProvider.findByProdId(widget.productId);
    final vistoRecienteProvider = Provider.of<VistoRecienteProvider>(context);

    return getCurrentProduct!.publicar == false && !widget.isUserHistory
        ? const Padding(
            padding: EdgeInsets.all(50.0),
            child: Center(child: CircularProgressIndicator()),
          )
        : GestureDetector(
            onTap: () {
              vistoRecienteProvider.addToVistolistFirebase(
                  productId: getCurrentProduct.productId, context: context);
              Navigator.pushNamed(context, ProductDetails.routeName,
                  arguments: getCurrentProduct.productId);
            },
            child: Container(
              height: 300,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.grey)],
              ),
              child: Column(
                children: [
                  Container(
                    height: 180,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Stack(
                      children: [
                        FancyShimmerImage(
                            boxFit: BoxFit.contain,
                            height: double.maxFinite,
                            width: double.maxFinite,
                            imageUrl: getCurrentProduct.productImage1),
                        FavButton(
                          productId: getCurrentProduct.productId,
                          size: 25,
                          bkgColor: Colors.white,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                height: 35,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                    onPressed: () async {

                                      String routeName = ProductDetails.routeName.toString().trim();
                                      var body = {"routeName": routeName, "productId": getCurrentProduct.productId};
                                      var encodedStr = jsonEncode(body);
                                      String base64Encoded = base64Encode(utf8.encode(encodedStr));

                                      var link = await DynamicLinkProvider().createLink(base64Encoded);

                                      Share.share("¡No te pierdas esta oferta de *${getCurrentProduct.productTitle}* a *\$${getCurrentProduct.productPrice}*, Solo en *Rimio* ${link.toString()}");

                                      // await Share.share(
                                      // '${productsModel.productImage1}\n¡No te pierdas esta oferta de *${productsModel.productTitle}* a *\$${productsModel.productPrice}*, Solo en *Rimio*, '
                                      // '¡Descarga la App YA! o ingresa al siguiente enlace https://rimiosite.web.app');

                                      // await shareToWhatsApp(
                                      //   '¡No te pierdas esta oferta de *${getCurrentProduct.productTitle}* a *\$${getCurrentProduct.productPrice}*, Solo en *Rimio*, ¡Descarga la App YA!',
                                      //     getCurrentProduct.productImage1);
                                    },
                                    icon: const Icon(Icons.share))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        Flexible(
                            child: Text(
                          getCurrentProduct.productTitle,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            alignment: const Alignment(0, 0),
                            height: 20,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              getCurrentProduct.productState,
                              style: const TextStyle(
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis),
                            )),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_pin,
                              size: 15,
                              color: Colors.deepPurple,
                            ),
                            Text(getCurrentProduct.userLocation,
                                style: const TextStyle(
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getCurrentProduct.servicio
                              ? '\$${getCurrentProduct.productPrice}'
                              : '\$${getCurrentProduct.productPrice}',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.red),
                        ),
                        SizedBox(
                            child: CustomButton(
                                onTap: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              getCurrentProduct.productTitle),
                                          content: Text(getCurrentProduct
                                              .productDescription),
                                        );
                                      });
                                },
                                height: 38,
                                width: 80,
                                color: Colors.deepPurple,
                                radius: 8,
                                text: 'Detalles',
                                fontSize: 15,
                                textColor: Colors.white,
                                shadow: 2.5,
                                colorShadow: Colors
                                    .grey) /*Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              color: Colors.grey.shade100,
                              child: InkWell(
                                  onTap: (){},
                                  splashColor: Colors.deepPurpleAccent,
                                  borderRadius: BorderRadius.circular(4),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.add_shopping_cart_rounded, color: Colors.deepPurple,),
                                  ))),*/
                            ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
