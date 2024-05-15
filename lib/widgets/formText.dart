import 'package:flutter/material.dart';

class formText extends StatelessWidget {
  formText({
    super.key,
    required this.hint,
    required this.icon,
    required this.type,
    required this.secure,
    required this.obscure,
    required this.controller,
  });

  Icon icon;
  IconButton secure;
  String hint;
  TextInputType? type;
  bool obscure;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: type,
        decoration: InputDecoration(
          hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
            prefixIcon: icon,
            suffixIcon: secure,
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50)
            )
        ),
          validator: (value){
            if(value!.isEmpty){
              return "Ingrese su correo registrado";
            }else{
              null;
            }
          }
      ),
    );
  }
}
