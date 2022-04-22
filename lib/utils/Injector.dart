import 'package:flutter/cupertino.dart';
import 'package:lsr/domain/services/SheetService.dart';
import 'package:lsr/view/modules/character/CharacterSheetViewModel.dart';

class Injector extends InheritedWidget {
  final SheetService sheetService;
  final CharacterSheetViewModel characterSheetViewModel;

  Injector({
    required Key key,
    required this.sheetService,
    required this.characterSheetViewModel,
    required Widget child,
  }) : super(key: key, child: child);

  static Injector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType()!;

  @override
  bool updateShouldNotify(Injector oldWidget) {
    return sheetService != oldWidget.sheetService;
  }
}
