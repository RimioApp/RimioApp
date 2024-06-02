import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/providers/publish_provider.dart';
import 'package:Rimio/providers/venta_provider.dart';
import 'package:Rimio/providers/vistoReciente_provider.dart';
import 'package:Rimio/view/models/product_model.dart';
import 'package:Rimio/view/productDetails.dart';
import 'package:Rimio/view/publicarItem/editOrUploadProductScreen.dart';
import 'package:Rimio/view/searchPage.dart';
import 'package:Rimio/widgets/customButton.dart';
import 'package:Rimio/widgets/fav_button.dart';
import 'package:Rimio/widgets/itemTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PublishWidget extends StatefulWidget {
  const PublishWidget({super.key, required this.productId,});

  final String productId;

  @override
  State<PublishWidget> createState() => _PublishWidgetState();
}

class _PublishWidgetState extends State<PublishWidget> {
  @override
  Widget build(BuildContext context) {

    final productsProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productsProvider.findByProdId(widget.productId);
    final publishProvider = Provider.of<PublishProvider>(context);

    Timestamp? stamp = getCurrentProduct!.createdAt;
    DateTime date = stamp!.toDate();

    return getCurrentProduct!.publicar == false
        ? GestureDetector(
      onLongPress: () async {
        await showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Column(
              children: [
                const Text('¿Seguro deseas eliminar esta publicación?'),
                Row(
                  children: [
                    TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Cancelar')),
                    TextButton(onPressed: () async {
                      try {

                        ///Eliminar producto de las publicaciones
                        if (publishProvider.getUserPublish.containsKey(
                            widget.productId)) {
                          await publishProvider
                              .removeUserPublishItemFromFirestore(
                            publishId: publishProvider
                                .getUserPublish[widget.productId]!.publishId,
                            productId: widget.productId,
                          );
                        }

                        /// Eliminar producto de la tienda
                        /*FirebaseFirestore.instance.collection("products").doc(widget.productId).delete();
                        await publishProvider.fetchUserPublishlist();
                        await vistoRecienteProvider.clearVistoFromFirebase();*/
                      } catch (e){

                      } finally {

                      }

                      Navigator.pop(context);
                    }, child: const Text('Confirmar')),
                  ],
                )
              ],
            ),
          );
        });
      },
      child: Container(
        height: 350,
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
                  FancyShimmerImage(
                      boxFit: BoxFit.contain,
                      height: double.maxFinite,
                      width: double.maxFinite,
                      imageUrl:  getCurrentProduct.productImage1),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                            alignment: const Alignment(0,0),
                            height: 20,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.redAccent,
                            ),
                            child: const Text('En revisión', style: TextStyle(color: Colors.white),)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Flexible(child: Text(getCurrentProduct.productTitle, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600),)),
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
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(getCurrentProduct.productState, style: const TextStyle(color: Colors.white),)),
                  Row(
                    children: [
                      const Icon(Icons.location_pin, size: 15, color: Colors.deepPurple,),
                      Text(getCurrentProduct.userLocation),
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
                  Text('\$${getCurrentProduct.productPrice}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red),),
                  SizedBox(
                      child:
                      CustomButton(
                          onTap: () async {
                            await showDialog(context: context, builder: (context){
                              return AlertDialog(
                                title: Text(getCurrentProduct.productTitle),
                                content: Text(getCurrentProduct.productDescription),
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
                          colorShadow: Colors.grey)
                    /*Material(
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
            ),
            const SizedBox(height: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Fecha de publicación:', style: TextStyle(color: Colors.grey),),
                Text(DateFormat('dd / MM / yy').format(date), style: const TextStyle(color: Colors.grey),),
              ],
            ),
          ],
        ),
      ),
    )
        : GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return EditOrUploadProductScreen(
                productModel: getCurrentProduct,
              );
            },
          ),
        );
      },
      onLongPress: () async {
        await showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Column(
              children: [
                const Text('¿Seguro deseas eliminar esta publicación?'),
                Row(
                  children: [
                    TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Cancelar')),
                    TextButton(onPressed: () async {
                      try {

                        ///Eliminar producto de las publicaciones
                        if (publishProvider.getUserPublish.containsKey(
                            widget.productId)) {
                          await publishProvider
                              .removeUserPublishItemFromFirestore(
                            publishId: publishProvider
                                .getUserPublish[widget.productId]!.publishId,
                            productId: widget.productId,
                          );
                        }

                        /// Eliminar producto de la tienda
                        /*FirebaseFirestore.instance.collection("products").doc(widget.productId).delete();
                        await publishProvider.fetchUserPublishlist();
                        await vistoRecienteProvider.clearVistoFromFirebase();*/
                      } catch (e){

                      } finally {

                      }

                      Navigator.pop(context);
                    }, child: const Text('Confirmar')),
                  ],
                )
              ],
            ),
          );
        });
      },
      child: Container(
        height: 350,
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
                  FancyShimmerImage(
                      boxFit: BoxFit.contain,
                      height: double.maxFinite,
                      width: double.maxFinite,
                      imageUrl:  getCurrentProduct.productImage1),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                            alignment: const Alignment(0,0),
                            height: 20,
                            width: getCurrentProduct.vendido == true ? 60:120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: getCurrentProduct.vendido == true ? Colors.redAccent:Colors.green,
                            ),
                            child: Text(getCurrentProduct.vendido == true ? 'Vendido':'Publicación activa', style: const TextStyle(color: Colors.white),)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Flexible(child: Text(getCurrentProduct.productTitle, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600),)),
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
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(getCurrentProduct.productState, style: const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis),)),
                  Row(
                    children: [
                      const Icon(Icons.location_pin, size: 15, color: Colors.deepPurple,),
                      Text(getCurrentProduct.userLocation),
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
                  Text('\$${getCurrentProduct.productPrice}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red),),
                  SizedBox(
                      child:
                      CustomButton(
                          onTap: () async {
                            await showDialog(context: context, builder: (context){
                              return AlertDialog(
                                title: Text(getCurrentProduct.productTitle),
                                content: Text(getCurrentProduct.productDescription),
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
                          colorShadow: Colors.grey)
                    /*Material(
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
            ),
            const SizedBox(height: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Fecha de publicación:', style: TextStyle(color: Colors.grey),),
                Text(DateFormat('dd / MM / yy').format(date), style: const TextStyle(color: Colors.grey),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
