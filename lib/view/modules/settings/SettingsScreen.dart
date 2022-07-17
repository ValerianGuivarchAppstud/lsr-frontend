import 'package:flutter/material.dart';
import 'package:lsr/view/MainViewModel.dart';
import 'package:lsr/view/modules/settings/SettingsWidgets.dart';

import '../../../domain/models/Settings.dart';
import '../../../utils/view/Const.dart';
import '../../widgets/common/LoadingWidget.dart';
import 'SettingsState.dart';
import 'SettingsViewModel.dart';

class SettingsPage extends StatefulWidget {
  final SettingsViewModel settingsViewModel;
  final MainViewModel mainViewModel;

  SettingsPage(
      this.settingsViewModel,
      this.mainViewModel,
      {required Key key, String SettingsName = ''})
      : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState(this.settingsViewModel, this.mainViewModel);
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsViewModel settingsViewModel;
  final MainViewModel mainViewModel;

  _SettingsPageState(this.settingsViewModel, this.mainViewModel);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width; /* < WIDTH_SCREEN
        ? MediaQuery.of(context).size.width
        : WIDTH_SCREEN;*/
    settingsViewModel.getSettings();
    return StreamBuilder<SettingsState>(
        stream: settingsViewModel.streamController.stream,
        initialData: settingsViewModel.getState(),
        builder: (context, state) {
          return Scaffold(
              body: Container(
                  height: height,
                  width: width,
                  color: Colors.white,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: LayoutBuilder(builder: (context, constraints) {
                        if (state.data == null || (state.data!.showLoading)) {
                          return LoadingWidget(
                              key: Key(
                            "LoadingWidget",
                          ));
                        } else if (state.data?.settings == null ||
                            state.data?.settings?.charactersName == null ||
                            state.data?.settings?.playersName == null) {
                          return Center(
                            child: Text("Paramètres indisponibles..."),
                          );
                        } else {
                          return _buildSettings(state.data!.settings!,
                              width, settingsViewModel, state.data!.uiState.pj);
                        }
                      }))));
        });
  }

  _buildSettings(Settings settings, double sizeWidth,
          SettingsViewModel settingsViewModel, bool pj) =>
      Column(mainAxisSize: MainAxisSize.min, children: [
        SettingsWidgets.buildCharacterSelection(settings, settingsViewModel, null, setState),
        ElevatedButton(
          child: pj ? const Text('Devenir MJ') : Text('Devenir joueuse'),
          onPressed: () {
            mainViewModel.switchRole();
          },
        )
      ]);
}

SettingsButton(
    String title,
    String value,
    double width,
    double fontSize,
    double height,
    MaterialColor color,
    void Function() onPressed,
    void Function() onLongPress) {
  return Padding(
      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
      child: SizedBox(
          height: height,
          width: width, // <-- match_parent
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: color,
                //     primary: Colors.white,
                minimumSize: Size.zero, // Set this
                padding: EdgeInsets.zero, // and this
              ),
              onPressed: onPressed,
              onLongPress: onLongPress,
              child: Stack(alignment: Alignment.bottomCenter, children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      //   style: TextStyle(fontSize: 10, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ]))));
}
