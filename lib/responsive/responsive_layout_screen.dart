import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/utils/global_variable.dart';
import 'package:provider/provider.dart';

// 현재 화면의 크기에 따라 웹 스크린과 모바일 스크린을 나눠서 보여줌
class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout(
      {Key? key,
      required this.webScreenLayout,
      required this.mobileScreenLayout})
      : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        /*
          constraints -> width의 최소값/최대값, height의 최소값/최대값 으로 구성됨
          부모 위젯은 자신의 constraints 를 자식위젯에게 알려주면 자식 위젯은 size와 자신의 contraints를 return함 
         */
        if (constraints.maxWidth > webScreenSize) {
          // web screen
          return widget.webScreenLayout;
        }
        // mobile screen
        return widget.mobileScreenLayout;
      },
    );
  }
}
