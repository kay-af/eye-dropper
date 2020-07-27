import 'package:color_lookup/screens/cameraScreen.dart';
import 'package:color_lookup/screens/permission_screen.dart';
import 'package:color_lookup/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp
  ]);
  runApp(ColorLookupApp());
}

class ColorLookupApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Eyedropper",
      routes: {
        CameraScreen.ROUTE: (context) => CameraScreen(),
        PermissionScreen.ROUTE: (context) => PermissionScreen(),
        SplashScreen.ROUTE: (context) => SplashScreen(),
      },
      initialRoute: SplashScreen.ROUTE,
    );
  }
}