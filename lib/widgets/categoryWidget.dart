import 'package:Rimio/view/searchPage.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key, required this.image, required this.categoria});

  final String image, categoria;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, SearchPage.routeName, arguments: categoria);
      },
      child: Column(
        children: [
          Image.asset(image, height: 50, width: 50,),
          const SizedBox(height: 5,),
          Text(categoria, style: const TextStyle(fontWeight: FontWeight.w700),),
        ],
      ),
    );
  }
}
