import 'package:Rimio/view/authPages/login.dart';
import 'package:flutter/material.dart';
import 'package:Rimio/view/authPages/registro.dart';
import 'package:Rimio/widgets/customButton.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 500,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Theme.of(context).primaryColor
                  )
                ],
                color: Theme.of(context).primaryColor,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        const SizedBox(height: 80,),
                        Image.asset(
                            height: 100,
                            'assets/Rimio_w.png'),
                      ],
                    ),
                  )
                ],
              )
            ),
            const SizedBox(height: 25,),
            CustomButton(
              height: 50,
              width: MediaQuery.of(context).size.width*0.8,
              color: Colors.black54,
              radius: 50,
              text: 'Regístrate',
              fontSize: 20,
              textColor: Colors.white,
              shadow: 8,
              colorShadow: Colors.grey.shade500,
            onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return Registro();
                }));
            },),
            const SizedBox(height: 20,),
            CustomButton(
              height: 50,
              width: MediaQuery.of(context).size.width*0.8,
              color: Theme.of(context).primaryColor,
              radius: 50,
              text: 'Inicia sesión',
              fontSize: 20,
              textColor: Colors.white,
              shadow: 8,
              colorShadow: Colors.grey.shade500,
            onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return Login();
                }));
            },),
            const SizedBox(height: 25,),
            const Divider(),
            const SizedBox(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){},
                    child: const Text('Términos y condiciones', style: TextStyle(decoration: TextDecoration.underline),)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
