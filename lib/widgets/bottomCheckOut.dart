import 'package:flutter/material.dart';

class BottomCheckOut extends StatelessWidget {
  const BottomCheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: kBottomNavigationBarHeight + 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total (6 productos)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                  SizedBox(height: 20,),
                  Text('\$720', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
              ElevatedButton(
                  onPressed: (){},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple
              ),
                  child: const Text('Comprar'),),
            ),
          ],
        ),
      ),
    );
  }
}
