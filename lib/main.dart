import 'package:Rimio/providers/favoritos_provider.dart';
import 'package:Rimio/providers/order_provider.dart';
import 'package:Rimio/providers/preguntaProvider.dart';
import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/providers/publish_provider.dart';
import 'package:Rimio/providers/user_provider.dart';
import 'package:Rimio/providers/venta_provider.dart';
import 'package:Rimio/providers/vistoReciente_provider.dart';
import 'package:Rimio/view/authPages/authPage.dart';
import 'package:Rimio/view/models/product_model.dart';
import 'package:Rimio/view/productDetails.dart';
import 'package:Rimio/view/publicarItem/editOrUploadProductScreen.dart';
import 'package:Rimio/view/rootScreen.dart';
import 'package:Rimio/view/searchPage.dart';
import 'package:Rimio/widgets/dynamic_link.dart';
import 'package:flutter/material.dart';
import 'package:Rimio/view/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();

  DynamicLinkProvider().initDynamicLink();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_){
            return ProductsProvider();
          }),
          ChangeNotifierProvider(create: (_){
            return FavoritosProvider();
          }),
          ChangeNotifierProvider(create: (_){
            return VistoRecienteProvider();
          }),
          ChangeNotifierProvider(create: (_){
            return UserProvider();
          }),
          ChangeNotifierProvider(create: (_){
            return OrderProvider();
          }),
          ChangeNotifierProvider(create: (_){
            return PublishProvider();
          }),
          ChangeNotifierProvider(create: (_){
            return VentaProvider();
          }),
          ChangeNotifierProvider(create: (_){
            return PreguntaProvider();
          }),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            textTheme:  const TextTheme(
              labelLarge: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito',
              ),
              bodyMedium: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito',
              ),
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const RootScreen(),
            ProductDetails.routeName: (context) => const ProductDetails(),
            SearchPage.routeName: (context) => const SearchPage(),
            EditOrUploadProductScreen.routeName: (context) => const EditOrUploadProductScreen(),
          },
        ),
      );
      }
    );
  }
}