import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return FittedBox(
      child: IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FancyShimmerImage(
                  imageUrl: 'https://d1aeri3ty3izns.cloudfront.net/media/73/731808/600/preview.jpg',
                width: size.height*0.2,
                height: size.height*0.2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: size.width*0.6,
                        child: Text('Nombre del artículo', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18), maxLines: 2,),),
                    const SizedBox(height: 50,),
                    const Text('\$120', style: TextStyle(fontSize: 18),),
                  ],
                ),
              ),
              const Column(
                children: [
                  Icon(Icons.clear, color: Colors.redAccent, size: 30,),
                  SizedBox(height: 50),
                  Icon(Icons.favorite_outline_rounded, size: 30,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
