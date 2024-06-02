import 'package:Rimio/view/productDetails.dart';
import 'package:Rimio/widgets/itemTile.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class misComprasWidget extends StatelessWidget {
  misComprasWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, ProductDetails.routeName);
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
                height: 220,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Stack(
                  children: [
                    FancyShimmerImage(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        imageUrl: 'https://d1aeri3ty3izns.cloudfront.net/media/73/731808/600/preview.jpg'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: (){
                            },
                            icon: Container(
                                height: 25,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: const Icon(Icons.favorite_outline_rounded, size: 25,)))
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Text('producto', style: TextStyle(fontWeight: FontWeight.w600),),
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
                        child: const Text('estado', style: TextStyle(color: Colors.white),)),
                    const Row(
                      children: [
                        Text('ubicacion'),
                        Icon(Icons.location_pin, size: 15,),
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
                    const Text('precio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red),),
                    SizedBox(
                      child: Material(
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
                              ))),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
