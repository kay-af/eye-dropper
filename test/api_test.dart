import 'package:color_lookup/api/color_tools.dart';
import 'package:color_lookup/color_picker/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test("Api should work", () async {
    var result =
        await APIHelper.colorLookup(color: Color3(red: 255, green: 0, blue: 0));
    expect(result.matches[0].name, "Red");
  });

  test("Color average", () {
    expect(
        averageColor(<Color>[
          Color.fromARGB(255, 0, 0, 0),
          Color.fromARGB(255, 255, 255, 255)
        ]),
        Color.fromARGB(255, 127, 127, 127));
  });
}
