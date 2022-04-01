
import 'package:flutter/cupertino.dart';
import 'package:veggieseasons/widgets/count_container.dart';

class Counter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CountContainer? state = CountContainer.of(context);

    return Text('my count:${state!.count}');
  }

}