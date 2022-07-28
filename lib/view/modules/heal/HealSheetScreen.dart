import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import '../../../utils/view/Const.dart';
import '../../widgets/common/LoadingWidget.dart';
import '../character/CharacterWidgets.dart';
import 'HealSheetState.dart';
import 'HealSheetViewModel.dart';
import 'HealWidgets.dart';

class HealSheetPage extends StatefulWidget {
  final String? characterName;
  final HealSheetViewModel healSheetViewModel;


  HealSheetPage(Key key, this.healSheetViewModel, [this.characterName = null]) : super(key: key);

  @override
  _HealSheetPageState createState() => _HealSheetPageState(healSheetViewModel, characterName);
}

class _HealSheetPageState extends State<HealSheetPage> {
  final String? characterName;
  HealSheetViewModel healSheetViewModel;

  _HealSheetPageState(this.healSheetViewModel, this.characterName);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width < WIDTH_SCREEN
        ? MediaQuery.of(context).size.width
        : WIDTH_SCREEN;
    return StreamBuilder<HealSheetState>(
        stream: healSheetViewModel.streamController.stream,
        initialData: healSheetViewModel.getState(),
        builder: (context, state) {
          if (state.data?.uiState.errorMessage != null) {
            print(state.data!.uiState.errorMessage!);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              SnackBar snackBar = SnackBar(
                content: Text(state.data!.uiState.errorMessage!),
              );
              healSheetViewModel.getState().uiState.errorMessage = null;
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          }

          if (state.data?.showLoading ?? true) {
            const oneSec = Duration(seconds: 1);
            developer.log("Timer : " + (characterName ?? "personne"));
            Timer.periodic(
                oneSec,
                (Timer t) =>
                  healSheetViewModel.getHealSheet()
                );
          }
          return Container(
                  height: height,
                  width: width,
                  color: Colors.white30,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: LayoutBuilder(builder: (context, constraints) {
                        if (state.data == null || (state.data!.showLoading)) {
                          return LoadingWidget(
                              key: Key(
                            "LoadingWidget",
                          ));
                        } else if (state.data?.character == null) {
                          return Center(
                            child: Text(state.error?.toString() ?? 'Sélectionne d\'abord ton personnage !'),
                          );
                        } else {
                          return HealWidgets.buildHeal(context, state.data!.character!, width,
                              1,
                              1,
                              healSheetViewModel, state.data!,  state.data!.pjAllies?.where((element) => element.isAlly()).toList(),
                            CharacterWidgets.buildRollList(state.data!.rollList, characterName, null, null, null));
                        }
                      })));
        });
  }
  /*Widget RollWidget2(Roll roll) {
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
        text: ' :',
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
                style: TextStyle(fontSize: 36)));
          } else if (value == 5) {
            rollText.add(TextSpan(
                text: Roll.diceValueToIcon(value),
                style: TextStyle(color: Colors.orange, fontSize: 36)));
          } else if (value == 6) {
            rollText.add(TextSpan(
                text: Roll.diceValueToIcon(value),
                style: TextStyle(color: Colors.red, fontSize: 36)));
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
  }*/
}
