

/*class Injector extends InheritedWidget {
  final SheetService sheetService;
  final MainViewModel mainViewModel;
  final CharacterSheetViewModel characterSheetViewModel;
  final SettingsViewModel settingsViewModel;
  final HealSheetViewModel healSheetViewModel;
  final MjViewModel mjViewModel;
  Injector({
    required Key key,
    required this.sheetService,
    required this.mainViewModel,
    required this.characterSheetViewModel,
    required this.settingsViewModel,
    required this.mjViewModel,
    required this.healSheetViewModel,
    required Widget child,
  }) : super(key: key, child: child);

  static Injector of(BuildContext context)   {
    print("arf");
    print(context);
    print(context.dependOnInheritedWidgetOfExactType());
        return context.dependOnInheritedWidgetOfExactType()!;
  }

  @override
  bool updateShouldNotify(Injector oldWidget) {
    return sheetService != oldWidget.sheetService;
  }
}*/
