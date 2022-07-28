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
import 'package:lsr/view/modules/call/CallViewModel.dart';
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
  CallViewModel callViewModel = CallViewModel(_settingsService);

  mainViewModel.addSubViewModel(characterSheetViewModel);
  mainViewModel.addSubViewModel(settingsViewModel);
  mainViewModel.addSubViewModel(healSheetViewModel);
  mainViewModel.addSubViewModel(mjViewModel);

  Widget characterPage = CharacterPage(characterSheetViewModel, Key('CharacterPage'), null);
  Widget healPage = HealSheetPage(Key("HealPage"), healSheetViewModel, null);
  Widget settingsPage = SettingsPage(settingsViewModel, mainViewModel, key: Key('SettingsPage'));
  MjPage mjPage = MjPage(mjViewModel, key: Key('MjPage'));
  CallPage callPage = CallPage(callViewModel, key: Key('CallPage'));

  runApp(MyApp(mainViewModel, characterPage, healPage, settingsPage, mjPage, callPage, key: Key("MyApp")));
}


class MyApp extends StatefulWidget {

  final MainViewModel mainViewModel;
  final Widget characterPage;
  final Widget healPage;
  final Widget settingsPage;
  final MjPage mjPage;
  final CallPage callPage;


  MyApp(this.mainViewModel, this.characterPage, this.healPage, this.settingsPage, this.mjPage, this.callPage, {required Key key})
      : super(key: key);


  @override
  _MainState createState() => _MainState(this.mainViewModel, this.characterPage, this.healPage, this.settingsPage, this.mjPage, this.callPage);

}

class _MainState extends State<MyApp> {

  final MainViewModel mainViewModel;
  final Widget characterPage;
  final Widget healPage;
  final Widget settingsPage;
  final MjPage mjPage;
  final CallPage callPage;

  _MainState(this.mainViewModel, this.characterPage, this.healPage, this.settingsPage, this.mjPage, this.callPage);

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
      } else if (selectedIndex == 2) {
        return settingsPage;
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
                    var heightScreen = MediaQuery
                        .of(context)
                        .size
                        .height;
                    if (state.data == null) {
                      return LoadingWidget(
                          key: Key(
                            "LoadingApp",
                          ));
                    } else {
                      return buildBodyApp(
                          state.data!, widthScreen, heightScreen, getBody, mainViewModel, callPage);
                    }
                  });
            },
          );
        },
      );
  }


  static buildBodyApp(MainState data, double widthScreen, double heightScreen,
      Function(int selectedIndex, bool pj) getBody, MainViewModel mainViewModel,
      CallPage callPage) {

    // callPage.callViewModel.getState().showLoading

    return Scaffold(
        body: Stack(
            alignment: Alignment.topRight,
            children: [Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: data.uiState.pj ? (data.uiState.camera
                          ? widthScreen / 2
                          : widthScreen) : (data.uiState.camera
                          ? 2 * widthScreen / 3
                          : widthScreen),
                      child: Scaffold(
                        body: Center(
                          child: getBody(data.uiState.selectedIndex, data.uiState.pj),
                        ),
                        bottomNavigationBar: data.uiState.pj
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
                              icon: Icon(Icons.settings),
                              label: 'Paramètres',
                            ),
                          ],
                          currentIndex: data.uiState.selectedIndex,
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
                          currentIndex: data.uiState.selectedIndex,
                          onTap: (index) {
                            mainViewModel.changeTab(index);
                          },
                        ),
                      )),
                  if( data.uiState.camera) SizedBox(
                      width: data.uiState.pj ? widthScreen / 2 : widthScreen / 3,
                      //* 0.9 / 3,
                      child: callPage
                  )
                ]),
              IconButton(
                icon: Icon(Icons.camera_alt),
                color: data.uiState.camera ? Colors.white : Colors.black,
                onPressed: () =>
                {
                  mainViewModel.switchCamera()
                },
              )
            ])
    );
  }
}
