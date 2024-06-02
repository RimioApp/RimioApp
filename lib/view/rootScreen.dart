import 'package:Rimio/view/comunidad.dart';
import 'package:Rimio/view/favoritos.dart';
import 'package:Rimio/view/home.dart';
import 'package:Rimio/view/homeScreen.dart';
import 'package:Rimio/view/perfil.dart';
import 'package:Rimio/view/publicarItem/publicar.dart';
import 'package:Rimio/view/searchPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {

  late List<Widget> screens;
  int currentScreen = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    screens = const [
      Home(),
      Favoritos(),
      Publicar(),
      Comunidad(),
      perfil(),
    ];
    controller = PageController(initialPage: currentScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: currentScreen,
        onDestinationSelected: (index){
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(currentScreen);
        },
        destinations: const [
          NavigationDestination(selectedIcon: Icon(IconlyBold.home, color: Colors.deepPurple,), icon: Icon(IconlyLight.home), label: 'Inicio'),
          NavigationDestination(selectedIcon: Icon(IconlyBold.heart, color: Colors.deepPurple,), icon: Icon(IconlyLight.heart), label: 'Favoritos'),
          NavigationDestination(selectedIcon: Icon(IconlyBold.upload, color: Colors.deepPurple,), icon: Icon(IconlyLight.upload), label: 'Publicar'),
          NavigationDestination(selectedIcon: Icon(Icons.people, color: Colors.deepPurple, size: 30,), icon: Icon(Icons.people_outline, size: 30,), label: 'Comunidad'),
          NavigationDestination(selectedIcon: Icon(IconlyBold.profile, color: Colors.deepPurple,), icon: Icon(IconlyLight.profile), label: 'Perfil'),
        ],
      ),
    );
  }
}
