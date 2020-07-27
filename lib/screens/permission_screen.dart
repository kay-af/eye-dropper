import 'package:color_lookup/screens/cameraScreen.dart';
import 'package:color_lookup/stateObserver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatefulWidget {
  static const String ROUTE = "/permission";

  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  PermissionStatus _status;

  @override
  void initState() {
    super.initState();
    _handlePermission();
  }

  Future<void> _handlePermission() async {
    var result = await _checkPermission();
    if (result.isGranted) {
      await Navigator.of(context).pushReplacementNamed(CameraScreen.ROUTE);
    } else {
      setState(() {
        _status = result;
      });
    }
  }

  Future<PermissionStatus> _checkPermission() async {
    var statuses = <Permission>[
      Permission.camera,
      Permission.microphone,
    ];

    var result = await statuses.request();

    var camera = result[Permission.camera];
    var microphone = result[Permission.microphone];

    if (camera.isGranted && microphone.isGranted) {
      return PermissionStatus.granted;
    } else {
      if (camera.isRestricted || microphone.isRestricted) {
        return PermissionStatus.restricted;
      } else if (camera.isPermanentlyDenied || microphone.isPermanentlyDenied) {
        return PermissionStatus.permanentlyDenied;
      } else if (camera.isDenied || microphone.isDenied) {
        return PermissionStatus.denied;
      } else {
        return PermissionStatus.undetermined;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Checking Permissions",
          ),
          elevation: 0,
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, contstraints) {
              if (_status == PermissionStatus.denied) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Entypo.info_with_circle,
                        size: 64,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Some permissions are denied for this session! Please allow them to continue.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      RaisedButton(
                          onPressed: () async {
                            await _handlePermission();
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Text("Request permissions"))
                    ],
                  ),
                );
              } else if (_status == PermissionStatus.permanentlyDenied) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Entypo.warning,
                        size: 64,
                        color: Colors.redAccent,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Some permissions are permanently denied! Please enable them from the app settings",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Microphone access is just a dependency for the Camera API used in this App. No data will be recorded!",
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      RaisedButton(
                          onPressed: () async {
                            await openAppSettings();
                            await _handlePermission();
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Text("App settings"))
                    ],
                  ),
                );
              } else if (_status.isRestricted) {
                Center(
                  child: Text(
                    "Sorry, the OS has restricted camera usage! Try again later",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.redAccent),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ));
  }
}
