
import 'package:flutter/material.dart';
import 'package:lsr/domain/models/RollType.dart';

import '../../../domain/models/Roll.dart';
import '../../../domain/models/Settings.dart';
import '../../../utils/Injector.dart';
import '../../widgets/common/LoadingWidget.dart';
import 'SettingsState.dart';
import 'SettingsViewModel.dart';

class SettingsPage extends StatefulWidget {

  SettingsPage({required Key key, String SettingsName = ''}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  _SettingsPageState();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width < 600
        ? MediaQuery.of(context).size.width
        : 600.0;
    SettingsViewModel settingsViewModel =
        Injector.of(context).settingsViewModel;
    Injector.of(context).settingsViewModel.getSettings();
    return StreamBuilder<SettingsState>(
        stream: settingsViewModel.streamController.stream,
        initialData: settingsViewModel.getState(),
        builder: (context, state) {
          /*if (state.data?.showLoading ?? true) {
            const oneSec = Duration(seconds: 1);
            Timer.periodic(
                oneSec,
                (Timer t) => Injector.of(context)
                    .SettingsViewModel
                    .getSettings(this.SettingsName));
          }*/
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
                        } else if (state.data?.settings == null || state.data?.settings?.charactersName == null || state.data?.settings?.playersName == null) {
                          return Center(
                            child: Text("Paramètres indisponibles..."),
                          );
                        } else {
                          return _buildSettings(state.data!.settings!, 600,
                              settingsViewModel);
                        }
                      }))));
        });
  }

  _buildSettings(
      Settings settings,
          double sizeWidth,
          SettingsViewModel settingsViewModel) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
              setState(() {

              });
            },
            items:settings.playersName
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
              setState(() {

              });
            },
            items:settings.charactersName
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
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

  Widget RollWidget2(Roll roll) {
    List<TextSpan> rollText = [];
    rollText.add(TextSpan(
        // (secret)
        text: roll.secretText()));
    if (roll.malediction > 0 && roll.benediction == 0) {
      rollText.add(TextSpan(
          // Avec 2 bénédictions et 1 malédiction,
          text: 'Avec ${roll.malediction} malédiction' +
              (roll.malediction > 0 ? 's' : '') +
              ', '));
    } else if (roll.malediction == 0 && roll.benediction > 0) {
      rollText.add(TextSpan(
          // Avec 2 bénédictions et 1 malédiction,
          text: 'Avec ${roll.benediction} benediction' +
              (roll.benediction > 0 ? 's' : '') +
              ', '));
    }
    if (roll.malediction > 0 && roll.benediction > 0) {
      rollText.add(TextSpan(
          // Avec 2 bénédictions et 1 malédiction,
          text: 'Avec ${roll.malediction} malédiction' +
              (roll.malediction > 0 ? 's' : '') +
              ' et ${roll.benediction} benediction' +
              (roll.benediction > 0 ? 's' : '') +
              ', '));
    }
    rollText.add(TextSpan(
        // Jonathan
        text: roll.rollerName,
        style: TextStyle(fontWeight: FontWeight.bold)));
    if (roll.focus) {
      rollText.add(TextSpan(
        // se concentre et
        text: ' se ',
      ));
      rollText.add(TextSpan(
          // se concentre et
          text: 'concentre',
          style: TextStyle(fontStyle: FontStyle.italic)));
      rollText.add(TextSpan(
        text: ' et',
      ));
    }

    rollText.add(TextSpan(
        // fait un
        text: ' fait un '));
    rollText.add(TextSpan(
        // jet de Chair
        text: roll.rollTypeText(),
        style: TextStyle(fontStyle: FontStyle.italic)));

    if (roll.focus) {
      rollText.add(TextSpan(
        // se concentre et
        text: ' en y mettant toute sa ',
      ));
      rollText.add(TextSpan(
          // se concentre et
          text: 'puissance',
          style: TextStyle(fontStyle: FontStyle.italic)));
    }
    if (roll.rollType == RollType.ARCANE_FIXE) {
      rollText.add(TextSpan(
        text: '.',
      ));
    } else {
      rollText.add(TextSpan(
        text: ' :\n',
      ));
    }
    switch (roll.rollType) {
      case RollType.CHAIR:
      case RollType.ESPRIT:
      case RollType.ESSENCE:
      case RollType.MAGIE_LEGERE:
      case RollType.MAGIE_FORTE:
      case RollType.SOIN:
      case RollType.ARCANE_ESPRIT:
      case RollType.ARCANE_ESSENCE:
        for (var value in roll.result) {
          if (value < 5) {
            rollText.add(TextSpan(
                text: Roll.diceValueToIcon(value),
                style: TextStyle(fontSize: 24)));
          } else if (value == 5) {
            rollText.add(TextSpan(
                text: Roll.diceValueToIcon(value),
                style: TextStyle(color: Colors.orange, fontSize: 24)));
          } else if (value == 6) {
            rollText.add(TextSpan(
                text: Roll.diceValueToIcon(value),
                style: TextStyle(color: Colors.red, fontSize: 24)));
          }
        }
        rollText.add(TextSpan(
          text: '\n et obtient ${roll.success} succès',
        ));
        break;
      case RollType.EMPIRIQUE:
        for (var value in roll.result) {
          rollText.add(TextSpan(text: '[$value]'));
        }
        break;
      case RollType.ARCANE_FIXE:
        break;
      case RollType.SAUVEGARDE_VS_MORT:
        for (var value in roll.result) {
          if (value < 10) {
            rollText.add(TextSpan(
                text: '[$value]', style: TextStyle(color: Colors.red)));
          } else {
            rollText.add(TextSpan(
                text: '[$value]', style: TextStyle(color: Colors.green)));
          }
        }
        break;
      case RollType.RELANCE:
        break;
    }
    if (roll.proficiency) {
      rollText.add(TextSpan(
        text: ', grâce à son heritage latent',
      ));
    }
    rollText.add(TextSpan(
      text: '.',
    ));
    return Text.rich(TextSpan(
        text: roll.dateText() + ' - ', // 10:19:22 -
        children: rollText));
  }
