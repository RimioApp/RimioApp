import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({super.key, this.imagedPicked, required this.function});

  final XFile? imagedPicked;
  final Function()? function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: imagedPicked == null ?
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  border: Border.all(width: 0),
                  borderRadius: BorderRadius.circular(18),
                ),
              ) : Container(
                width: 200,
                height: 200,
                child: Image.file(File(imagedPicked!.path), fit: BoxFit.contain,
            ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.grey.shade100,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.add_photo_alternate, color: Colors.deepPurple, size: 20,),
                )),
          ),
        ],
      ),
    );
  }
}
