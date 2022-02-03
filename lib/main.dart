import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import 'package:instagram_clone_flutter/screens/sign_up_screen.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Platform class 에서 platform 구분
  // isAndroid / isIOS / isMacOS / isWindows / isLinux / isFuchsia / kIsWeb(웹만 조금 특이함. korea is web)
  if (kIsWeb) {
    // Firebasee.initializeApp() 을 사용하지 않으면 firebase의 instance를 못 가져옴
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCRRzUVBd8ZPE6SDn9Yq_cc_bEz63ob0og",
        appId: "AIzaSyCRRzUVBd8ZPE6SDn9Yq_cc_bEz63ob0og",
        messagingSenderId: "734241122966",
        projectId: "instagram-clone-flutter-1e116",
        storageBucket: "instagram-clone-flutter-1e116.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // root Widget
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'instagram clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        // SECTION LoginScreen의 화면에 띄우기 전에 처리되는 것

        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                  backgroundColor: Colors.black87,
                ),
              );
            }
            // !SECTION
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
