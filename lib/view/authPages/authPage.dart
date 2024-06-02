import 'package:Rimio/view/authPages/login.dart';
import 'package:Rimio/view/home.dart';
import 'package:Rimio/view/homeScreen.dart';
import 'package:Rimio/view/perfil.dart';
import 'package:Rimio/view/publicarItem/publicar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData){
            return const Home();
          } else {
            return const Home();
          }
        },
      );
  }
}
