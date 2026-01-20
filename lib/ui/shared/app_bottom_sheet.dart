import 'package:flutter/cupertino.dart';

class AppBottomSheet extends StatelessWidget {
  final Widget _child;

  const AppBottomSheet({super.key, required Widget child}) : _child = child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context)
        .viewInsets
        .bottom),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: _child
      ),
    );
  }
}