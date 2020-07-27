import 'package:color_lookup/api/color_tools.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorInformationWidget extends StatefulWidget {
  final Color color;

  ColorInformationWidget({@required this.color, Key key}) : super(key: key);

  @override
  _ColorInformationWidgetState createState() => _ColorInformationWidgetState();
}

class _ColorInformationWidgetState extends State<ColorInformationWidget> {
  bool _resultLoaded = false;
  bool _error = false;
  MatchInfo _info;

  @override
  void initState() {
    super.initState();
    APIHelper.colorLookup(color: Color3.fromColor(widget.color)).then((val) {
      setState(() {
        _resultLoaded = true;
        _info = val;
      });
    }).catchError((err) {
      setState(() {
        _error = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _getColorCirclePreview(widget.color),
              SizedBox(
                width: 16,
              ),
              Container(child: Text("Input color")),
            ],
          ),
          Divider(
            color: Colors.black,
            height: 36,
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              if (_resultLoaded) {
                var matchInfo = _info;

                if (!_error && matchInfo.status == "success") {
                  return ListView.separated(
                    separatorBuilder: (context, i) => Divider(),
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemBuilder: (context, i) {
                      if (i == 0)
                        return Text(
                          "Matches",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.title,
                        );
                      var colorInfo = matchInfo.matches[i - 1];
                      return ListTile(
                        dense: true,
                        subtitle: Text(colorInfo.color.toHex()),
                        leading:
                            _getColorCirclePreview(colorInfo.color.toColor()),
                        onTap: () async {
                          await Clipboard.setData(
                              ClipboardData(text: colorInfo.color.toHex()));

                          showFlash(
                              context: context,
                              duration: const Duration(milliseconds: 2000),
                              builder: (context, controller) {
                                return Flash.bar(
                                  backgroundColor: Colors.white.withAlpha(200),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  margin:
                                      EdgeInsets.fromLTRB(16.0, 80, 16, 16),
                                  controller: controller,
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                        "Hex code ${colorInfo.color.toHex()} for ${colorInfo.name} copied to clipboard"),
                                  ),
                                  position: FlashPosition.top,
                                  style: FlashStyle.floating,
                                );
                              });
                        },
                        title: Text(colorInfo.name),
                      );
                    },
                    itemCount: matchInfo.matches.length + 1,
                  );
                } else {
                  return Center(
                    child: Text(
                        "There was an error retreiving information! Check internet connection!"),
                  );
                }
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text("Fetching information!")
                    ],
                  ),
                );
              }
            }),
          )
        ],
      ),
    );
  }

  Widget _getColorCirclePreview(Color color) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.grey[200], width: 4)),
    );
  }
}
