import 'package:flutter/cupertino.dart';
import 'package:lsr/domain/services/SheetService.dart';

class Injector extends InheritedWidget {
  final SheetService sheetService;

  Injector({
    required Key key,
    required this.sheetService,
    required Widget child,
  }) : super(key: key, child: child);

  static Injector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType()!;

  @override
  bool updateShouldNotify(Injector oldWidget) {
    return sheetService != oldWidget.sheetService;
  }
}
