
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lsr/domain/models/MjSheet.dart';
import 'package:lsr/domain/models/RollType.dart';

import '../../../domain/models/Character.dart';
import '../../../domain/models/Roll.dart';
import '../../../utils/Injector.dart';
import '../../widgets/common/LoadingWidget.dart';
import 'MjState.dart';
import 'MjViewModel.dart';

class MjPage extends StatefulWidget {

  MjPage({required Key key, String MjName = ''}) : super(key: key);

  @override
  _MjPageState createState() => _MjPageState();
}

class _MjPageState extends State<MjPage> {

  _MjPageState();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width < 600
        ? MediaQuery.of(context).size.width
        : 600.0;
    MjViewModel mjViewModel =
        Injector.of(context).mjViewModel;
    Injector.of(context).mjViewModel.getMj();
    return StreamBuilder<MjState>(
        stream: mjViewModel.streamController.stream,
        initialData: mjViewModel.getState(),
        builder: (context, state) {
          if (state.data?.showLoading ?? true) {
            const oneSec = Duration(seconds: 1);
            Timer.periodic(
                oneSec,
                (Timer t) => Injector.of(context)
                    .mjViewModel
                    .getMj());
          }
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
                        } else if (state.data?.mjSheet == null) {
                          return Center(
                            child: Text("MJ indisponible..."),
                          );
                        } else {
                          return _buildMj(state.data!.mjSheet!, 600,
                              mjViewModel);
                        }
                      }))));
        });
  }

  _buildMj(
      MjSheet mjSheet,
          double sizeWidth,
          MjViewModel mjViewModel) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
          children: [
            _buildCharacter(mjSheet.pj[0], 600, mjViewModel)
          ],
          )
        ]);
  }


void sendRoll(
    MjViewModel mjViewModel, RollType rollType,
    [String empirique = '']) {
  mjViewModel.sendRoll(rollType, empirique);
}

