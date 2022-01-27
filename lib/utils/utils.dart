import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/* NOTE 사용자 이미지 추가 
        이미지를 추가하기 위해 image_picker 패키지 추가 
*/
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    // return File(_file.path); =>
    return _file.readAsBytes();
  }
  print('No image selected');
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
