import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Future<Color> getCenterColor(CameraImage image) async {
  return await Future<Color>.microtask(() {
    int x = image.width ~/ 2;
    int y = image.height ~/ 2;

    return atPixel(x, y, image);
  });
}

int _clamp(int value, int lower, int higher) {
  if (value > higher)
    return higher;
  else if (value < lower)
    return lower;
  else
    return value;
}

Color atPixel(int x, int y, CameraImage image) {
  int width = image.width;

  int bytesPerRow = image.planes[1].bytesPerRow;
  int bytesPerPixel = image.planes[1].bytesPerPixel;

  int yIndex = y * width + x;
  int uvIndex = (bytesPerPixel * (x / 2) + bytesPerRow * (y / 2)).floor();

  return yuv2rgb(image.planes[0].bytes[yIndex], image.planes[1].bytes[uvIndex],
      image.planes[2].bytes[uvIndex]);
}

Color yuv2rgb(int y, int u, int v) {

  int rt = (y + v * 1436 / 1024 - 179).round();
  int gt = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
  int bt = (y + u * 1814 / 1024 - 227).round();

  int r = _clamp(rt, 0, 255);
  int g = _clamp(gt, 0, 255);
  int b = _clamp(bt, 0, 255);

  return Color.fromARGB(255, r, g, b);
}

Color averageColor(List<Color> colors) {
  List<int> reds = colors.map<int>((col) => col.red).toList();
  List<int> greens = colors.map<int>((col) => col.red).toList();
  List<int> blues = colors.map<int>((col) => col.red).toList();

  return Color.fromARGB(255, average(reds), average(greens), average(blues));
}

int average(List<int> values) {
  int total = values.reduce((a, b) => a + b);
  return total ~/ values.length;
}