_buildCharacter(
    Character character,
    double sizeWidth,
    MjViewModel mjSheetViewModel) =>
    Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MjButton(
                  "Chair",
                  character.chair.toString(),
                  sizeWidth / 4.3,
                  26,
                  50,
                  Colors.blue,
                      () => sendRoll(mjSheetViewModel, RollType.CHAIR),
                      () => showEditStatAlertDialog(
                      mjSheetViewModel, character, "Chair")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: sizeWidth / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      this.changeCharacterValue(
                          mjSheetViewModel, character, 'PV', -1);
                    },
                  ),
                  MjSheetButton(
                      "PV",
                      character.pv.toString() +
                          ' / ' +
                          character.pvMax.toString(),
                      sizeWidth / 5,
                      26,
                      50,
                      Colors.blue,
                          () => {},
                          () => showEditStatAlertDialog(
                          mjSheetViewModel, character, "PV_MAX")),
                  IconButton(
                    iconSize: sizeWidth / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      this.changeCharacterValue(
                          mjSheetViewModel, character, 'PV', 1);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: sizeWidth / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      this.changeUiValue(mjSheetViewModel,
                          mjSheetState.uiState, 'Bonus', -1);
                    },
                  ),
                  MjSheetButton(
                      "Bonus",
                      mjSheetState.uiState.benediction.toString(),
                      sizeWidth / 5,
                      26,
                      50,
                      Colors.blue,
                          () => {},
                          () => {}),
                  IconButton(
                    iconSize: sizeWidth / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      this.changeUiValue(mjSheetViewModel,
                          mjSheetState.uiState, 'Bonus', 1);
                    },
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MjSheetButton(
                  "Esprit",
                  character.esprit.toString(),
                  sizeWidth / 4.3,
                  26,
                  50,
                  Colors.blue,
                      () => sendRoll(mjSheetViewModel, RollType.ESPRIT),
                      () => showEditStatAlertDialog(
                      mjSheetViewModel, character, "Esprit")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: sizeWidth / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      this.changeCharacterValue(
                          mjSheetViewModel, character, 'PF', -1);
                    },
                  ),
                  MjSheetButton(
                      "PF",
                      character.pf.toString() +
                          ' / ' +
                          character.pfMax.toString(),
                      sizeWidth / 5,
                      26,
                      50,
                      mjSheetState.uiState.focus
                          ? Colors.blueGrey
                          : Colors.blue, () {
                    this.changeUiSelect(mjSheetViewModel,
                        mjSheetState.uiState, 'PF');
                  },
                          () => showEditStatAlertDialog(
                          mjSheetViewModel, character, "PF_MAX")),
                  IconButton(
                    iconSize: sizeWidth / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      this.changeCharacterValue(
                          mjSheetViewModel, character, 'PF', 1);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: sizeWidth / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      this.changeUiValue(mjSheetViewModel,
                          mjSheetState.uiState, 'Malus', -1);
                    },
                  ),
                  MjSheetButton(
                      "Malus",
                      mjSheetState.uiState.malediction.toString()+ (character.getInjury() >0 ? (' ('+
                          character.getInjury().toString() + ')') : ('')),
                      sizeWidth / 5,
                      26,
                      50,
                      Colors.blue,
                          () => {},
                          () => {}),
                  IconButton(
                    iconSize: sizeWidth / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      this.changeUiValue(mjSheetViewModel,
                          mjSheetState.uiState, 'Malus', 1);
                    },
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MjSheetButton(
                  "Essence",
                  character.essence.toString(),
                  sizeWidth / 4.3,
                  26,
                  50,
                  Colors.blue,
                      () => sendRoll(mjSheetViewModel, RollType.ESSENCE),
                      () => showEditStatAlertDialog(
                      mjSheetViewModel, character, "Essence")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: sizeWidth / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      this.changeCharacterValue(
                          mjSheetViewModel, character, 'PP', -1);
                    },
                  ),
                  MjSheetButton(
                      "PP",
                      character.pp.toString() +
                          ' / ' +
                          character.ppMax.toString(),
                      sizeWidth / 5,
                      26,
                      50,
                      mjSheetState.uiState.power
                          ? Colors.blueGrey
                          : Colors.blue, () {
                    this.changeUiSelect(mjSheetViewModel,
                        mjSheetState.uiState, 'PP');
                  },
                          () => showEditStatAlertDialog(
                          mjSheetViewModel, character, "PP_MAX")),
                  IconButton(
                    iconSize: sizeWidth / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      this.changeCharacterValue(
                          mjSheetViewModel, character, 'PP', 1);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: sizeWidth / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      this.changeCharacterValue(
                          mjSheetViewModel, character, 'Dettes', -1);
                    },
                  ),
                  MjSheetButton("Dettes", character.dettes.toString(),
                      sizeWidth / 5, 26, 50, Colors.blue, () => {}, () => {}),
                  IconButton(
                    iconSize: sizeWidth / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      this.changeCharacterValue(
                          mjSheetViewModel, character, 'Dettes', 1);
                    },
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MjSheetButton(
                  "Arcane : " +
                      character.arcanes.toString() +
                      ' / ' +
                      character.arcanesMax.toString(),
                  '',
                  sizeWidth / 5,
                  14,
                  34,
                  Colors.blue,
                      () => showArcaneAlertDialog(mjSheetViewModel),
                      () => showEditStatAlertDialog(
                      mjSheetViewModel, character, "Arcane")),
              MjSheetButton(
                  "Magie",
                  '',
                  sizeWidth / 5,
                  14,
                  34,
                  Colors.blue,
                      () =>
                      sendRoll(mjSheetViewModel, RollType.MAGIE_FORTE),
                      () => showEditStatAlertDialog(
                      mjSheetViewModel, character, "MagieForte")),
              MjSheetButton(
                  "Cantrip",
                  '',
                  sizeWidth / 5,
                  14,
                  34,
                  Colors.blue,
                      () => sendRoll(
                      mjSheetViewModel, RollType.MAGIE_LEGERE),
                      () => showEditStatAlertDialog(
                      mjSheetViewModel, character, "MagieLegere")),
              MjSheetButton(
                  "Empirique",
                  '',
                  sizeWidth / 5,
                  12,
                  34,
                  Colors.blue,
                      () => sendRoll(
                      mjSheetViewModel, RollType.EMPIRIQUE, "1d6"),
                      () => showEmpiriqueRollAlertDialog(
                      mjSheetViewModel, character)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MjSheetButton(
                  "Proficiency",
                  '',
                  sizeWidth / 5,
                  14,
                  34,
                  mjSheetState.uiState.proficiency
                      ? Colors.blueGrey
                      : Colors.blue, () {
                this.changeUiSelect(mjSheetViewModel,
                    mjSheetState.uiState, 'Proficiency');
              }, () => {}),
              MjSheetButton(
                  "Aide",
                  '',
                  sizeWidth / 5,
                  14,
                  34,
                  mjSheetState.uiState.help
                      ? Colors.blueGrey
                      : Colors.blue, () {
                this.changeUiSelect(mjSheetViewModel,
                    mjSheetState.uiState, 'Help');
              }, () => {}),
              MjSheetButton(
                  "Secret",
                  '',
                  sizeWidth / 5,
                  14,
                  34,
                  mjSheetState.uiState.secret
                      ? Colors.blueGrey
                      : Colors.blue, () {
                this.changeUiSelect(mjSheetViewModel,
                    mjSheetState.uiState, 'Secret');
              }, () => {}),
              MjSheetButton(
                  "Relance : " + character.relance.toString(),
                  '',
                  sizeWidth / 5,
                  12,
                  34,
                  Colors.blue,
                      () => sendRoll(
                      mjSheetViewModel, RollType.RELANCE),
                      () => showEditStatAlertDialog(
                      mjSheetViewModel, character, "Relance")),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [],
          ),
          LayoutBuilder(builder: (context, constraints) {
            List<Widget> rolls = [];
            for (Roll roll in (mjSheetState.rollList ?? [])) {
              rolls.addAll(RollWidget(roll));
            }
            return Column(
              children: rolls,
            );
          }),
        ]);


MjButton(
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
