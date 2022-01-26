import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder, // textField가 선택되었을 때 나오는 테두리
        enabledBorder: inputBorder, // 오류가 나지 않았을 때 표시되는 테두리
        filled: true, // true의 경우 decoration container가 fillColor로 채워짐
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType, // 보여지는 키보드의 종류
      obscureText: isPass, // 패스워드 *처리
    );
  }
}
