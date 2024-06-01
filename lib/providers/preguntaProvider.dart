import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/view/authPages/login.dart';
import 'package:Rimio/view/authPages/registro.dart';
import 'package:Rimio/view/models/favoritos_model.dart';
import 'package:Rimio/view/models/pregunta_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:uuid/uuid.dart';

class PreguntaProvider with ChangeNotifier {
  final Map<String, PreguntaModel> _preguntaItems = {};

  Map<String, PreguntaModel> get getPreguntas {
    return _preguntaItems;
  }


  final database = FirebaseFirestore.instance.collection("products");
  final _auth = FirebaseAuth.instance;
  final preguntaId = Uuid().v4();


// Firebase

  Future<void> addPreguntaToFirebase({
    required String pregunta,
    required String productId,
    required String productTitle,
    required String displayName,
    required String? userImage,
    required String? emisorEmail,
    required BuildContext context,
    String? id,
  }) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const Login();
      }));
      return;
    }

    try {
      await database.doc('${productTitle} ID:$productId').collection('preguntas').doc('consulta').set({
        'emisor': user.displayName,
        'emisorEmail': emisorEmail,
        'remitente': displayName,
        'imagen': userImage,
        'pregunta': pregunta,
        'user_id': user.uid,
        'createAt': Timestamp.now().toDate()..difference(DateTime.now()).toString(),
        'id': preguntaId,
        'respuesta': '',
      });
      await showDialog(context: context, builder: (context){
        return const AlertDialog(
          title: Center(child: Text('Tu mensaje ha sido enviado, recibirás un correo con la respuesta del vendedor.', style: TextStyle(fontSize: 18),)),
        );
      });
      await fetchPreguntas(productTitle: productTitle, productId: productId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addRespuestaToFirebase({
    required String respuesta,
    required String productId,
    required String productTitle,
    required BuildContext context,
    String? id,

  }) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const Login();
      }));
      return;
    }

    try {

      await database.doc('${productTitle} ID:$productId').collection('preguntas').doc('consulta').update({

        'respuesta': respuesta,

      });
      await showDialog(context: context, builder: (context){
        return const AlertDialog(
          title: Center(child: Text('Tu respuesta ha sido enviada', style: TextStyle(fontSize: 18),)),
        );
      });
      await fetchPreguntas(productTitle: productTitle, productId: productId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchPreguntas({
    required String productTitle,
    required String productId,
}) async {

    try {
      final userDoc = await database.doc('${productTitle} ID:$productId').get();
      final data = userDoc.data();
      if (data == null || !data.containsKey('pregunta')) {
        return;
      }
      final length = userDoc.get("pregunta").length;
      for (int index = 0; index < length; index++) {
        _preguntaItems.putIfAbsent(
            userDoc.get("pregunta")[index],
                () => PreguntaModel(
              pregunta: userDoc.get("pregunta")[index],
            ));
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

}