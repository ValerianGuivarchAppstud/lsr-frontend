import 'package:flutter/cupertino.dart';
import 'package:lsr/domain/services/SheetService.dart';
import 'package:lsr/view/modules/character/CharacterSheetViewModel.dart';

import '../view/modules/mj/MjViewModel.dart';
import '../view/modules/settings/SettingsViewModel.dart';

class Injector extends InheritedWidget {
  final SheetService sheetService;
  final CharacterSheetViewModel characterSheetViewModel;
  final SettingsViewModel settingsViewModel;
  final MjViewModel mjViewModel;

  Injector({
    required Key key,
    required this.sheetService,
    required this.characterSheetViewModel,
    required this.settingsViewModel,
    required this.mjViewModel,
    required Widget child,
  }) : super(key: key, child: child);

  static Injector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType()!;

  @override
  bool updateShouldNotify(Injector oldWidget) {
    return sheetService != oldWidget.sheetService;
  }
}
