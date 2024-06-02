import 'package:Rimio/providers/favoritos_provider.dart';
import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/view/models/favoritos_model.dart';
import 'package:Rimio/view/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class FavButton extends StatefulWidget {
  const FavButton({
    super.key,
    this.bkgColor = Colors.transparent,
    this.size = 20,
    required this.productId,
    // this.isInFavoritos = false,
  });
  final Color bkgColor;
  final double size;
  final String productId;
  // final bool? isInFavoritos;

  @override
  State<FavButton> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<FavButton> {

  @override
  Widget build(BuildContext context) {

    final favoritosProvider = Provider.of<FavoritosProvider>(context);

    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: widget.bkgColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () async {
          try {
            if (favoritosProvider.getFavoritos.containsKey(widget.productId)) {
              await favoritosProvider.removeWishlistItemFromFirestore(
                favoritosId: favoritosProvider
                    .getFavoritos[widget.productId]!.favoritosId,
                productId: widget.productId,
              );
            } else {
              await favoritosProvider.addToWishlistFirebase(
                productId: widget.productId,
                context: context,
              );
            }
            await favoritosProvider.fetchWishlist();
          } catch (e) {

          } finally {

          }
        },
        icon: Icon(
          favoritosProvider.isProdinFav(productId: widget.productId)
              ? Icons.favorite_rounded
              : Icons.favorite_outline_rounded,
          size: widget.size,
          color: favoritosProvider.isProdinFav(productId: widget.productId)
              ? Colors.redAccent
              : Colors.grey.shade900,
        ),
      ),
    );
  }
}