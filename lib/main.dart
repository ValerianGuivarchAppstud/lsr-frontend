import 'package:flutter/material.dart';
import 'package:lsr/data/api/mj/MjProvider.dart';
import 'package:lsr/data/api/settings/SettingsProvider.dart';
import 'package:lsr/data/storage/StorageProvider.dart';
import 'package:lsr/domain/services/SettingsService.dart';
import 'package:lsr/domain/services/SheetService.dart';
import 'package:lsr/utils/api/NetworkingConfig.dart';
import 'package:lsr/view/MainState.dart';
import 'package:lsr/view/MainViewModel.dart';
import 'package:lsr/view/modules/call/CallPage.dart';
import 'package:lsr/view/modules/character/CharacterSheetScreen.dart';
import 'package:lsr/view/modules/character/CharacterSheetViewModel.dart';
import 'package:lsr/view/modules/character/CharacterWidgets.dart';
import 'package:lsr/view/modules/heal/HealSheetScreen.dart';
import 'package:lsr/view/modules/heal/HealSheetViewModel.dart';
import 'package:lsr/view/modules/mj/MjScreen.dart';
import 'package:lsr/view/modules/mj/MjViewModel.dart';
import 'package:lsr/view/modules/settings/SettingsScreen.dart';
import 'package:lsr/view/modules/settings/SettingsViewModel.dart';
import 'package:lsr/view/widgets/common/LoadingWidget.dart';
import 'package:lsr/view/widgets/fonts/FontIconCharacter.dart';

import 'config/config_reader.dart';
import 'data/api/character/CharacterProvider.dart';
import 'data/api/heal/HealProvider.dart';
import 'data/api/roll/RollProvider.dart';
import 'domain/services/MjService.dart';


Future<void> mainCommon(String env) async {
  // Always call this if the main method is asynchronous
  WidgetsFlutterBinding.ensureInitialized();
  // Load the JSON config into memory
  await ConfigReader.initialize(env);
}

void main() {
  mainCommon("dev");
  final _characterService = SheetService(
      characterProvider: CharacterProvider(NetworkingConfig()),
      rollProvider: RollProvider(NetworkingConfig()),
      healProvider: HealProvider(NetworkingConfig()));
  final _settingsService = SettingsService(
      settingsProvider: SettingsProvider(NetworkingConfig()),
      storageProvider: StorageProvider());
  final _mjService = MjService(
      characterProvider: CharacterProvider(NetworkingConfig()),
      mjProvider: MjProvider(NetworkingConfig()));

  MainViewModel mainViewModel = MainViewModel();
  CharacterSheetViewModel characterSheetViewModel= CharacterSheetViewModel.playerConstructor(_characterService, _settingsService);
  SettingsViewModel settingsViewModel = SettingsViewModel(_settingsService);
  HealSheetViewModel healSheetViewModel = HealSheetViewModel(_characterService, _settingsService);
  MjViewModel mjViewModel = MjViewModel(_mjService, _characterService, _settingsService);

  Widget characterPage = CharacterPage(characterSheetViewModel, Key('CharacterPage'), null);
  Widget healPage = HealSheetPage(Key("HealPage"), healSheetViewModel, null);
  Widget settingsPage = SettingsPage(settingsViewModel, mainViewModel, key: Key('SettingsPage'));
  MjPage mjPage = MjPage(mjViewModel, key: Key('MjPage'));

  runApp(MyApp(mainViewModel, characterPage, healPage, settingsPage, mjPage, key: Key("MyApp")));
}


class MyApp extends StatefulWidget {

  final MainViewModel mainViewModel;
  final Widget characterPage;
  final Widget healPage;
  final Widget settingsPage;
  final MjPage mjPage;

  static final bool INITIAL_STATE_PJ = true;
  static final bool INITIAL_STATE_CAMERA = false;

  MyApp(this.mainViewModel, this.characterPage, this.healPage, this.settingsPage, this.mjPage, {required Key key})
      : super(key: key);


  @override
  _MainState createState() => _MainState(this.mainViewModel, this.characterPage, this.healPage, this.settingsPage, this.mjPage);

}

class _MainState extends State<MyApp> {

