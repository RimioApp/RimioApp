import 'package:Rimio/widgets/customButton.dart';
import 'package:Rimio/widgets/image_picker_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../image_with_id_screen.dart';

class Registro extends StatefulWidget {
  const Registro({
    super.key,
  });

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
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

  List<DropdownMenuItem<String>>? get locationDropDownList {
    List<DropdownMenuItem<String>>? menuItem =
        List<DropdownMenuItem<String>>.generate(
      locationList.length,
      (index) => DropdownMenuItem(
        value: locationList[index],
        child: Text(locationList[index]),
      ),
    );
    return menuItem;
  }

  bool visible = true;
  String? _locationValue;

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController cedulaController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //FirebaseFirestore firestore = FirebaseFirestore.instance;

  final formKey =
      GlobalKey<FormState>(); //Para hacer validación de los TextField

  XFile? _pickedImage;

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
                      _pickedImage = null;
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
    _pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  Future<void> galeriaPicker() async {
    final ImagePicker imagePicker = ImagePicker();
    _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
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
    emailController.dispose();
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

      // _pickedImage = file;

      nameController.text = "Nouman";
      lastNameController.text = "Amin";
      displayNameController.text = "noumanamin407";
      cedulaController.text = "1231245666";
      phoneController.text = "3008383978";
      cityController.text = "okara";
      emailController.text = "noumanamin407@gmail.com";
      passwordController.text = "Abc123@@@";
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
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                              height: 100,
                              width: 100,
                              child: ImagePickerWidget(
                                imagedPicked: _pickedImage,
                                function: () {
                                  pickImage();
                                },
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            height: 280,
                            decoration: BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.circular(18)),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: TextFormField(
                                        textCapitalization:
                                            TextCapitalization.words,
                                        controller: nameController,
                                        obscureText: false,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.normal),
                                            prefixIcon: const Icon(
                                              Icons.person_rounded,
                                              color: Colors.deepPurple,
                                            ),
                                            hintText: 'Nombre',
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(50))),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Ingrese su nombre";
                                          } else {
                                            null;
                                          }
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: TextFormField(
                                        textCapitalization:
                                            TextCapitalization.words,
                                        controller: lastNameController,
                                        obscureText: false,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.normal),
                                            hintText: 'Apellido',
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(50))),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Ingrese su apellido";
                                          } else {
                                            null;
                                          }
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: TextFormField(
                                        textCapitalization:
                                            TextCapitalization.words,
                                        controller: displayNameController,
                                        obscureText: false,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.normal),
                                            hintText: 'Usuario',
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(50))),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Establece un nombre de usuario";
                                          } else {
                                            null;
                                          }
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextFormField(
                                controller: cedulaController,
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15),
                                    hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                    prefixIcon: const Icon(
                                      Icons.numbers_rounded,
                                      color: Colors.deepPurple,
                                    ),
                                    hintText: 'Cédula de identidad',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(50))),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Ingrese su cédula de identidad";
                                  } else {
                                    null;
                                  }
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextFormField(
                                maxLength: 10,
                                controller: phoneController,
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15),
                                    hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                    prefixIcon: const Icon(
                                      Icons.phone,
                                      color: Colors.deepPurple,
                                    ),
                                    prefixText: '+58 ',
                                    prefixStyle: TextStyle(
                                        color: Colors.deepPurple, fontSize: 17),
                                    hintText: 'Ej.:4241234567',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(50))),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Ingrese su nro telefónico";
                                  } else {
                                    null;
                                  }
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                    hintText: "Selecciona tu ubicación",
                                    contentPadding: const EdgeInsets.all(15),
                                    hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(25))),
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                items: locationDropDownList,
                                value: _locationValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    _locationValue = value;
                                  });
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextFormField(
                                controller: emailController,
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15),
                                    hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                    prefixIcon: const Icon(
                                      Icons.email_rounded,
                                      color: Colors.deepPurple,
                                    ),
                                    hintText: 'Correo electrónico',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(50))),
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return "Ingrese un correo electrónico válido";
                                  } else {
                                    null;
                                  }
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextFormField(
                                controller: passwordController,
                                obscureText: visible,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15),
                                    hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                    prefixIcon: const Icon(
                                      Icons.lock_rounded,
                                      color: Colors.deepPurple,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(visible
                                          ? Icons.visibility
                                          : Icons.visibility_off_rounded),
                                      onPressed: () {
                                        setState(() {
                                          visible = !visible;
                                        });
                                      },
                                    ),
                                    hintText: 'Contraseña',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(50))),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Ingrese su contraseña";
                                  } else {
                                    null;
                                  }
                                }),
                          ),
                          const SizedBox(height: 10)
                        ],
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: CustomButton(
                    onTap: () async {
                      if (_pickedImage == null) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                title: Column(
                                  children: [
                                    Text(
                                        'Asegúrate de elegir una imagen para tu perfil.'),
                                  ],
                                ),
                              );
                            });
                        return;
                      }

                      if (_locationValue == null) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Selecciona tu ubicación'),
                                  ],
                                ),
                              );
                            });
                        return;
                      }

                      if (formKey.currentState!.validate()) {
                        /*if (nameController.text.isNotEmpty &&
                                    phoneController.text.isNotEmpty &&
                                    cityController.text.isNotEmpty &&
                                    (emailController.text.isNotEmpty ||
                                        !emailController.text.contains('@')) &&
                                    passwordController.text.isNotEmpty) {
                                  firestore.collection("user").add({
                                    "nombre y apellido": nameController.text,
                                    "teléfono": phoneController.text,
                                    "ciudad": cityController.text,
                                    "nombre y apellido": nameController.text,
                                    "email": emailController.text,
                                    "contraseña": passwordController.text,
                                  });
                                }*/

                        try {
                          setState(() {
                            isLoading = true;
                          });

                          var body = {
                            'displayName': displayNameController.text.trim(),
                            'userName': nameController.text.trim(),
                            'userLastName': lastNameController.text.trim(),
                            'cedula': cedulaController.text.trim(),
                            'phone': '+58${phoneController.text.trim()}',
                            'location': _locationValue,
                            'password': passwordController.text.trim(),
                            'userImage': userImageUrl,
                            'userEmail': emailController.text.toLowerCase(),
                            'createdAt': Timestamp.now(),
                            'userWish': [],
                            'points': 5,
                          };

                          String email =
                              emailController.text.toLowerCase().trim();
                          String password =
                              passwordController.text.trim().trim();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ImageWithIdScreen(
                              body: body,
                              profileImage: _pickedImage,
                              email: email,
                              password: password,
                              displayNameController: displayNameController,
                            );
                          }));

                          /*ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(seconds: 3),
                                        elevation: 10,
                                        content: Center(
                                          child: Text('¡Te has registrado con éxito!',
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),),
                                        ),
                                        backgroundColor: Colors.deepPurple,));*/
                          /*if (!mounted) return;
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context) {
                                        return Login();
                                      }), (route) => false);*/
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
                    text: 'Siguiente',
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
