import 'package:Rimio/adHelper.dart';
import 'package:Rimio/view/favoritos.dart';
import 'package:Rimio/view/publicarItem/publicar.dart';
import 'package:flutter/material.dart';
import 'package:Rimio/view/home.dart';
import 'package:Rimio/view/homeScreen.dart';
import 'package:Rimio/view/perfil.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class bottomBar extends StatefulWidget {
  const bottomBar({
    super.key,
  });

  @override
  State<bottomBar> createState() => _bottomBarState();
}

class _bottomBarState extends State<bottomBar> {



  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(onPressed: (){

            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
              return const Home();
            }), (route) => false);

          }, icon: const Column(
            children: [
              Icon(IconlyLight.home, size: 30, color: Colors.deepPurple,),
              Text('Inicio')
            ],
          ),),
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return const Favoritos();
            }));
          }, icon: const Column(
            children: [
              Icon(IconlyLight.heart, size: 30, color: Colors.deepPurple,),
              Text('Favoritos')
            ],
          )),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return const Publicar();
            }));

          }, icon: const Column(
            children: [
              Icon(IconlyLight.upload, size: 30, color: Colors.deepPurple,),
              Text('Publicar')
            ],
          )),
          IconButton(onPressed: (){
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 3),
                  elevation: 10,
                  content: Center(
                    child: Text('¡Próximamente!',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),),
                  ),
                  backgroundColor: Colors.deepPurple,));
          }, icon: const Column(
            children: [
              Icon(Icons.people_outline, size: 30, color: Colors.deepPurple,),
              Text('Comunidad')
            ],
          )),
          IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return const perfil();
                }));
              }, icon: const Column(
            children: [
              Icon(IconlyLight.profile, size: 30, color: Colors.deepPurple,),
              Text('Perfil')
            ],
          )),
        ],
      ),
    );
  }
}