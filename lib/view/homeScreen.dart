import 'dart:developer';

import 'package:Rimio/adHelper.dart';
import 'package:Rimio/providers/favoritos_provider.dart';
import 'package:Rimio/providers/order_provider.dart';
import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/providers/publish_provider.dart';
import 'package:Rimio/providers/user_provider.dart';
import 'package:Rimio/providers/venta_provider.dart';
import 'package:Rimio/providers/vistoReciente_provider.dart';
import 'package:Rimio/view/models/categoria_model.dart';
import 'package:Rimio/view/searchPage.dart';
import 'package:Rimio/widgets/categoryWidget.dart';
import 'package:Rimio/widgets/itemTile.dart';
import 'package:Rimio/widgets/productWidget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:googleapis/authorizedbuyersmarketplace/v1.dart' as servicecontrol;

import 'package:provider/provider.dart';

import '../notification_call_service.dart';
import '../notificaton_service.dart';
import '../widgets/dynamic_link.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  List<CategoriaModel> categoriaLista = [
    CategoriaModel(
        id: 'Guitarras', name: 'Guitarras', image: 'assets/guitarra.png'),
    CategoriaModel(id: 'Bajos', name: 'Bajos', image: 'assets/bass.png'),
    CategoriaModel(id: 'Amps', name: 'Amps', image: 'assets/amp.png'),
    CategoriaModel(
        id: 'Baterias', name: 'Baterias', image: 'assets/bateria.png'),
    CategoriaModel(
        id: 'Teclados', name: 'Teclados', image: 'assets/teclado.png'),
    CategoriaModel(
        id: 'Folklore', name: 'Folklore', image: 'assets/tradicional.png'),
    CategoriaModel(
        id: 'Orquesta', name: 'Orquesta', image: 'assets/orquesta.png'),
    CategoriaModel(id: 'Equipos de Dj', name: 'Dj', image: 'assets/dj.png'),
    CategoriaModel(
        id: 'Microfonos', name: 'Micrófonos', image: 'assets/microphone.png'),
    CategoriaModel(id: 'Aire', name: 'Aire', image: 'assets/aire.png'),
    CategoriaModel(id: 'Estudio', name: 'Estudio', image: 'assets/estudio.png'),
    CategoriaModel(id: 'Merch', name: 'Merch', image: 'assets/camisa.png'),
    CategoriaModel(
        id: 'Iluminacion', name: 'Iluminación', image: 'assets/spotlight.png'),
    CategoriaModel(
        id: 'Pedales', name: 'Pedales', image: 'assets/guitar-pedal.png'),
    CategoriaModel(
        id: 'Servicios', name: 'Servicios', image: 'assets/servicio.png'),
    CategoriaModel(
        id: 'Accesorios', name: 'Accesorios', image: 'assets/pick.png'),
    CategoriaModel(
        id: 'Repuestos', name: 'Repuestos', image: 'assets/metal.png'),
  ];

  bool isLoadingProd = true;

  Future<void> fetchFCT() async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final favoritosProvider =
        Provider.of<FavoritosProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final publishProvider =
        Provider.of<PublishProvider>(context, listen: false);
    final ventaProvider = Provider.of<VentaProvider>(context, listen: false);
    final vistoProvider =
        Provider.of<VistoRecienteProvider>(context, listen: false);

    try {
      Future.wait({
        productsProvider.fetchProducts(),
        userProvider.fetchUserInfo(),
      });
      Future.wait({
        favoritosProvider.fetchWishlist(),
        orderProvider.fetchUserOrderslist(),
        publishProvider.fetchUserPublishlist(),
        ventaProvider.fetchUserVentalist(),
        vistoProvider.fetchVistolist(),
      });
    } catch (error) {
      log(error.toString());
    }
  }

  @override
  void didChangeDependencies() {
    if (isLoadingProd) {
      fetchFCT();
    }
    super.didChangeDependencies();
  }

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  List<String> bannerImages = [];

  @override
  void initState() {
    super.initState();
    NotificationService().init();

    Future.delayed(Duration.zero).then((value) async {
      await NotificationService().setUpFirebaseMessaging();
    });
    DynamicLinkProvider().initDynamicLink(context);
    _loadBannerAd();
    fetchBanners();
    updateFcm();
  }

  /// Fetching banners
  Future<void> fetchBanners() async {
    try {
      //final userDoc = await FirebaseFirestore.instance.collection("banners").doc('homescreenbanners').get();
      final ref1 = FirebaseStorage.instance
          .ref()
          .child('bannerImages')
          .child('banner1.jpg');
      final ref2 = FirebaseStorage.instance
          .ref()
          .child('bannerImages')
          .child('banner2.jpg');
      final ref3 = FirebaseStorage.instance
          .ref()
          .child('bannerImages')
          .child('banner3.jpg');
      final ref4 = FirebaseStorage.instance
          .ref()
          .child('bannerImages')
          .child('bannerUsa.png');

      String banner1 = await ref1.getDownloadURL();
      String banner2 = await ref2.getDownloadURL();
      String banner3 = await ref3.getDownloadURL();
      String banner4 = await ref4.getDownloadURL();

      bannerImages = [banner4, banner1, banner2, banner3];
    } catch (e) {}
  }

  /// /// /// /// ///

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
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

  

  @override
  Widget build(BuildContext context) {
    
    final productProvider = Provider.of<ProductsProvider>(context);
    final vistoProvider = Provider.of<VistoRecienteProvider>(context);
    
    for (var url in bannerImages) {
      precacheImage(NetworkImage(url),context);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            StreamBuilder(
              stream: productProvider.fetchProductsStream(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return const MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: SelectableText(snapshot.error.toString()),
                  );
                } else if (snapshot.data == null) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ));
                }
                return Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: Swiper(
                    containerWidth: MediaQuery.of(context).size.width,
                    autoplay: true,
                    autoplayDelay: 5000,
                    duration: 2000,
                    curve: Curves.ease,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(bannerImages[index]);
                    },
                    itemCount: bannerImages.length,
                    // pagination: const SwiperPagination(
                    //     builder: SwiperPagination.dots
                    // ),
                  ),
                );
              },
            ),
            if (_isBannerAdReady)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: _bannerAd.size.width.toDouble(),
                    height: _bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  ),
                ),
              ),
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categorías',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 80,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: List.generate(categoriaLista.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: CategoryWidget(
                          image: categoriaLista[index].image,
                          categoria: categoriaLista[index].name),
                    );
                  })),
            ),
            Visibility(
              visible: vistoProvider.getVisto.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                        visible: productProvider.getProducts.isNotEmpty,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Vistos recientemente',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: vistoProvider.getVisto.isNotEmpty,
              child: SizedBox(
                height: 310,
                width: double.maxFinite,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: vistoProvider.getVisto.length < 10
                        ? vistoProvider.getVisto.length
                        : 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ProductWidget(
                          productId: vistoProvider.getVisto.values
                              .toList()[index]
                              .productId,
                        ),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                      visible: productProvider.getProducts.isNotEmpty,
                      child: const Text(
                        'Publicaciones recientes',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      )),
                  GestureDetector(
                      onTap: () {},
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SearchPage.routeName);
                        },
                        child: Visibility(
                            visible: productProvider.getProducts.isNotEmpty,
                            child: const Text(
                              'Ver más',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.purple),
                            )),
                      )),
                ],
              ),
            ),
            Visibility(
              visible: productProvider.getProducts.isNotEmpty,
              child: SizedBox(
                height: 310,
                width: double.maxFinite,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productProvider.getProducts.length < 10
                        ? productProvider.getProducts.length
                        : 10,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                          value: productProvider.getProducts[index],
                          child: itemTile());
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initDynamicLinks() async {
    // DynamicLinkProvider().createLink("refCode");
    // var link = await createDeepLink();
    //
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      // Handle the deep link when the app is opened
      print('Dynamic link opened: $deepLink');
    }

    FirebaseDynamicLinks.instance.onLink.listen((event) {
      print("");
    });
    print("");
  }

  String _androidPackageName = 'com.rimiomusic.rimio';
  String _iOSBundleId = 'com.sheepapps.app';
  String _appStoreId = '1611717111';
  String _uriPrefix = 'https://rimio.page.link/rimio'; //prefix in Firebase
  String _deepLink = 'https://ourApp.com/page';
  int _minimumVersion = 1;

  Future<Uri> createDeepLink() async {
    final parameters = DynamicLinkParameters(
      uriPrefix: _uriPrefix,
      link: Uri.parse(_deepLink),
      androidParameters: AndroidParameters(
        packageName: _androidPackageName,
        minimumVersion: _minimumVersion,
      ),
      iosParameters: IOSParameters(
        bundleId: _iOSBundleId,
        minimumVersion: _minimumVersion.toString(),
        appStoreId: _appStoreId,
      ),
    );
    final shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    final uri = shortDynamicLink.shortUrl;
    return uri;
  }

  Future<String?> retrieveDeepLinkId() async {
    String? id;
    try {
      final initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
      final deepLink = initialLink?.link;

      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('id')) {
          id = deepLink.queryParameters['id'];
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return id;
  }

  void updateFcm() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    var token = await FirebaseMessaging.instance.getToken();
    var userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({"fcm_token": token});
  }
}