  final MainViewModel mainViewModel;
  final Widget characterPage;
  final Widget healPage;
  final Widget settingsPage;
  final MjPage mjPage;

  _MainState(this.mainViewModel, this.characterPage, this.healPage, this.settingsPage, this.mjPage);

  @override
  void initState() {
    super.initState();
  }

  getBody(int selectedIndex, bool pj) {
    if (pj) {
      if (selectedIndex == 0) {
        return characterPage;
      } else if (selectedIndex == 1) {
        return healPage;
      } else if (selectedIndex == 3) {
        return settingsPage;
      } else {
        return Text("todo");
      }
    } else {
      if (selectedIndex == 0) {
        return mjPage;
      } else if (selectedIndex == 1) {
        return characterPage;
      } else if (selectedIndex == 2) {
        return settingsPage;
      } else {
        return Text("todo");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    CharacterWidgets.getColorList();
    mainViewModel.getMain();
    return
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Les Sept Rois',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return StreamBuilder<MainState>(
                  stream: mainViewModel.streamController.stream,
                  initialData: mainViewModel.getState(),
                  builder: (context, state) {
                    var widthScreen = MediaQuery
                        .of(context)
                        .size
                        .width;
                    if (state.data == null) {
                      return LoadingWidget(
                          key: Key(
                            "LoadingApp",
                          ));
                    } else {
                      return buildBodyApp(
                          state.data!, widthScreen, getBody, mainViewModel);
                    }
                  });
            },
          );
        },
      );
  }


  static buildBodyApp(MainState data, double widthScreen,
      Function(int selectedIndex, bool pj) getBody, MainViewModel mainViewModel) {

    return Scaffold(
        body: Stack(
            alignment: Alignment.topRight,
            children: [Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: data.pj ? (data.camera
                          ? widthScreen / 2
                          : widthScreen) : (data.camera
                          ? 2 * widthScreen / 3
                          : widthScreen),
                      child: Scaffold(
                        body: Center(
                          child: getBody(data.selectedIndex, data.pj),
                        ),
                        bottomNavigationBar: data.pj
                            ? BottomNavigationBar(
                          unselectedItemColor: Colors.tealAccent,
                          selectedItemColor: Colors.blue,
                          items: const <BottomNavigationBarItem>[
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
                          ],
                          currentIndex: data.selectedIndex,
                          onTap: (index) {
                            mainViewModel.changeTab(index);
                          },) : BottomNavigationBar(
                          unselectedItemColor: Colors.tealAccent,
                          selectedItemColor: Colors.blue,
                          items: const <BottomNavigationBarItem>[
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
                          currentIndex: data.selectedIndex,
                          onTap: (index) {
                            mainViewModel.changeTab(index);
                          },
                        ),
                      )),
                  if( data.camera) SizedBox(
                      width: data.pj ? widthScreen / 2 : widthScreen / 3,
                      //* 0.9 / 3,
                      child: CallPage(key: Key("call"))
                  )
                ]),
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () =>
                {
                  mainViewModel.switchCamera()
                },
              )
            ])
    );
  }
}

/*class MainStatefulWidget extends StatefulWidget {
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
      rollProvider: RollProvider(NetworkingConfig()),
      healProvider: HealProvider(NetworkingConfig()),
  );
  final _settingsService = SettingsService(
      settingsProvider: SettingsProvider(NetworkingConfig()),
      storageProvider: StorageProvider());
  final _mjService = MjService(
      mjProvider: MjProvider(NetworkingConfig()),
      characterProvider: CharacterProvider(NetworkingConfig()));

  int _selectedIndex = 0;
  Widget characterPage = CharacterPage(Key('CharacterPage'), null);
  Widget healPage = HealSheetPage(Key("HealPage"), null);
  late Widget settingsPage;
  late MjPage mjPage;

  _MainStatefulWidgetState(this.pj, this.camera) {
    settingsPage = SettingsPage(pj, camera, key: Key('SettingsPage'));
    mjPage = MjPage(camera, key: Key('MjPage'));
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
        mjViewModel: MjViewModel(_mjService, _characterService, _settingsService),
        healSheetViewModel: HealSheetViewModel(_characterService, _settingsService),
        settingsViewModel: SettingsViewModel(_settingsService),
        key: Key("main"),
        child:
  }
*/
