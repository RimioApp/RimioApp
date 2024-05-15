
import 'package:Rimio/widgets/customButton.dart';
import 'package:Rimio/widgets/formText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Password extends StatefulWidget {
  const Password({super.key});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {

  TextEditingController emailController = TextEditingController();

  final formKey = GlobalKey<FormState>(); //Para hacer validación de los TextField

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded,),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },),
                  ],
                ),
                const SizedBox(height: 100,),
                const Text('Recuperación de contraseña', style: TextStyle(color: Colors.deepPurple, fontSize: 25),),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                      controller: emailController,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                          prefixIcon: const Icon(Icons.email_rounded),
                          hintText: 'Ingrese su correo electrónico',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(50)
                          )
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Ingrese su correo electrónico";
                        }else{
                          null;
                        }
                      }
                  ),
                ),
                CustomButton(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 3),
                          elevation: 10,
                          content: Center(
                            child: Text('Enlace enviado a tu correo',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),),
                          ),
                          backgroundColor: Colors.deepPurple,));

                    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
                    }
                  },
                    height: 50,
                    width: 250,
                    color: Colors.deepPurple,
                    radius: 50,
                    text: 'Recuperar contraseña',
                    fontSize: 20,
                    textColor: Colors.white,
                    shadow: 0,
                    colorShadow: Colors.transparent)
              ],
            ),
          ),
        ));
  }
}
