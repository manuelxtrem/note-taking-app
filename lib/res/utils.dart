import 'dart:async';

import 'package:flutter/material.dart';

class Utils {
  static Route pageRoute(Widget page) {
    return MaterialPageRoute(builder: (context) => page);
  }
}

mixin DidBuild<T extends StatefulWidget> on State<T> {
  @protected
  void didBuild(BuildContext context);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      didBuild(context);
    });
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
