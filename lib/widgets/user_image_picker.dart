import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function setImageFileCallback;

  const UserImagePicker({Key key, this.setImageFileCallback}) : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImageFile = File(pickedImageFile.path);
    });
    widget.setImageFileCallback(_pickedImageFile);
  }

  Future<void> _takeImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage == null) {
      return;
    }
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImageFile = File(pickedImageFile.path);
    });
    widget.setImageFileCallback(_pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage:
              (_pickedImageFile != null) ? FileImage(_pickedImageFile) : null,
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlatButton.icon(
                onPressed: _pickImage,
                icon: Icon(
                  Icons.image,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text(
                  'Select an image',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                )),
            FlatButton.icon(
                onPressed: _takeImage,
                icon: Icon(
                  Icons.camera,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text(
                  'Take image',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                )),
          ],
        )
      ],
    );
  }
}
