import 'package:Rimio/view/home.dart';
import 'package:Rimio/view/rootScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleBttn extends StatefulWidget {
  const GoogleBttn({super.key});

  @override
  State<GoogleBttn> createState() => _GoogleBttnState();
}

class _GoogleBttnState extends State<GoogleBttn> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState() {
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user=event;
      });
    });
    super.initState();
  }

  void _handleGoogleSignIn(){
    try{
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (error){
      print(error);
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){return RootScreen();}), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _handleGoogleSignIn();
      },
      child: Column(
        children: [
          Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white
                  ),
                ),
              Positioned(
                left: 12,
                top: 12,
                child: Image.asset(
                'assets/google.png',
                height: 35,
                width: 35,),
              ),
            ]
          ),
          const SizedBox(height: 5,),
          const Text('Inicia con Google', style: TextStyle(color: Colors.grey),),
        ],
      ),
    );
  }
}
