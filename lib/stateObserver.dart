import 'package:flutter/cupertino.dart';

class StateObserver extends WidgetsBindingObserver {
  
  final Function(AppLifecycleState) onStateChange;
  
  StateObserver({@required this.onStateChange}) {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    this.onStateChange(state);
  }
}