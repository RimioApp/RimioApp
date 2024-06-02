import 'dart:io';

import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/providers/publish_provider.dart';
import 'package:Rimio/providers/user_provider.dart';
import 'package:Rimio/view/authPages/login.dart';
import 'package:Rimio/view/models/product_model.dart';
import 'package:Rimio/view/models/user_model.dart';
import 'package:Rimio/view/searchPage.dart';
import 'package:Rimio/widgets/customButton.dart';
import 'package:Rimio/widgets/image_picker_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';


class EditOrUploadService extends StatefulWidget {
  static const routeName = '/EditOrUploadProductScreen';
  const EditOrUploadService({super.key, this.productModel,});

  final ProductModel? productModel;

  @override
  State<EditOrUploadService> createState() => _EditOrUploadServiceState();
}

class _EditOrUploadServiceState extends State<EditOrUploadService> {

  late TextEditingController _titleController,
      _priceController,
      _descriptionController;

  final formKey = GlobalKey<FormState>();
  String? _categoryValue;
  String? _locationValue;
  String? _stateValue;

  bool isEditing = false;
  String? productNetworkImage1;
  String? productNetworkImage2;
  String? productNetworkImage3;
  String? productNetworkImage4;
  bool isLoading = false;
  String? productImageUrl1;
  String? productImageUrl2;
  String? productImageUrl3;
  String? productImageUrl4;

