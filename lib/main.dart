import 'package:flutter/material.dart';
import 'package:lsr/data/api/mj/MjProvider.dart';
import 'package:lsr/data/api/settings/SettingsProvider.dart';
import 'package:lsr/data/storage/StorageProvider.dart';
import 'package:lsr/domain/services/SettingsService.dart';
import 'package:lsr/domain/services/SheetService.dart';
import 'package:lsr/utils/Injector.dart';
import 'package:lsr/utils/api/NetworkingConfig.dart';
import 'package:lsr/utils/view/Const.dart';
import 'package:lsr/view/modules/character/CharacterSheetScreen.dart';
import 'package:lsr/view/modules/character/CharacterSheetViewModel.dart';
import 'package:lsr/view/modules/heal/pages/call.dart';
import 'package:lsr/view/modules/mj/MjScreen.dart';
import 'package:lsr/view/modules/mj/MjViewModel.dart';
import 'package:lsr/view/modules/settings/SettingsScreen.dart';
import 'package:lsr/view/modules/settings/SettingsViewModel.dart';
import 'package:lsr/view/widgets/fonts/FontIconCharacter.dart';

import 'config/config_reader.dart';
import 'data/api/character/CharacterProvider.dart';
import 'data/api/roll/RollProvider.dart';
import 'domain/services/MjService.dart';

const bool INITIAL_STATE_PJ = false;
const bool INITIAL_STATE_CAMERA = true;

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
  final _characterService = SheetService(
      characterProvider: CharacterProvider(NetworkingConfig()),
      rollProvider: RollProvider(NetworkingConfig()));
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
      characterSheetViewModel: CharacterSheetViewModel.playerConstructor(
          _characterService, _settingsService),
      settingsViewModel: SettingsViewModel(_settingsService),
      mjViewModel: MjViewModel(_mjService, _characterService),
      key: Key("Main"),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Les Sept Rois',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return MainStatefulWidget(INITIAL_STATE_PJ, INITIAL_STATE_CAMERA);
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
  bool camera;

  MainStatefulWidget(this.pj, this.camera, {Key? key}) : super(key: key);

  @override
  State<MainStatefulWidget> createState() => _MainStatefulWidgetState(this.pj, this.camera);
}

class _MainStatefulWidgetState extends State<MainStatefulWidget> {
  // TODO check, pkoi il est deux fois ?

  final bool pj;
  bool camera;
  final _characterService = SheetService(
      characterProvider: CharacterProvider(NetworkingConfig()),
      rollProvider: RollProvider(NetworkingConfig()));
  final _settingsService = SettingsService(
      settingsProvider: SettingsProvider(NetworkingConfig()),
      storageProvider: StorageProvider());
  final _mjService = MjService(
      mjProvider: MjProvider(NetworkingConfig()),
      characterProvider: CharacterProvider(NetworkingConfig()));

  int _selectedIndex = 0;
  Widget characterPage = CharacterPage(Key('CharacterPage'), null);
  Widget healPage = CallPage(
    key: Key("CallPage"),
  );
  late Widget settingsPage;
  Widget mjPage = MjPage(key: Key('MjPage'));

  _MainStatefulWidgetState(this.pj, this.camera) {
    settingsPage = SettingsPage(pj, camera, key: Key('SettingsPage'));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    return Injector(
        sheetService: _characterService,
        characterSheetViewModel: CharacterSheetViewModel.playerConstructor(
            _characterService, _settingsService),
        mjViewModel: MjViewModel(_mjService, _characterService),
        settingsViewModel: SettingsViewModel(_settingsService),
        key: Key("main"),
        child: Scaffold(
    body : Stack(
            alignment: Alignment.topRight,
            children: [Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        SizedBox(
        width: camera ? (widthScreen - WIDTH_CAMERA) : widthScreen,
            child: Scaffold(
            body: Center(
              child: getBody(_selectedIndex, pj),
            ),
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: Colors.tealAccent,
              selectedItemColor: Colors.blue,
              items: pj
                  ? const <BottomNavigationBarItem>[
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
                    ]
                  : const <BottomNavigationBarItem>[
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
          )),
        if(camera) SizedBox(
            width: WIDTH_CAMERA,//* 0.9 / 3,
            child: Text("lol")
        )]),
            IconButton(
            icon: Icon(Icons.camera_alt),
              onPressed: () => {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainStatefulWidget(pj, !camera)),
              )
              },
            )])
        ));
  }

  getBody(int selectedIndex, bool pj) {
    if (pj) {
      if (_selectedIndex == 0) {
        return characterPage;
      } else if (_selectedIndex == 1) {
        return healPage;
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
