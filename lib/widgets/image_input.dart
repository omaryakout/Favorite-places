import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  ImageInput({super.key, required this.onPickImage});

  void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? selectedImage;

  void takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content =
        IconButton(onPressed: takePicture, icon: const Icon(Icons.camera));

    if (selectedImage != null) {
      content = GestureDetector(
          onTap: takePicture,
          child: Image.file(
            selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
          ));
    }

    return Container(
      height: 220,
      width: double.infinity,
      child: content,
      alignment: Alignment.center,
       decoration: BoxDecoration(border:  Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),),
    );
  }
}
