import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // symmetric = 상하, 좌우를 지정하여 같은 값으로 padding을 줌
          padding: const EdgeInsets.symmetric(horizontal: 32),
          // infinity = 화면의 최대값
          // MediaQuery.of(context).size.width 와 같은 결과
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2),
              // svg image logo
              SvgPicture.asset(
                'lib/assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(height: 64),
              // textfield email
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(height: 24),
              // textfield password
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                // _emailController 를 사용하면 email 입력하면 같이 입력됨 *컨트롤러 분리 필수
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(height: 24),
              // login button
              InkWell(
                onTap: () {},
                child: Container(
                  child: const Text('login'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                  child: Container(),
                  flex: 2), // 위 아래로 같은 비율의 공간을 주어 내용이 가운데로 오게 함
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text(
                      '회원이 아니신가요?',
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      child: const Text(
                        '회원가입',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              )
              // sign up
            ],
          ),
        ),
      ),
    );
  }
}
