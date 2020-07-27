import 'dart:async';
import 'package:camera/camera.dart';
import 'package:color_lookup/color_picker/color_picker.dart';
import 'package:flutter/material.dart';

class CameraScreenController {
  CameraController _cameraController;
  int _currentCamera;
  List<CameraDescription> _availableCameras;

  final Function(Color color) onColorAvailable;

  CameraScreenController(
      {@required this.onColorAvailable});

  int get numCameras => _availableCameras.length;
  CameraController get cameraController => _cameraController;
  bool get backCamera =>
      _availableCameras[_currentCamera].lensDirection ==
      CameraLensDirection.back;

  Future<void> initialize() async {
    _availableCameras = await availableCameras();
    _currentCamera = 0;
    await _init();
  }

  Future<void> switchCamera() async {
    _currentCamera = (_currentCamera + 1) % _availableCameras.length;
    try {
      await dispose();
      await _init();
    } catch (e) {
      debugPrint(e);
    }
  }

  Future<void> _init() async {
    _cameraController = CameraController(
        _availableCameras[_currentCamera], ResolutionPreset.ultraHigh);

    await _cameraController.initialize();
    await _cameraController.startImageStream((cameraImage) {
      getCenterColor(cameraImage).then((color) {
        onColorAvailable(color);
      });
    });
  }

  Future<void> dispose() async {
    await _cameraController.stopImageStream();
    await _cameraController.dispose();
  }
}
