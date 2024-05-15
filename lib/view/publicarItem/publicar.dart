import 'package:Rimio/providers/user_provider.dart';
import 'package:Rimio/view/authPages/login.dart';
import 'package:Rimio/view/models/user_model.dart';
import 'package:Rimio/view/publicarItem/editOrUploadProductScreen.dart';
import 'package:Rimio/view/publicarItem/editOrUploadService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Publicar extends StatefulWidget {
  const Publicar({super.key});

  @override
  State<Publicar> createState() => _PublicarState();
}

class _PublicarState extends State<Publicar> {

  UserModel? userModel;
  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      userModel = await userProvider.fetchUserInfo();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          userModel == null
              ?const SizedBox.shrink()
              :SizedBox(height: 300, width: 300, child: Text('¡Hola!\n${userModel!.userName}\n\n¿Qué deseas hacer?', style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w600),)),
          const SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              user != null
                  ? GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, EditOrUploadProductScreen.routeName);
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.deepPurpleAccent,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 20,
                      color: Colors.deepPurpleAccent
                    ),
            ]
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sell_rounded, color: Colors.white, size: 50,),
                      Text('Vender', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              )
              : GestureDetector(
                onTap: () async {
                  showDialog(context: context, builder: (context){
                    return const AlertDialog(
                        content: SizedBox(
                            height: 80, width: 100,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Debes iniciar sesión'),
                                  SizedBox(height: 5,),
                                  CircularProgressIndicator(color: Colors.deepPurple,),
                                ],
                              ),)));
                  });
                  Future.delayed(const Duration(seconds: 3), () async {
                    Navigator.pop(context);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) {
                      return const Login();
                    }));
                  });
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.deepPurpleAccent,
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 20,
                            color: Colors.deepPurpleAccent
                        ),
                      ]
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sell_rounded, color: Colors.white, size: 50,),
                      Text('Vender', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 40,),
              user != null
                  ?GestureDetector(
                onTap: (){

                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return const EditOrUploadService();
                  }));
                },
                child: Container(
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.deepPurpleAccent,
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 20,
                            color: Colors.deepPurpleAccent
                        ),
                      ]
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_people_rounded, color: Colors.white, size: 50,),
                      Text('Publicar servicio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ) : GestureDetector(
                onTap: (){
                  showDialog(context: context, builder: (context){
                    return const AlertDialog(
                        content: SizedBox(
                            height: 80, width: 100,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Debes iniciar sesión'),
                                  SizedBox(height: 5,),
                                  CircularProgressIndicator(color: Colors.deepPurple,),
                                ],
                              ),)));
                  });
                  Future.delayed(const Duration(seconds: 3), () async {
                    Navigator.pop(context);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) {
                      return const Login();
                    }));
                  });
                },
                child: Container(
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.deepPurpleAccent,
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 20,
                            color: Colors.deepPurpleAccent
                        ),
                      ]
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_people_rounded, color: Colors.white, size: 50,),
                      Text('Publicar servicio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      )
    );
  }
}
