import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lsr/domain/models/Bloodline.dart';
import 'package:lsr/domain/models/RollType.dart';

import '../../../domain/models/Character.dart';
import '../../../domain/models/Roll.dart';
import '../../../utils/Injector.dart';
import '../../widgets/common/LoadingWidget.dart';
import 'CharacterSheetState.dart';
import 'CharacterSheetViewModel.dart';

class CharacterPage extends StatefulWidget {

  CharacterPage({required Key key}) : super(key: key);

  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  late TextEditingController noteFieldController;


  _CharacterPageState();

  @override
  void initState() {
    super.initState();
    noteFieldController = TextEditingController();
  }

  @override
  void dispose() {
    noteFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width < 600
        ? MediaQuery.of(context).size.width
        : 600.0;
    CharacterSheetViewModel characterSheetViewModel =
        Injector.of(context).characterSheetViewModel;
    return StreamBuilder<CharacterSheetState>(
        stream: characterSheetViewModel.streamController.stream,
        initialData: characterSheetViewModel.getState(),
        builder: (context, state) {
          if (state.data?.showLoading ?? true) {
            const oneSec = Duration(seconds: 1);
            Timer.periodic(
                oneSec,
                (Timer t) => Injector.of(context)
                    .characterSheetViewModel
                    .getCharacterSheet());
          }
          return Scaffold(
              body: Container(
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
                            child: Text("Aucun personnage..."),
                          );
                        } else {
                          return _buildCharacter(state.data!.character!, 600,
                              characterSheetViewModel, state.data!);
                        }
                      }))));
        });
  }

  static _buildCharacter(
          Character character,
          double sizeWidth,
          CharacterSheetViewModel characterSheetViewModel,
          CharacterSheetState characterSheetState) =>
      Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Image.network(
                      character.background ?? '',
                      //"assets/images/background/${describeEnum(character.bloodline != Bloodline.AUCUN ? character.bloodline : character.classe).toLowerCase()}.jpg",
                      fit: BoxFit.fill,
                      height: 120,
                      width: sizeWidth,
                    )),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 62,
                          backgroundColor: Colors.white,
                        ),
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          foregroundImage: NetworkImage(
                            character.picture ?? ''),
                              //"assets/images/portraits/${character.name}.png"),
                        )
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(180, 10, 0, 0),
                    child: Card(
                      color: Color(0x88FFFFFF),
                        child: Padding(
                            padding: EdgeInsets.all(8),
                            child:
                                Stack(alignment: Alignment.topLeft, children: [
                              Column(
                                children: [
                                  Text(
                                    character.name +
                                        ', ' +
                                        character.description(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    'Lux : ' + character.lux,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    'Umbra : ' + character.umbra,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    'Secunda : ' + character.secunda,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              )
                            ]))))
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: TextField(
                controller: noteFieldController,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: InputDecoration(
                    hintText: "Entrez vos notes ici",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.redAccent))),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CharacterSheetButton(
                    "Chair",
                    character.chair.toString(),
                    sizeWidth / 4.3,
                    26,
                    50,
                    Colors.blue,
                    () => sendRoll(characterSheetViewModel, RollType.CHAIR),
                    () => showEditStatAlertDialog(
                        characterSheetViewModel, character, "Chair")),
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
                            characterSheetViewModel, character, 'PV', -1);
                      },
                    ),
                    CharacterSheetButton(
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
                            characterSheetViewModel, character, "PV_MAX")),
                    IconButton(
                      iconSize: sizeWidth / 18,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      color: Colors.blue,
                      icon: Icon(Icons.add_circle),
                      onPressed: () {
                        this.changeCharacterValue(
                            characterSheetViewModel, character, 'PV', 1);
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
                        this.changeUiValue(characterSheetViewModel,
                            characterSheetState.uiState, 'Bonus', -1);
                      },
                    ),
                    CharacterSheetButton(
                        "Bonus",
                        characterSheetState.uiState.benediction.toString(),
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
                        this.changeUiValue(characterSheetViewModel,
                            characterSheetState.uiState, 'Bonus', 1);
                      },
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CharacterSheetButton(
                    "Esprit",
                    character.esprit.toString(),
                    sizeWidth / 4.3,
                    26,
                    50,
                    Colors.blue,
                    () => sendRoll(characterSheetViewModel, RollType.ESPRIT),
                    () => showEditStatAlertDialog(
                        characterSheetViewModel, character, "Esprit")),
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
                            characterSheetViewModel, character, 'PF', -1);
                      },
                    ),
                    CharacterSheetButton(
                        "PF",
                        character.pf.toString() +
                            ' / ' +
                            character.pfMax.toString(),
                        sizeWidth / 5,
                        26,
                        50,
                        characterSheetState.uiState.focus
                            ? Colors.blueGrey
                            : Colors.blue, () {
                      this.changeUiSelect(characterSheetViewModel,
                          characterSheetState.uiState, 'PF');
                    },
                        () => showEditStatAlertDialog(
                            characterSheetViewModel, character, "PF_MAX")),
                    IconButton(
                      iconSize: sizeWidth / 18,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      color: Colors.blue,
                      icon: Icon(Icons.add_circle),
                      onPressed: () {
                        this.changeCharacterValue(
                            characterSheetViewModel, character, 'PF', 1);
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
                        this.changeUiValue(characterSheetViewModel,
                            characterSheetState.uiState, 'Malus', -1);
                      },
                    ),
                    CharacterSheetButton(
                        "Malus",
                        characterSheetState.uiState.malediction.toString()+ (character.getInjury() >0 ? (' ('+
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
                        this.changeUiValue(characterSheetViewModel,
                            characterSheetState.uiState, 'Malus', 1);
                      },
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CharacterSheetButton(
                    "Essence",
                    character.essence.toString(),
                    sizeWidth / 4.3,
                    26,
                    50,
                    Colors.blue,
                    () => sendRoll(characterSheetViewModel, RollType.ESSENCE),
                    () => showEditStatAlertDialog(
                        characterSheetViewModel, character, "Essence")),
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
                            characterSheetViewModel, character, 'PP', -1);
                      },
                    ),
                    CharacterSheetButton(
                        "PP",
                        character.pp.toString() +
                            ' / ' +
                            character.ppMax.toString(),
                        sizeWidth / 5,
                        26,
                        50,
                        characterSheetState.uiState.power
                            ? Colors.blueGrey
                            : Colors.blue, () {
                      this.changeUiSelect(characterSheetViewModel,
                          characterSheetState.uiState, 'PP');
                    },
                        () => showEditStatAlertDialog(
                            characterSheetViewModel, character, "PP_MAX")),
                    IconButton(
                      iconSize: sizeWidth / 18,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      color: Colors.blue,
                      icon: Icon(Icons.add_circle),
                      onPressed: () {
                        this.changeCharacterValue(
                            characterSheetViewModel, character, 'PP', 1);
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
                            characterSheetViewModel, character, 'Dettes', -1);
                      },
                    ),
                    CharacterSheetButton("Dettes", character.dettes.toString(),
                        sizeWidth / 5, 26, 50, Colors.blue, () => {}, () => {}),
                    IconButton(
                      iconSize: sizeWidth / 18,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      color: Colors.blue,
                      icon: Icon(Icons.add_circle),
                      onPressed: () {
                        this.changeCharacterValue(
                            characterSheetViewModel, character, 'Dettes', 1);
                      },
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CharacterSheetButton(
                    "Arcane : " +
                        character.arcanes.toString() +
                        ' / ' +
                        character.arcanesMax.toString(),
                    '',
                    sizeWidth / 5,
                    14,
                    34,
                    Colors.blue,
                    () => showArcaneAlertDialog(characterSheetViewModel),
                    () => showEditStatAlertDialog(
                        characterSheetViewModel, character, "Arcane")),
                CharacterSheetButton(
                    "Magie",
                    '',
                    sizeWidth / 5,
                    14,
                    34,
                    Colors.blue,
                    () =>
                        sendRoll(characterSheetViewModel, RollType.MAGIE_FORTE),
                    () => showEditStatAlertDialog(
                        characterSheetViewModel, character, "MagieForte")),
                CharacterSheetButton(
                    "Cantrip",
                    '',
                    sizeWidth / 5,
                    14,
                    34,
                    Colors.blue,
                    () => sendRoll(
                        characterSheetViewModel, RollType.MAGIE_LEGERE),
                    () => showEditStatAlertDialog(
                        characterSheetViewModel, character, "MagieLegere")),
                CharacterSheetButton(
                    "Empirique",
                    '',
                    sizeWidth / 5,
                    12,
                    34,
                    Colors.blue,
                    () => sendRoll(
                        characterSheetViewModel, RollType.EMPIRIQUE, "1d6"),
                    () => showEmpiriqueRollAlertDialog(
                        characterSheetViewModel, character)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CharacterSheetButton(
                    "Proficiency",
                    '',
                    sizeWidth / 5,
                    14,
                    34,
                    characterSheetState.uiState.proficiency
                        ? Colors.blueGrey
                        : Colors.blue, () {
                  this.changeUiSelect(characterSheetViewModel,
                      characterSheetState.uiState, 'Proficiency');
                }, () => {}),
                CharacterSheetButton(
                    "Aide",
                    '',
                    sizeWidth / 5,
                    14,
                    34,
                    characterSheetState.uiState.help
                        ? Colors.blueGrey
                        : Colors.blue, () {
                  this.changeUiSelect(characterSheetViewModel,
                      characterSheetState.uiState, 'Help');
                }, () => {}),
                CharacterSheetButton(
                    "Secret",
                    '',
                    sizeWidth / 5,
                    14,
                    34,
                    characterSheetState.uiState.secret
                        ? Colors.blueGrey
                        : Colors.blue, () {
                  this.changeUiSelect(characterSheetViewModel,
                      characterSheetState.uiState, 'Secret');
                }, () => {}),
                CharacterSheetButton(
                    "Relance : " + character.relance.toString(),
                    '',
                    sizeWidth / 5,
                    12,
                    34,
                    Colors.blue,
                    () => sendRoll(
                        characterSheetViewModel, RollType.RELANCE),
                        () => showEditStatAlertDialog(
                        characterSheetViewModel, character, "Relance")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [],
            ),
            LayoutBuilder(builder: (context, constraints) {
              List<Widget> rolls = [];
              for (Roll roll in (characterSheetState.rollList ?? [])) {
                rolls.addAll(RollWidget(roll));
              }
              return Column(
                children: rolls,
              );
            }),
          ]);

  void sendRoll(
      CharacterSheetViewModel characterSheetViewModel, RollType rollType,
      [String empirique = '']) {
    characterSheetViewModel.sendRoll(rollType, empirique);
  }

  void changeCharacterValue(CharacterSheetViewModel characterSheetViewModel,
      Character character, String carac, int diff) {
    if (carac == 'PV') {
      character.pv += diff;
    } else if (carac == 'PF') {
      character.pf += diff;
    } else if (carac == 'PP') {
      character.pp += diff;
    } else if (carac == 'Dettes') {
      character.dettes += diff;
    }
    characterSheetViewModel.updateCharacter(character);
  }

  void changeUiValue(CharacterSheetViewModel characterSheetViewModel,
      CharacterSheetUIState uiState, String carac, int diff) {
    if (carac == 'Bonus') {
      uiState.benediction += diff;
    } else if (carac == 'Malus') {
      uiState.malediction += diff;
    }
    characterSheetViewModel.updateUi(uiState);
  }

  void changeUiSelect(CharacterSheetViewModel characterSheetViewModel,
      CharacterSheetUIState uiState, String carac) {
    if (carac == 'PF') {
      uiState.focus = !uiState.focus;
    } else if (carac == 'PP') {
      uiState.power = !uiState.power;
    } else if (carac == 'Proficiency') {
      uiState.proficiency = !uiState.proficiency;
    } else if (carac == 'Help') {
      uiState.help = !uiState.help;
    } else if (carac == 'Secret') {
      uiState.secret = !uiState.secret;
    }
    characterSheetViewModel.updateUi(uiState);
  }

  static CharacterSheetButton(
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
                      if(value != '') Text(
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
  }

  List<Widget> RollWidget(Roll roll) {
    List<TextSpan> rollText = [];
    List<TextSpan> rollDices = [];
    rollText.add(TextSpan(
        // (secret)
        text: roll.secretText()));
    rollText.add(TextSpan(
        // Jonathan
        text: roll.rollerName,
        style: TextStyle(fontWeight: FontWeight.bold)));

    rollText.add(TextSpan(
        // fait un
        text: ' fait un '));
    rollText.add(TextSpan(
        // jet de Chair
        text: roll.rollTypeText(),
        style: TextStyle(fontStyle: FontStyle.italic)));

    String textBonus = '';
    if (roll.malediction > 0) {
      textBonus += '${roll.malediction}m,';
    }
    if (roll.benediction > 0) {
      textBonus += '${roll.benediction}b,';
    }
    if (roll.focus) {
      textBonus += 'pf,';
    }
    if (roll.power) {
      textBonus += 'pp,';
    }
    if (roll.proficiency) {
      textBonus += 'h,';
    }
    if (textBonus.isNotEmpty) {
      textBonus = textBonus.substring(0, textBonus.length - 1);
      rollText.add(TextSpan(
        text: ' (' + textBonus + ')',
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
        rollText.add(TextSpan(
          text: ' et obtient ${roll.success} succès',
        ));
        break;
      case RollType.SAUVEGARDE_VS_MORT:
        if (roll.result[0] >= 10)
          rollText.add(TextSpan(
            text: ' et TODO', // TODO
          ));
        break;
      case RollType.SOIN:
        if (roll.result[0] >= 10)
          rollText.add(TextSpan(
            text: ' et peut distribuer ${roll.success} PV',
          ));
        break;
      case RollType.ARCANE_FIXE:
      case RollType.EMPIRIQUE:
        rollText.add(TextSpan(
          text: '.',
        ));
        break;
      case RollType.RELANCE:
        break;
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
            rollDices.add(TextSpan(
                text: Roll.diceValueToIcon(value),
                style: TextStyle(fontSize: 36)));
          } else if (value == 5) {
            rollDices.add(TextSpan(
                text: Roll.diceValueToIcon(value),
                style: TextStyle(color: Colors.orange, fontSize: 36)));
          } else if (value == 6) {
            rollDices.add(TextSpan(
                text: Roll.diceValueToIcon(value),
                style: TextStyle(color: Colors.red, fontSize: 36)));
          }
        }
        break;
      case RollType.EMPIRIQUE:
        // TODO si c'est d6, mettre le style visuel ?
        for (var value in roll.result) {
          rollDices.add(TextSpan(text: '[$value]'));
        }
        break;
      case RollType.ARCANE_FIXE:
        for (var value in roll.result) {
          rollDices.add(TextSpan(text: '[$value]'));
        }
        break;
      case RollType.SAUVEGARDE_VS_MORT:
        for (var value in roll.result) {
          if (value < 10) {
            rollDices.add(TextSpan(
                text: '[$value]', style: TextStyle(color: Colors.red)));
          } else {
            rollDices.add(TextSpan(
                text: '[$value]', style: TextStyle(color: Colors.green)));
          }
        }
        break;
      case RollType.RELANCE:
        break;
    }
    return [Text.rich(TextSpan(
        text: roll.dateText() + ' - ', // 10:19:22 -
        children: rollText)),
      Text.rich(TextSpan(// 10:19:22 -
        children: rollDices)),
    ];
  }

  Future<void Function()> showEditStatAlertDialog(
      CharacterSheetViewModel characterSheetViewModel,
      Character character,
      String statToEdit) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    late String initialValue;
    if (statToEdit == 'Chair') {
      initialValue = character.chair.toString();
    } else if (statToEdit == 'Esprit') {
      initialValue = character.esprit.toString();
    } else if (statToEdit == 'Essence') {
      initialValue = character.essence.toString();
    } else if (statToEdit == 'PV_MAX') {
      initialValue = character.pvMax.toString();
    } else if (statToEdit == 'PF_MAX') {
      initialValue = character.pfMax.toString();
    } else if (statToEdit == 'PP_MAX') {
      initialValue = character.ppMax.toString();
    } else if (statToEdit == 'Dettes') {
      initialValue = character.dettes.toString();
    } else if (statToEdit == 'Lux') {
      initialValue = character.lux;
    } else if (statToEdit == 'Umbra') {
      initialValue = character.umbra;
    } else if (statToEdit == 'Secunda') {
      initialValue = character.secunda;
    } else if (statToEdit == 'Arcane') {
      initialValue = character.arcanes.toString();
    } else if (statToEdit == 'Relance') {
      initialValue = character.relance.toString();
    }
    final TextEditingController _textEditingController =
        TextEditingController(text: initialValue);
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(statToEdit),
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _textEditingController,
                        validator: (value) {
                          return value != null
                              ? ((value.isNotEmpty &&
                                      double.tryParse(value) != null)
                                  ? null
                                  : "Enter any text")
                              : null;
                        },
                        decoration:
                            InputDecoration(hintText: "Nouvelle valeur"),
                      ),
                    ],
                  )),
              actions: <Widget>[
                InkWell(
                  child: Text('OK   '),
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (statToEdit == 'Chair') {
                        character.chair =
                            int.tryParse(_textEditingController.value.text) ??
                                character.chair;
                      } else if (statToEdit == 'Esprit') {
                        character.esprit =
                            int.tryParse(_textEditingController.value.text) ??
                                character.esprit;
                      } else if (statToEdit == 'Essence') {
                        character.essence =
                            int.tryParse(_textEditingController.value.text) ??
                                character.essence;
                      } else if (statToEdit == 'Dettes') {
                        character.dettes =
                            int.tryParse(_textEditingController.value.text) ??
                                character.dettes;
                      } else if (statToEdit == 'Lux') {
                        character.lux = _textEditingController.value.text;
                      } else if (statToEdit == 'Umbra') {
                        character.umbra = _textEditingController.value.text;
                      } else if (statToEdit == 'Secunda') {
                        character.secunda = _textEditingController.value.text;
                      } else if (statToEdit == 'Arcane') {
                        character.arcanes =
                            int.tryParse(_textEditingController.value.text) ??
                                character.arcanes;
                      } else if (statToEdit == 'Relance') {
                        character.relance =
                            int.tryParse(_textEditingController.value.text) ??
                                character.relance;
                      } else if (statToEdit == 'PV_MAX') {
                        character.pvMax =
                            int.tryParse(_textEditingController.value.text) ??
                                character.pvMax;
                      } else if (statToEdit == 'PF_MAX') {
                        character.pfMax =
                            int.tryParse(_textEditingController.value.text) ??
                                character.pfMax;
                      } else if (statToEdit == 'PP_MAX') {
                        character.ppMax =
                            int.tryParse(_textEditingController.value.text) ??
                                character.ppMax;
                      }
                      characterSheetViewModel.updateCharacter(character);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  Future<void Function()> showEmpiriqueRollAlertDialog(
      CharacterSheetViewModel characterSheetViewModel,
      Character character) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    late String initialValue = "1d6";
    final TextEditingController _textEditingController =
        TextEditingController(text: initialValue);
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Jet empirique"),
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _textEditingController,
                        validator: (value) {
                          return value != null
                              ? ((value.isNotEmpty) ? null : "Enter any text")
                              : null;
                        },
                        decoration: InputDecoration(hintText: "Jet empirique"),
                      ),
                    ],
                  )),
              actions: <Widget>[
                InkWell(
                  child: Text('OK   '),
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      characterSheetViewModel.sendRoll(RollType.EMPIRIQUE,
                          _textEditingController.value.text);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  Future<void Function()> showArcaneAlertDialog(
      CharacterSheetViewModel characterSheetViewModel) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Arcane"),
              actions: <Widget>[
                InkWell(
                  child: Text('Fixe'),
                  onTap: () {
                    characterSheetViewModel.sendRoll(RollType.ARCANE_FIXE);
                    Navigator.of(context).pop();
                  },
                ),
                InkWell(
                  child: Text('Esprit'),
                  onTap: () {
                    characterSheetViewModel.sendRoll(RollType.ARCANE_ESPRIT);
                    Navigator.of(context).pop();
                  },
                ),
                InkWell(
                  child: Text('Essence'),
                  onTap: () {
                    characterSheetViewModel.sendRoll(RollType.ARCANE_ESSENCE);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }
}
