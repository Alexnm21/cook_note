import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/utils/image_utils.dart';

class ImageSelector extends StatelessWidget {
  final File? imageFile;
  final String imageUrl;
  final Function(File) onChange;
  final Function() onRemove;

  const ImageSelector({
    super.key,
    this.imageFile,
    required this.imageUrl,
    required this.onChange,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(16),
        ),
        child: imageFile != null || imageUrl.isNotEmpty == true
            ? _ImageSelected(
                imageFile: imageFile,
                imageUrl: imageUrl,
                onRemove: onRemove,
                onChange: onChange,
              )
            : GestureDetector(
                onTap: () async {
                  await selectImage(context, onImageSelected: onChange);
                },
                child: const _NoImage(),
              ));
  }
}

class _NoImage extends StatelessWidget {
  const _NoImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 48,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 8),
          Text(
            'image.select'.tr(),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageSelected extends StatelessWidget {
  final File? imageFile;
  final String imageUrl;
  final Function() onRemove;
  final Function(File) onChange;
  const _ImageSelected({
    required this.imageFile,
    required this.onRemove,
    required this.onChange,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: () async {
              await selectImage(context, onImageSelected: onChange);
            },
            child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.edit)),
          ),
        ),
        Positioned(
          top: 5,
          left: 5,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(Icons.close, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
