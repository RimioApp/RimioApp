import 'package:Rimio/adHelper.dart';
import 'package:Rimio/providers/favoritos_provider.dart';
import 'package:Rimio/view/searchPage.dart';
import 'package:Rimio/widgets/bottomBar.dart';
import 'package:Rimio/widgets/customButton.dart';
import 'package:Rimio/widgets/productWidget.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class Favoritos extends StatefulWidget {
  const Favoritos({super.key});

  @override
  State<Favoritos> createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  final isEmpty = false;

  @override
  Widget build(BuildContext context) {

    final favoritosProvider = Provider.of<FavoritosProvider>(context);

    return favoritosProvider.getFavoritos.isEmpty
        ? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        shadowColor: Colors.purpleAccent,
        automaticallyImplyLeading: false,
        title: const Text('Favoritos', style: TextStyle(color: Colors.white),),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sin artículos', style: TextStyle(fontSize: 22, color: Colors.deepPurple),),
            const SizedBox(height: 10,),
            CustomButton(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context){
                    return SearchPage();
                  }));
                },
                height: 50,
                width: 180,
                color: Colors.deepPurple,
                radius: 50,
                text: '¡Empieza YA!',
                fontSize: 20,
                textColor: Colors.white,
                shadow: 0,
                colorShadow: Colors.transparent),
          ],
        ),
      ),
    ) : Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        elevation: 5,
        shadowColor: Colors.purpleAccent,
        title: Text('Favoritos (${favoritosProvider.getFavoritos.length})', style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
              onPressed: () async {
            await showDialog(context: context, builder: (context){
              return AlertDialog(
                title: Column(
                  children: [
                    Text('¿Seguro deseas eliminar tus favoritos?'),
                    Row(
                      children: [
                        TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancelar')),
                        TextButton(onPressed: () async {
                          await favoritosProvider.clearWishlistFromFirebase();
                          favoritosProvider.clearLocalFav();
                          Navigator.pop(context);
                        }, child: Text('Confirmar')),
                      ],
                    )
                  ],
                ),
              );
            });
        },
              icon: const Icon(Icons.delete_rounded, color: Colors.white,))],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 8, left: 8),
        child: DynamicHeightGridView(
          itemCount: favoritosProvider.getFavoritos.length,
          crossAxisCount: 2,
          builder: (context, index){
            return ProductWidget(productId: favoritosProvider.getFavoritos.values.toList()[index].productId,);
          },
        ),
      ),
    );
  }
}

