import 'package:flutter/cupertino.dart';
import 'package:lsr/domain/services/CharacterService.dart';

class Injector extends InheritedWidget {
  final CharacterService characterService;

  Injector({
    required Key key,
    required this.characterService,
    required Widget child,
  }) : super(key: key, child: child);

  static Injector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType()!;

  @override
  bool updateShouldNotify(Injector oldWidget) {
    return characterService != oldWidget.characterService;
  }
}
