import 'dart:async';
import 'package:Rimio/view/home.dart';
import 'package:Rimio/view/rootScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  final auth = FirebaseAuth.instance;
  @override
  void initState() {

    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer = Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
        return RootScreen();
      }), (route) => false);
      showDialog(context: context, builder: (context){
        return GestureDetector(
            onTap:(){
              Navigator.pop(context);
            },
            child: Image.asset('assets/bienvenida.png'));
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            elevation: 10,
            content: Center(
              child: Text(
                '¡Registro exitoso!',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight
                        .bold,
                    fontSize: 15),),
            ),
            backgroundColor: Colors
                .deepPurple,));

      timer?.cancel();
    }
  }

  @override
  void dispose() {

    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Te hemos enviado un correo de verificación\nIngresa al link para culminar con el registro.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'Enviado a ${auth.currentUser?.email}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets
                    .symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'Ingresa al link enviado a tu correo para completar la verificación',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 57),
              Padding(
                padding: const EdgeInsets
                    .symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  child: const Text('Reenviar'),
                  onPressed: () {
                    try {
                      FirebaseAuth.instance.currentUser
                          ?.sendEmailVerification();
                    } catch (e) {
                      debugPrint('$e');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}