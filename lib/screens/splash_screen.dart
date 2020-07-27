import 'package:camera/new/camera.dart';
import 'package:color_lookup/screens/cameraScreen.dart';
import 'package:color_lookup/screens/permission_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  static const String ROUTE = "/splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    _splashPermissionCheck();
  }

  Future<void> _splashPermissionCheck() async {
    await Future.delayed(Duration(milliseconds: 200));
    var statuses = <Permission>[
      Permission.camera,
      Permission.microphone,
    ];

    var result = await statuses.request();
    bool granted = result[Permission.camera].isGranted &&
        result[Permission.microphone].isGranted;

    setState(() {
      _opacity = 1;
    });
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
      _opacity = 0;
    });
    await Future.delayed(Duration(milliseconds: 700));

    if (granted)
      Navigator.of(context).pushReplacementNamed(CameraScreen.ROUTE);
    else
      Navigator.of(context).pushReplacementNamed(PermissionScreen.ROUTE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, Colors.grey[400]],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: <Widget>[
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _opacity,
                child: Container(
                  height: constraints.maxHeight - 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: 128,
                          height: 128,
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.contain,
                          )),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Eyedropper",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.display1.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Text(
                "Created by Afridi Kayal",
                style: Theme.of(context).textTheme.caption,
              )
            ],
          );
        }),
      ),
    );
  }
}
