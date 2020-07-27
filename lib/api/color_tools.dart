import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

const endPoint = "https://color-tools.herokuapp.com/api/v1/lookup?match=5&q=";

class APIHelper {
  static Future<MatchInfo> colorLookup({@required Color3 color}) async {
    String query = "${color.red},${color.green},${color.blue}";
    var response = await get(endPoint + query);
    Map<String, dynamic> responseMap = jsonDecode(response.body);
    return MatchInfo.fromMap(responseMap);
  }
}

class MatchInfo {
  final String status;
  final String cause;
  final Color3 queryColor;
  final List<ColorInfo> matches;

  MatchInfo({@required this.status, this.cause, this.queryColor, this.matches});

  factory MatchInfo.fromMap(Map<String, dynamic> data) {
    String status = data["status"];
    if (status == "success") {
      Color3 queryColor = Color3.fromMap(data["given_color"]);
      List<ColorInfo> matches = (data["matches"] as List)
          .map<ColorInfo>((cInfo) => ColorInfo.fromMap(cInfo))
          .toList();
      return MatchInfo(
          status: status, queryColor: queryColor, matches: matches);
    } else {
      return MatchInfo(status: status, cause: data["cause"]);
    }
  }
}

class ColorInfo {
  final Color3 color;
  final String name;

  ColorInfo({@required this.color, @required this.name});

  factory ColorInfo.fromMap(Map<String, dynamic> data) {
    Color3 color = Color3.fromMap(data["color"]);
    String name = data["name"];
    return ColorInfo(color: color, name: name);
  }
}

class Color3 {
  final int red;
  final int green;
  final int blue;

  Color3({@required this.red, @required this.green, @required this.blue});

  factory Color3.fromMap(Map<String, dynamic> data) {
    int red = data["red"];
    int green = data["green"];
    int blue = data["blue"];
    return Color3(red: red, green: green, blue: blue);
  }

  factory Color3.fromColor(Color color) {
    return Color3(red: color.red, green: color.green, blue: color.blue);
  }

  Color toColor() {
    return Color.fromARGB(255, this.red, this.green, this.blue);
  }

  String toHex() {
    int value = this.red << 16 | this.green << 8 | this.blue;
    String hex = value.toRadixString(16);
    hex = hex.padRight(6, "0").toUpperCase();
    return "#$hex";
  }
}
