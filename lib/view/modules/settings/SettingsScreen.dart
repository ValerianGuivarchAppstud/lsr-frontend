import 'package:flutter/material.dart';

import '../../../domain/models/Settings.dart';
import '../../../main.dart';
import '../../../utils/Injector.dart';
import '../../../utils/view/Const.dart';
import '../../widgets/common/LoadingWidget.dart';
import 'SettingsState.dart';
import 'SettingsViewModel.dart';

class SettingsPage extends StatefulWidget {
  bool pj;
  bool camera;

  SettingsPage(this.pj, this.camera, {required Key key, String SettingsName = ''})
      : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState(this.pj, this.camera);
}

class _SettingsPageState extends State<SettingsPage> {
  bool pj;
  bool camera;

  _SettingsPageState(this.pj, this.camera);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width < WIDTH_SCREEN
        ? MediaQuery.of(context).size.width
        : WIDTH_SCREEN;
    SettingsViewModel settingsViewModel =
        Injector.of(context).settingsViewModel;
    Injector.of(context).settingsViewModel.getSettings();
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
                              WIDTH_SCREEN, settingsViewModel);
                        }
                      }))));
        });
  }

  _buildSettings(Settings settings, double sizeWidth,
          SettingsViewModel settingsViewModel) =>
      Column(mainAxisSize: MainAxisSize.min, children: [
        DropdownButton<String>(
          value: settings.currentPlayer ?? '',
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            settingsViewModel.selectPlayerName(newValue);
            setState(() {});
          },
          items: settings.playersName
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        DropdownButton<String>(
          value: settings.currentCharacter ?? '',
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            settingsViewModel.selectCharacterName(newValue);
            setState(() {});
          },
          items: settings.charactersName
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        ElevatedButton(
          child: pj ? const Text('Devenir MJ') : Text('Devenir joueuse'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainStatefulWidget(!pj, camera)),
            );
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
