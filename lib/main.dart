import 'package:flutter/material.dart';
import 'package:lsr/data/api/mj/MjProvider.dart';
import 'package:lsr/data/api/settings/SettingsProvider.dart';
import 'package:lsr/data/storage/StorageProvider.dart';
import 'package:lsr/domain/services/SettingsService.dart';
import 'package:lsr/domain/services/SheetService.dart';
import 'package:lsr/utils/Injector.dart';
import 'package:lsr/utils/api/NetworkingConfig.dart';
import 'package:lsr/view/modules/character/CharacterSheetScreen.dart';
import 'package:lsr/view/modules/character/CharacterSheetViewModel.dart';
import 'package:lsr/view/modules/mj/MjScreen.dart';
import 'package:lsr/view/modules/mj/MjViewModel.dart';
import 'package:lsr/view/modules/settings/SettingsScreen.dart';
import 'package:lsr/view/modules/settings/SettingsViewModel.dart';
import 'package:lsr/view/widgets/fonts/FontIconCharacter.dart';

import 'config/config_reader.dart';
import 'data/api/character/CharacterProvider.dart';
import 'data/api/roll/RollProvider.dart';
import 'dart:developer' as developer;

import 'domain/services/MjService.dart';


Future<void> mainCommon(String env) async {
  // Always call this if the main method is asynchronous
  WidgetsFlutterBinding.ensureInitialized();
  // Load the JSON config into memory
  await ConfigReader.initialize(env);
}

void main() {
  mainCommon("dev");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _characterService =
  SheetService(characterProvider: CharacterProvider(NetworkingConfig()), rollProvider: RollProvider(NetworkingConfig()));
  final _settingsService = SettingsService(
      settingsProvider: SettingsProvider(NetworkingConfig()),
      storageProvider: StorageProvider());
  final _mjService = MjService(
    characterProvider: CharacterProvider(NetworkingConfig()),
      mjProvider: MjProvider(NetworkingConfig()));
  @override
  Widget build(BuildContext context) {
    return Injector(
      sheetService: _characterService,
      characterSheetViewModel: CharacterSheetViewModel.playerConstructor(_characterService, _settingsService),
      settingsViewModel: SettingsViewModel(_settingsService),
      mjViewModel: MjViewModel(_mjService, _characterService),
      key: Key("Main"),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Les Sept Rois',
          onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) {
                  return MainStatefulWidget(true);
                },
              );
          },
//          home: MainStatefulWidget(Uri.base.toString())//CharacterPage(key: Key("CharacterPage"),
          //),
      ),
    );
  }
}


class MainStatefulWidget extends StatefulWidget {
  bool pj;
  MainStatefulWidget(this.pj, {Key? key}) : super(key: key);

  @override
  State<MainStatefulWidget> createState() => _MainStatefulWidgetState(this.pj);
}

class _MainStatefulWidgetState extends State<MainStatefulWidget> {
  // TODO check, pkoi il est deux fois ?
  final bool pj;
  final _characterService = SheetService(characterProvider:CharacterProvider(NetworkingConfig()), rollProvider: RollProvider(NetworkingConfig()));
  final _settingsService = SettingsService(
      settingsProvider: SettingsProvider(NetworkingConfig()),
      storageProvider: StorageProvider());
  final _mjService = MjService(
      mjProvider: MjProvider(NetworkingConfig()),
  characterProvider: CharacterProvider(NetworkingConfig()));

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  Widget characterPage = CharacterPage(Key('CharacterPage'), null);
  late Widget settingsPage;
  Widget mjPage = MjPage(key: Key('MjPage'));

  _MainStatefulWidgetState(this.pj) {
    settingsPage = SettingsPage(pj, key: Key('SettingsPage'));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Injector(
        sheetService: _characterService,
        characterSheetViewModel: CharacterSheetViewModel.playerConstructor(_characterService, _settingsService),
        mjViewModel: MjViewModel(_mjService, _characterService),
        settingsViewModel: SettingsViewModel(_settingsService),
        key: Key("main"),
        child: Scaffold(
          body: Center(
            child: getBody(_selectedIndex, pj),
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.tealAccent,
            selectedItemColor: Colors.blue,
            items: pj ? const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.character),
                label: 'Personnage',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.spell),
                label: 'Soin',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.fight),
                label: 'Combat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Paramètres',
              ),
            ] :  const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.workspace_premium),
                label: 'General',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.character),
                label: 'Personnage',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Paramètres',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ));
  }

  getBody(int selectedIndex, bool pj) {
    if(pj) {
      if (_selectedIndex == 0) {
        return characterPage;
      } else if (_selectedIndex == 3) {
        return settingsPage;
      } else {
        return Text("todo");
      }
    } else {
      if (_selectedIndex == 0) {
        return mjPage;
      } else if (_selectedIndex == 1) {
        return characterPage;
      } else if (_selectedIndex == 2) {
        return settingsPage;
      } else {
        return Text("todo");
      }
    }
  }
}