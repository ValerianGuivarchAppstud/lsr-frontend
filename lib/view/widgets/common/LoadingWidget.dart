import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  LoadingWidget({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
