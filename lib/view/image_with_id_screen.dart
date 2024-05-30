import 'dart:io';

import 'package:Rimio/widgets/customButton.dart';
import 'package:Rimio/widgets/image_picker_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../emailVerification.dart';

class ImageWithIdScreen extends StatefulWidget {
  var body;
  XFile? profileImage;
  var email;
  var password;
  var displayNameController;

  ImageWithIdScreen({
    super.key,
    required this.body,
    required this.profileImage,
    required this.email,
    required this.password,
    required this.displayNameController,
  });

  @override
  State<ImageWithIdScreen> createState() => _ImageWithIdScreenState();
}

class _ImageWithIdScreenState extends State<ImageWithIdScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<String> locationList = [
    'Amazonas',
    'Anzoátegui',
    'Apure',
    'Aragua',
    'Barinas',
    'Bolívar',
    'Carabobo',
    'Cojedes',
    "Falcón",
    "Delta Amacuro",
    "Dtto. Capital",
    "Guárico",
    "La Guaira",
    "Lara",
    "Mérida",
    "Miranda",
    "Monagas",
    "Nueva Esparta",
    "Portuguesa",
    "Sucre",
    "Táchira",
    "Trujillo",
    "Yaracuy",
    "Zulia",
  ];

  bool visible = true;
  String? _locationValue;

  //FirebaseFirestore firestore = FirebaseFirestore.instance;

  final formKey =
      GlobalKey<FormState>(); //Para hacer validación de los TextField

  XFile? _imageWithId;

  void pickImage() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text('Elije una opción')),
            content: SizedBox(
              height: 170,
              width: 150,
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      camaraPicker();
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.deepPurple,
                      size: 30,
                    ),
                    label: const Text(
                      'Cámara',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      galeriaPicker();
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.deepPurple,
                      size: 30,
                    ),
                    label: const Text(
                      'Galería',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      _imageWithId = null;
                      setState(() {});
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                    label: const Text(
                      'Eliminar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> camaraPicker() async {
    final ImagePicker imagePicker = ImagePicker();
    _imageWithId = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  Future<void> galeriaPicker() async {
    final ImagePicker imagePicker = ImagePicker();
    _imageWithId = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  void emailUsed() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                const Text('El correo proporcionado ya se encuentra en uso.'),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Reintentar')),
                  ],
                )
              ],
            ),
          );
        });
  }

  void weakPassword() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                const Text('La contraseña proporcionada es muy débil.'),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Reintentar')),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isLoading = false;

  final auth = FirebaseAuth.instance;

  String? userImageUrl;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      isLoading = false;
      // XFile file = XFile(
      //     "/data/user/0/com.rimiomusic.rimio/cache/dd61946f-dc65-4587-9409-e90cc106ae45/IMG-20240521-WA0020.jpg");
      //
      // _imageWithId = file;
    }
    return Scaffold(
        backgroundColor: Colors.deepPurpleAccent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: formKey,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white38,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back_rounded,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Image.asset(
                                        height: 30, 'assets/Rimio_w.png')),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            "Sube una selfie con tu identificación",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                              height: 300,
                              width: 200,
                              child: ImagePickerWidget(
                                imagedPicked: _imageWithId,
                                function: () {
                                  pickImage();
                                },
                                fix: BoxFit.contain,
                                height: 300,
                              )),
                          const SizedBox(height: 10)
                        ],
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: CustomButton(
                    onTap: () async {
                      if (_imageWithId == null) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                title: Column(
                                  children: [
                                    Text('Asegúrate de elegir una imagen.'),
                                  ],
                                ),
                              );
                            });
                        return;
                      }

                      if (formKey.currentState!.validate()) {
                        try {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.deepPurple,
                                ));
                              });
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: widget.email,
                            password: widget.password,
                          );

                          //image with id
                          final refId = FirebaseStorage.instance
                              .ref()
                              .child('imagewithid')
                              .child(
                                  'imagewithid_${widget.email}_${DateTime.now().microsecondsSinceEpoch}.jpg');
                          await refId.putFile(File(widget.profileImage!.path));
                          var imageWithId = await refId.getDownloadURL();
                          //profile
                          final ref = FirebaseStorage.instance
                              .ref()
                              .child('usersImages')
                              .child('${widget.email}.jpg');
                          await ref.putFile(File(widget.profileImage!.path));
                          userImageUrl = await ref.getDownloadURL();

                          final User? user = auth.currentUser;
                          final String uid = user!.uid;
                          var map = widget.body;
                          map['userId'] = uid;
                          map['imageWithId'] = imageWithId;
                          map['profile_status'] = "pending";
                          map['userImage'] = userImageUrl;
                          user.updateDisplayName(
                              widget.displayNameController.text.trim());
                          user.updatePhotoURL(userImageUrl);
                          user.reload();
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(uid)
                              .set(widget.body);

                          if (auth.currentUser != null) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const EmailVerificationScreen();
                            }));
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            weakPassword();
                          } else if (e.code == 'email-already-in-use') {
                            emailUsed();
                          }
                        } catch (e) {
                          print(e);
                        } finally {
                          isLoading = false;
                        }
                      }
                    },
                    height: 50,
                    width: 150,
                    color: Colors.white,
                    radius: 50,
                    text: 'Registrarse',
                    fontSize: 20,
                    textColor: Colors.deepPurple,
                    shadow: 8,
                    colorShadow: Colors.white38),
              )
            ],
          ),
        ));
  }
}
/*

 */
