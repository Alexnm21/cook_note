import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> selectImage(
  BuildContext context, {
  required Function(File) onImageSelected,
}) async {
  final ImagePicker picker = ImagePicker();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('image.select'.tr()),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              child: InkWell(
                onTap: () async {
                  final XFile? pickedFile =
                      await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    onImageSelected(File(pickedFile.path));
                  }
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.camera_alt),
                      Text('image.takePhoto'.tr()),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: InkWell(
                radius: 16,
                onTap: () async {
                  final XFile? pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    onImageSelected(File(pickedFile.path));
                  }
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.photo_library),
                      Text('image.chooseFromGallery'.tr()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
