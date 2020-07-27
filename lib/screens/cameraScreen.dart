import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:color_lookup/screens/cameraScreenController.dart';
import 'package:color_lookup/screens/colorInformation.dart';
import 'package:color_lookup/stateObserver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class CameraScreen extends StatefulWidget {
  static const String ROUTE = "/camera";

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraScreenController _cameraScreenController;
  Color _color = Colors.black;
  bool _loaded = false;
  StateObserver _appStateObserver;

  @override
  void initState() {
    super.initState();
    _appStateObserver = StateObserver(onStateChange: (state) {
      if (state == AppLifecycleState.paused) {
        debugPrint("Application paused");
        _cameraScreenController.dispose();
        _loaded = false;
      } else if (state == AppLifecycleState.resumed) {
        debugPrint("Application resumed");
        _cameraScreenController
            .initialize()
            .then((val) => setState(() => _loaded = true));
      }
    });
    _cameraScreenController = CameraScreenController(onColorAvailable: (color) {
      setState(() {
        _color = color;
      });
    });
    _cameraScreenController
        .initialize()
        .then((value) => setState(() => _loaded = true));
  }

  @override
  void dispose() {
    _cameraScreenController.dispose();
    _appStateObserver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: _loaded
          ? FloatingActionButton(
              backgroundColor: Colors.black54,
              elevation: 0.0,
              disabledElevation: 0.0,
              focusElevation: 0.0,
              highlightElevation: 0.0,
              hoverElevation: 0.0,
              child: Icon(Entypo.eye),
              onPressed: () async {
                await _showColorInformation(_color);
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text("Eyedropper"),
        backgroundColor: Colors.black38,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.0))),
        actions: <Widget>[
          IconButton(
              icon: Icon(FlutterIcons.camera_switch_mco),
              onPressed: () {
                if (_loaded) {
                  _cameraScreenController.switchCamera();
                }
              }),
        ],
        leading: IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () async {
              await _showAbout();
            }),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
          child: _loaded
              ? Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Positioned.fill(
                        child: Center(
                      child: CameraPreview(
                          _cameraScreenController.cameraController),
                    )),
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: _cameraScreenController
                                .cameraController.value.aspectRatio,
                            child: CameraPreview(
                                _cameraScreenController.cameraController),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Icon(
                        Entypo.eye,
                        color: _color,
                        size: 28,
                      ),
                    ),
                    Positioned.fill(
                      child: Icon(
                        Entypo.circle,
                        color: Colors.white.withOpacity(0.5),
                        size: 64,
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 20,
                      right: 20,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            gradient: LinearGradient(
                                colors: [Colors.black38, Colors.black54],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Point the eye at the color you want to inspect and press the button below to get the nearest color matches",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle
                              .apply(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    backgroundColor: Colors.grey,
                  ),
                )),
    );
  }

  Future<void> _showColorInformation(Color color) async {
    await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 0,
        context: context,
        builder: (context) {
          return Container(
            decoration: _gradientDecoration(),
            child: ColorInformationWidget(color: color),
          );
        });
  }

  Future<void> _showAbout() async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 2.0,
            child: Container(
              decoration: _gradientDecoration(),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Eyedropper",
                      style: Theme.of(context).textTheme.display1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "This app depends on Color tools API. Eyedropper demonstrates the use of the lookup API. Color tools is however freely hosted on Heroku at the moment and hence, performance might drop if a lot of users access the API at the same time",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "This app is open source. Source code can be found on my github page!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Divider(),
                    RaisedButton.icon(
                        color: Colors.grey[800],
                        textColor: Colors.white,
                        onPressed: () async =>
                            await launch("https://color-tools.herokuapp.com/"),
                        icon: Icon(Icons.brush),
                        label: Text("Visit Color Tools Website")),
                    RaisedButton.icon(
                        color: Colors.grey[800],
                        textColor: Colors.white,
                        onPressed: () async =>
                            await launch("https://www.github.com/kay-af"),
                        icon: Icon(FontAwesome.github),
                        label: Text("Visit my github page")),
                    Divider(),
                    Text(
                      "Created by Afridi Kayal!",
                      style: Theme.of(context).textTheme.caption,
                      textAlign: TextAlign.center,
                    ),
                    Divider(),
                    IconButton(
                        icon: Icon(Entypo.cross),
                        onPressed: () => Navigator.of(context).pop())
                  ],
                ),
              ),
            ),
          );
        });
  }

  BoxDecoration _gradientDecoration() => BoxDecoration(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[400]],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter));
}