  @override
  void initState() {
    if (widget.productModel != null){
      isEditing = true;
      productNetworkImage1 = widget.productModel!.productImage1;
      productNetworkImage2 = widget.productModel!.productImage2;
      productNetworkImage3 = widget.productModel!.productImage3;
      productNetworkImage4 = widget.productModel!.productImage4;
    }
    _titleController = TextEditingController(text: widget.productModel?.productTitle);
    _priceController = TextEditingController(text: widget.productModel?.productPrice);
    _stateValue = widget.productModel?.productState;
    _descriptionController = TextEditingController(text: widget.productModel?.productDescription);
    _categoryValue = widget.productModel?.productCategory;
    fetchUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  List<String> categoriesList = [
    'Guitarras',
    'Bajos',
    'Baterias',
    'Teclados',
    'Folklore',
    'Orquesta',
    'Dj',
    'Micrófonos',
    'Aire',
    'Estudio',
    'Merch',
    'Iluminación',
    'Pedales',
    'Accesorios',
    'Repuestos'
  ];

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

  List<String> stateList = [
    'Por hora',
    'Por día',
    'A convenir',
  ];

  List<DropdownMenuItem<String>>? get categoriesDropDownList {
    List<DropdownMenuItem<String>>? menuItem =
    List<DropdownMenuItem<String>>.generate(
      categoriesList.length,
          (index) => DropdownMenuItem(
        value: categoriesList[index],
        child: Text(categoriesList[index]),
      ),
    );
    return menuItem;
  }

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

  List<DropdownMenuItem<String>>? get stateDropDownList {
    List<DropdownMenuItem<String>>? menuItem =
    List<DropdownMenuItem<String>>.generate(
      stateList.length,
          (index) => DropdownMenuItem(
        value: stateList[index],
        child: Text(stateList[index]),
      ),
    );
    return menuItem;
  }

  XFile? _pickedImage1;
  XFile? _pickedImage2;
  XFile? _pickedImage3;
  XFile? _pickedImage4;

  void localPickImage() async {
    await showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Center(child: Text('Elije una opción')),
        content: SizedBox(
          height: 170,
          width: 150,
          child: Column(
            children: [
              const SizedBox(height: 5,),
              TextButton.icon(
                onPressed: (){
                  camaraPicker();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.camera_alt_rounded, color: Colors.deepPurple, size: 30,),
                label: const Text('Cámara', style: TextStyle(fontSize: 18),),
              ),
              const SizedBox(height: 5,),
              TextButton.icon(
                onPressed: (){
                  galeriaPicker1();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.image, color: Colors.deepPurple, size: 30,),
                label: const Text('Galería', style: TextStyle(fontSize: 18),),
              ),
              const SizedBox(height: 5,),
              TextButton.icon(
                onPressed: (){
                  _pickedImage1 = null;
                  productNetworkImage1 = null;
                  setState(() {});
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.clear, color: Colors.redAccent, size: 30,),
                label: const Text('Eliminar', style: TextStyle(fontSize: 18),),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> camaraPicker() async {
    final ImagePicker imagePicker = ImagePicker();
    _pickedImage1 = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }
  Future<void> galeriaPicker1() async {
    final ImagePicker imagePicker = ImagePicker();
    _pickedImage1 = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }
  Future<void> galeriaPicker2() async {
    final ImagePicker imagePicker = ImagePicker();
    _pickedImage2 = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }
  Future<void> galeriaPicker3() async {
    final ImagePicker imagePicker = ImagePicker();
    _pickedImage3 = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }
  Future<void> galeriaPicker4() async {
    final ImagePicker imagePicker = ImagePicker();
    _pickedImage4 = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  final auth = FirebaseAuth.instance;

  UserModel? userModel;
  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;

  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      userModel = await userProvider.fetchUserInfo();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    final publishProvider = Provider.of<PublishProvider>(context);

    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white38,),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                if(isEditing == true) ... [
                                  if (_pickedImage1 == null)
                                    GestureDetector(
                                      onTap: galeriaPicker1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          children:[
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(21),
                                              child: GestureDetector(
                                                  onTap: galeriaPicker1,
                                                  child: Image.network(productNetworkImage1!)
                                              ),
                                            ),
                                            /*IconButton(
                                            onPressed: (){setState(() {
                                              _pickedImage4 = null;
                                            });},
                                            icon: const Icon(Icons.remove_circle_rounded, color: Colors.red, size: 30,))*/
                                          ],
                                        ),
                                      ),
                                    ) else Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(21),
                                          child: GestureDetector(
                                            onTap: galeriaPicker1,
                                            child: Image.file(File(_pickedImage1!.path)),
                                          ),
                                        ),
                                        /*IconButton(
                                            onPressed: (){setState(() {
                                              _pickedImage4 = null;
                                            });},
                                            icon: const Icon(Icons.remove_circle_rounded, color: Colors.red, size: 30,))*/
                                      ],
                                    ),
                                  ),
                                  if (_pickedImage2 == null)
                                    GestureDetector(
                                      onTap: galeriaPicker2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          children:[
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(21),
                                              child: GestureDetector(
                                                  onTap: galeriaPicker2,
                                                  child: Image.network(productNetworkImage2!)
                                              ),
                                            ),
                                            /*IconButton(
                                            onPressed: (){setState(() {
                                              _pickedImage4 = null;
                                            });},
                                            icon: const Icon(Icons.remove_circle_rounded, color: Colors.red, size: 30,))*/
                                          ],
                                        ),
                                      ),
                                    ) else Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(21),
                                          child: GestureDetector(
                                            onTap: galeriaPicker2,
                                            child: Image.file(File(_pickedImage2!.path)),
                                          ),
                                        ),
                                        /*IconButton(
                                            onPressed: (){setState(() {
                                              _pickedImage4 = null;
                                            });},
                                            icon: const Icon(Icons.remove_circle_rounded, color: Colors.red, size: 30,))*/
                                      ],
                                    ),
                                  ),
                                  if (_pickedImage3 == null) GestureDetector(
                                    onTap: galeriaPicker3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        children:[
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(21),
                                            child: GestureDetector(
                                                onTap: galeriaPicker3,
                                                child: Image.network(productNetworkImage3!)
                                            ),
                                          ),
                                          /*IconButton(
                                            onPressed: (){setState(() {
                                              _pickedImage4 = null;
                                            });},
                                            icon: const Icon(Icons.remove_circle_rounded, color: Colors.red, size: 30,))*/
                                        ],
                                      ),
                                    ),
                                  ) else Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(21),
                                          child: GestureDetector(
                                            onTap: galeriaPicker3,
                                            child: Image.file(File(_pickedImage3!.path)),
                                          ),
                                        ),
                                        /*IconButton(
                                            onPressed: (){setState(() {
                                              _pickedImage4 = null;
                                            });},
                                            icon: const Icon(Icons.remove_circle_rounded, color: Colors.red, size: 30,))*/
                                      ],
                                    ),
                                  ),
                                  if (_pickedImage4 == null) GestureDetector(
                                    onTap: galeriaPicker4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        children:[
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(21),
                                            child: GestureDetector(
                                                onTap: galeriaPicker4,
                                                child: Image.network(productNetworkImage4!)
                                            ),
                                          ),
                                          /*IconButton(
                                            onPressed: (){setState(() {
                                              _pickedImage4 = null;
                                            });},
                                            icon: const Icon(Icons.remove_circle_rounded, color: Colors.red, size: 30,))*/
                                        ],
                                      ),
                                    ),
                                  ) else Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(21),
                                          child: GestureDetector(
                                            onTap: galeriaPicker4,
                                            child: Image.file(File(_pickedImage4!.path)),
                                          ),
                                        ),
                                        /*IconButton(
                                            onPressed: (){setState(() {
                                              _pickedImage4 = null;
                                            });},
                                            icon: const Icon(Icons.remove_circle_rounded, color: Colors.red, size: 30,))*/
                                      ],
                                    ),
                                  ),
                                ] else ... [
                                  if (_pickedImage1 == null)
                                    GestureDetector(
                                      onTap: galeriaPicker1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          children:[
                                            Container(
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius: BorderRadius.circular(21),
                                              ),
                                            ),
                                            const Positioned(
                                                right: 60,
                                                top: 70,
                                                child: Icon(Icons.add_photo_alternate_outlined, color: Colors.white,))
                                          ],
                                        ),
                                      ),
                                    ) else Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(21),
                                          child: GestureDetector(
                                            onTap: galeriaPicker1,
                                            child: Image.file(File(_pickedImage1!.path)),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: (){setState(() {
                                              _pickedImage1 = null;
                                            });},
                                            icon: const Icon(Icons.remove_circle_rounded, color: Colors.red, size: 30,))
                                      ],
                                    ),
                                  ),
                                  if (_pickedImage2 == null)
                                    GestureDetector(
                                      onTap: galeriaPicker2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          children:[
                                            Container(
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius: BorderRadius.circular(21),
                                              ),
                                            ),
                                            const Positioned(
                                                right: 60,
                                                top: 70,
                                                child: Icon(Icons.add_photo_alternate_outlined, color: Colors.white,))
                                          ],
                                        ),
                                      ),
                                    ) else Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(21),
                                          child: GestureDetector(
                                            onTap: galeriaPicker2,
                                            child: Image.file(File(_pickedImage2!.path)),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: (){
                                              setState(() {
                                                _pickedImage2 = null;
                                              });},
                                            icon: const Icon(Icons.remove_circle_rounded, color: Colors.red, size: 30,))
                                      ],
                                    ),
                                  ),
                                  if (_pickedImage3 == null) GestureDetector(
                                    onTap: galeriaPicker3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        children:[
                                          Container(
                                            width: 150,
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius: BorderRadius.circular(21),
                                            ),
                                          ),
                                          const Positioned(
                                              right: 60,
                                              top: 70,
                                              child: Icon(Icons.add_photo_alternate_outlined, color: Colors.white,))
                                        ],
                                      ),
                                    ),
                                  ) else Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(21),
                                          child: GestureDetector(
                                            onTap: galeriaPicker3,
                                            child: Image.file(File(_pickedImage3!.path)),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: (){setState(() {
                                              _pickedImage3 = null;
                                            });},
                                            icon: const Icon(Icons.remove_circle_rounded, color: Colors.red, size: 30,))
                                      ],
                                    ),
                                  ),
                                  if (_pickedImage4 == null) GestureDetector(
                                    onTap: galeriaPicker4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        children:[
                                          Container(
                                            width: 150,
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius: BorderRadius.circular(21),
                                            ),
                                          ),
                                          const Positioned(
                                              right: 60,
                                              top: 70,
                                              child: Icon(Icons.add_photo_alternate_outlined, color: Colors.white,))
                                        ],
                                      ),
                                    ),
                                  ) else Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(21),
                                          child: GestureDetector(
                                            onTap: galeriaPicker4,
                                            child: Image.file(File(_pickedImage4!.path)),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: (){setState(() {
                                              _pickedImage4 = null;
                                            });},
                                            icon: const Icon(Icons.remove_circle_rounded, color: Colors.red, size: 30,))
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('¿Que servicio deseas ofrecer?', style: TextStyle(fontSize: 15, color: Colors.grey.shade800),),
                              GestureDetector(
                                  onTap: (){
                                    showDialog(context: (context), builder: (context){
                                      return const AlertDialog(
                                        title: Text('Asegúrate de usar palabras claves que mejoren tu alcance.', style: TextStyle(fontSize: 15),),
                                      );
                                    });
                                  },
                                  child: const Icon(Icons.info_rounded, color: Colors.white, size: 30,)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 400,
                          child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: _titleController,
                              maxLength: 80,
                              obscureText: false,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(10),
                                  hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                                  hintText: 'Alquiler, luthier, servicio técnico, roadie...',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(25)
                                  )
                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Ingresa el nombre tu artículo.";
                                }else{
                                  null;
                                }
                              }
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('Ingresa tu método de cobro y precio', style: TextStyle(fontSize: 15, color: Colors.grey.shade800),),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 175,
                              child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(10),
                                      hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(25)
                                      )
                                  ),
                                  dropdownColor: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  items: stateDropDownList,
                                  value: _stateValue,
                                  hint: const Text("Cobro"),
                                  onChanged: (String? value) {
                                    setState(() {
                                      _stateValue = value;
                                    });
                                  }),
                            ),
                            const SizedBox(width: 40,),
                            SizedBox(
                              width: 150,
                              child: TextFormField(
                                enabled: _stateValue == 'A convenir' ? false:true,
                                  controller: _priceController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                      prefixIcon:  Icon(Icons.attach_money_rounded, color: _stateValue == 'A convenir' ? Colors.white:Colors.grey.shade800,),
                                      contentPadding: const EdgeInsets.all(10),
                                      hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                                      hintText: 'Precio',
                                      filled: true,
                                      fillColor: _stateValue == 'A convenir' ? Colors.grey.shade200:Colors.white,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(25)
                                      )
                                  ),
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return _stateValue == 'A convenir' ? null:"Ingresa el precio.";
                                    }else{
                                      null;
                                    }
                                  }
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        SizedBox(
                          width: 400,
                          child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: _descriptionController,
                              maxLines: 5,
                              maxLength: 1000,
                              obscureText: false,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                                  hintText: 'Descripción',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(25)
                                  )
                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Ingresa la descripción de tu artículo.";
                                }else{
                                  null;
                                }
                              }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomButton(
                  onTap: () async {

                    if ((_pickedImage1 == null) && isEditing == false){
                      showDialog(context: context, builder: (context){
                        return const AlertDialog(
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Asegúrate de elegir al menos una imágen de tu servicio'),
                            ],
                          ),
                        );
                      });
                      return;
                    }

                    if (_stateValue != 'Por hora' && _stateValue!='Por día' && _stateValue!='A convenir'){
                      showDialog(context: context, builder: (context){
                        return const AlertDialog(
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Ingresa el tipo de cobro y precio'),
                            ],
                          ),
                        );
                      });
                      return;
                    }

                    if(isEditing == true){
                      showDialog(context: context, builder: (context){
                        return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.deepPurple,
                            ));
                      });

                      try {
                        setState(() {
                          isLoading = true;
                        });


                        UserModel? userModel;
                        User? user = FirebaseAuth.instance.currentUser;

                        /// FETCHING DE DATOS DEL USUARIO
                        try{
                          final userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

                          final userDocDict = userDoc.data() as Map<String, dynamic>?;

                          userModel = UserModel(
                            userId: userDoc.get('userId'),
                            userName: userDoc.get('userName'),
                            userLastName: userDoc.get('userLastName'),
                            displayName: userDoc.get('displayName'),
                            phone: userDoc.get('phone'),
                            location: userDoc.get('location'),
                            userImage: userDoc.get('userImage'),
                            userEmail: userDoc.get('userEmail'),
                            createdAt: userDoc.get('createdAt'),
                            points: userDoc.get('points'),
                            userWish: userDocDict!.containsKey("userWish") ? userDoc.get("userWish") : [],);
                        } on FirebaseException catch(e){
                          rethrow;
                        }catch(e){
                          rethrow;
                        }
                        /// /// /// /// /// /// /// ///


                        await FirebaseFirestore.instance.collection("products").doc('${_titleController.text} ID:${widget.productModel!.productId}').update({
                          'productTitle': _titleController.text,
                          'productPrice': '${_priceController.text}',
                          'productCategory': _categoryValue,
                          'productState': _stateValue,
                          'productDescription': _descriptionController.text,
                        });

                        Navigator.of(context).pop(MaterialPageRoute(builder: (context){
                          return const SearchPage();
                        }));

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 3),
                              elevation: 10,
                              content: Center(
                                child: Text('servicio editado... En breve serán publicados los cambios.',
                                  style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 15),),
                              ),
                              backgroundColor: Colors.white,));
                        if (!mounted) return;
                        Navigator.of(context).pop(MaterialPageRoute(builder: (context){
                          return const SearchPage();
                        }));
                      } catch (e) {
                        print(e);
                      } finally {
                        isLoading = false;
                      }

                      if (_pickedImage1 == null){
                        print('null');
                      }
                    } else if (formKey.currentState!.validate()) {

                      showDialog(context: context, builder: (context){
                        return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.deepPurple,
                            ));
                      });

                      try {

                        setState(() {
                          isLoading = true;
                        });

                        final ref1 = FirebaseStorage.instance.ref().child('productsImages').child('1${_titleController.text.trim()}.jpg');
                        await ref1.putFile(File(_pickedImage1!.path));
                        productImageUrl1 = await ref1.getDownloadURL();

                        final ref2 = FirebaseStorage.instance.ref().child('productsImages').child('2${_titleController.text.trim()}.jpg');
                        await ref2.putFile(File(_pickedImage2!.path));
                        productImageUrl2 = await ref2.getDownloadURL();

                        final ref3 = FirebaseStorage.instance.ref().child('productsImages').child('3${_titleController.text.trim()}.jpg');
                        await ref3.putFile(File(_pickedImage3!.path));
                        productImageUrl3 = await ref3.getDownloadURL();

                        final ref4 = FirebaseStorage.instance.ref().child('productsImages').child('${_titleController.text.trim()}.jpg');
                        await ref4.putFile(File(_pickedImage4!.path));
                        productImageUrl4 = await ref4.getDownloadURL();


                        UserModel? userModel;
                        User? user = FirebaseAuth.instance.currentUser;

                        /// FETCHING DE DATOS DEL USUARIO
                        try{
                          final userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

                          final userDocDict = userDoc.data() as Map<String, dynamic>?;

                          userModel = UserModel(
                            userId: userDoc.get('userId'),
                            userName: userDoc.get('userName'),
                            userLastName: userDoc.get('userLastName'),
                            displayName: userDoc.get('displayName'),
                            phone: userDoc.get('phone'),
                            location: userDoc.get('location'),
                            userImage: userDoc.get('userImage'),
                            userEmail: userDoc.get('userEmail'),
                            createdAt: userDoc.get('createdAt'),
                            points: userDoc.get('points'),
                            userWish: userDocDict!.containsKey("userWish") ? userDoc.get("userWish") : [],);
                        } on FirebaseException catch(e){
                          rethrow;
                        }catch(e){
                          rethrow;
                        }
                        /// /// /// /// /// /// /// ///

                        final productId = const Uuid().v4();
                        await FirebaseFirestore.instance.collection("products").doc('${_titleController.text} ID:$productId').set({
                          'productId': productId,
                          'userId': user.uid,
                          'userEmail': user.email,
                          'displayName': user.displayName,
                          'userPhone': userModel.phone,
                          'userLocation': userModel.location,
                          'userImage': user.photoURL,
                          'productTitle': _titleController.text,
                          'productPrice': _stateValue == 'A convenir' ? 'Consulta precio':'${_priceController.text}',
                          'productImage1': productImageUrl1,
                          'productImage2': productImageUrl2,
                          'productImage3': productImageUrl3,
                          'productImage4': productImageUrl4,
                          'productCategory': 'Servicios',
                          'productState': _stateValue,
                          'userPoints': userModel.points,
                          'productDescription': _descriptionController.text,
                          'createdAt': Timestamp.now(),
                          'publicar': false,
                          'servicio':true,
                          'vendido': false,
                          'calificado': false,
                        });

                        await FirebaseFirestore.instance.collection("products").doc('${_titleController.text} ID:$productId').collection('preguntas').add({});

                        try {
                          await publishProvider.addToUserPublishListFirebase(
                            productId: productId,
                            context: context,
                          );
                          await publishProvider.fetchUserPublishlist();
                        } catch (e) {

                        } finally {

                        }

                        Navigator.of(context).pop(MaterialPageRoute(builder: (context){
                          return const SearchPage();
                        }));

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 3),
                              elevation: 10,
                              content: Center(
                                child: Text('Servicio en revisión... En breve será publicado.',
                                  style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 15),),
                              ),
                              backgroundColor: Colors.white,));
                        if (!mounted) return;
                        Navigator.of(context).pop(MaterialPageRoute(builder: (context){
                          return const SearchPage();
                        }));
                      } catch (e) {
                        print(e);
                      } finally {
                        isLoading = false;
                      }
                    } else {
                      if (formKey.currentState!.validate()) {
                        if (_pickedImage1 == null &&
                            productNetworkImage1 == null && _pickedImage2 == null &&
                            productNetworkImage2 == null && _pickedImage3 == null &&
                            productNetworkImage3 == null && _pickedImage4 == null &&
                            productNetworkImage4 == null) {
                          await showDialog(context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Column(
                                    children: [
                                      const Text('Selecciona una imagen'),
                                      Row(
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Entendido',
                                                style: TextStyle(fontSize: 20,
                                                    fontWeight: FontWeight
                                                        .bold),)),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                          return;
                        }
                        Navigator.pop(context,
                            MaterialPageRoute(builder: (context) {
                              return const EditOrUploadService();
                            }));
                      }
                    }
                  },
                  height: 50,
                  width: 300,
                  color: Colors.white,
                  radius: 50,
                  text: isEditing ? 'Guardar cambios':'Publicar',
                  fontSize: 20,
                  textColor: Colors.deepPurple,
                  shadow: 8,
                  colorShadow: Colors.white38),
            )
          ],
        ),
      ),
    );
  }
}
