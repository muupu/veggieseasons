

import 'package:flutter/cupertino.dart';

class CountContainer extends InheritedWidget {
  CountContainer( {Key? key,
    required this.count,
    required Widget child
  }) : super(key: key, child: child);


  static CountContainer? of(BuildContext context) {
    CountContainer? container = context.dependOnInheritedWidgetOfExactType<CountContainer>();
    return container;
  }

  final int count;

  @override
  bool updateShouldNotify(CountContainer oldWidget) => count != oldWidget.count;
}