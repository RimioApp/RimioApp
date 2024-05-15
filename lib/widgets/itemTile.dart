import 'package:Rimio/providers/favoritos_provider.dart';
import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/providers/vistoReciente_provider.dart';
import 'package:Rimio/view/models/product_model.dart';
import 'package:Rimio/view/productDetails.dart';
import 'package:Rimio/widgets/customButton.dart';
import 'package:Rimio/widgets/fav_button.dart';
import 'package:Rimio/widgets/productWidget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class itemTile extends StatelessWidget {
  itemTile({
    super.key,
  });

  bool fav = false;

  late String textToShare;
  late String imageUrl;


  Future<void> shareToWhatsApp(String text, String imageUrl) async {
    final String whatsAppUrl = 'whatsapp://send?text=$text&source=$imageUrl&data=$imageUrl';

    try {
      await launch(whatsAppUrl);
    } catch (e) {
      print('Could not launch $whatsAppUrl');
    }
  }

  @override
  Widget build(BuildContext context) {

    final productsModel = Provider.of<ProductModel>(context);
    final favoritosProvider = Provider.of<FavoritosProvider>(context);
    final vistoRecienteProvider = Provider.of<VistoRecienteProvider>(context);

    return productsModel.publicar == false
        ? const SizedBox.shrink()
        : Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          height: 300,
          width: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 2,
                  color: Colors.grey
              )
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 180,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: (){
                        vistoRecienteProvider.addToVistolistFirebase(productId: productsModel.productId, context: context);
                        Navigator.pushNamed(context, ProductDetails.routeName, arguments: productsModel.productId);
                      },
                      child: FancyShimmerImage(
                        boxFit: BoxFit.contain,
                          height: double.maxFinite,
                          width: double.maxFinite,
                          imageUrl: productsModel.productImage1),
                    ),
                    FavButton(productId: productsModel.productId, size: 25,  bkgColor: Colors.white,),
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

                                  await Share.share('${productsModel.productImage1}\n¡No te pierdas esta oferta de *${productsModel.productTitle}* a *\$${productsModel.productPrice}*, Solo en *Rimio*, '
                                      '¡Descarga la App YA! o ingresa al siguiente enlace https://rimiosite.web.app');

                                  // await shareToWhatsApp(
                                  //   '¡No te pierdas esta oferta de *${getCurrentProduct.productTitle}* a *\$${getCurrentProduct.productPrice}*, Solo en *Rimio*, ¡Descarga la App YA!',
                                  //     getCurrentProduct.productImage1);
                                }
                                , icon: const Icon(Icons.share))),
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
                    Flexible(child: Text(productsModel.productTitle, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600),)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        alignment: const Alignment(0,0),
                        height: 20,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text(productsModel.productState, style: const TextStyle(color: Colors.white),)),
                    Row(
                      children: [
                        const Icon(Icons.location_pin, size: 15, color: Colors.deepPurple,),
                        Text(productsModel.userLocation),
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
                    Text(productsModel.servicio ? '\$${productsModel.productPrice}':'\$${productsModel.productPrice}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.red),),
                    SizedBox(
                        child:
                        CustomButton(
                            onTap: () async {
                              await showDialog(context: context, builder: (context){
                                return AlertDialog(
                                  title: Text(productsModel.productTitle),
                                  content: Text(productsModel.productDescription),
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
                            colorShadow: Colors.grey)/*Material(
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
          )
      ),
    );
  }
}