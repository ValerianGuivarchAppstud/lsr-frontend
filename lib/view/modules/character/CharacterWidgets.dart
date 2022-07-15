import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lsr/domain/models/RollType.dart';
import 'package:lsr/view/modules/mj/MjViewModel.dart';

import '../../../domain/models/Character.dart';
import '../../../domain/models/Roll.dart';
import '../../../utils/view/Const.dart';
import '../mj/MjWidgets.dart';
import 'CharacterSheetState.dart';
import 'CharacterSheetViewModel.dart';

class CharacterWidgets {
  static void sendRoll(
      CharacterSheetViewModel characterSheetViewModel, RollType rollType,
      [String empirique = '', String? resistRoll = null]) {
    characterSheetViewModel.sendRoll(rollType, empirique, resistRoll);
  }

  static buildCharacter(
          BuildContext context,
          bool playerDisplay,
          Character character,
          double sizeRatio,
          double sizeRatioFont,
          CharacterSheetViewModel characterSheetViewModel,
          CharacterSheetState characterSheetState,
          TextEditingController? noteFieldController,
          List<String>? pjAlliesNames,
          LayoutBuilder? rollList,
      MjViewModel? mjViewModel) =>
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (playerDisplay)
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Image.network(
                      character.background,
                      //"assets/images/background/${describeEnum(character.bloodline != Bloodline.AUCUN ? character.bloodline : character.classe).toLowerCase()}.jpg",
                      fit: BoxFit.fill,
                      height: 120,
                      width: (sizeRatio * WIDTH_SCREEN),
                    )),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                        onLongPress: () => {
                              developer.log(
                                  characterSheetState.character?.playerName ??
                                      ''),
                              MjWidgets.buildCreateCharacterAlertDialog(
                                  characterSheetState.character,
                                  context,
                                  [
                                    characterSheetState.character?.playerName ??
                                        ''
                                  ],
                                  characterSheetViewModel
                                      .createOrUpdateCharacter)
                            },
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
                              foregroundImage:
                                  NetworkImage(character.picture),
                              //"assets/images/portraits/${character.name}.png"),
                            )
                          ],
                        ))),
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
                                      fontSize: sizeRatioFont * 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    'Lux : ' + character.lux,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: sizeRatioFont * 16,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    'Umbra : ' + character.umbra,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: sizeRatioFont * 16,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    'Secunda : ' + character.secunda,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: sizeRatioFont * 16,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              )
                            ]))))
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Text(
                character.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
                  IconButton(
                      color: Colors.transparent,
                      onPressed: () {
                        mjViewModel?.removeCharacterList(character.name);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      )),
            ]),
          if (noteFieldController != null)
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: TextField(
                controller: noteFieldController,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onChanged: (value) => {
                  characterSheetState.lastTimeNoteSaved = DateTime.now(),
                  characterSheetState.notes = value,
                  Timer(Duration(seconds: 3), () {
                    characterSheetViewModel.saveNotesIfEnoughTime(
                        DateTime.now().add(Duration(seconds: -3)));
                  })
                },
                decoration: InputDecoration(
                    hintText: "Entrez vos notes ici",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: characterSheetState.lastTimeNoteSaved != null
                                ? Colors.redAccent
                                : Colors.blue)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: characterSheetState.lastTimeNoteSaved != null
                                ? Colors.redAccent
                                : Colors.blue))),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildCharacterSheetButton(
                  playerDisplay ? "Chair" : "Ch",
                  character.chair.toString(),
                  (sizeRatio * WIDTH_SCREEN) / 4.3,
                  sizeRatioFont * 26,
                  50,
                  Colors.blue,
                  playerDisplay,
                  () => sendRoll(characterSheetViewModel, RollType.CHAIR, ''),
                  () => showEditStatAlertDialog(
                      context, characterSheetViewModel, character, "Chair")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: (sizeRatioFont * WIDTH_SCREEN) / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      changeCharacterValue(
                          characterSheetViewModel, character, 'PV', -1);
                    },
                  ),
                  buildCharacterSheetButton(
                      "PV",
                      character.pv.toString() +
                          ' / ' +
                          character.pvMax.toString(),
                      (sizeRatio * WIDTH_SCREEN) / 5,
                      sizeRatioFont * 26,
                      50,
                      Colors.blue,
                      playerDisplay,
                      () => {},
                      () => showEditStatAlertDialog(context,
                          characterSheetViewModel, character, "PV_MAX")),
                  IconButton(
                    iconSize: (sizeRatioFont * WIDTH_SCREEN) / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      changeCharacterValue(
                          characterSheetViewModel, character, 'PV', 1);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: (sizeRatioFont * WIDTH_SCREEN) / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      changeUiValue(characterSheetViewModel,
                          characterSheetState.uiState, 'Bonus', -1);
                    },
                  ),
                  buildCharacterSheetButton(
                      "Bonus",
                      characterSheetState.uiState.benediction.toString(),
                      (sizeRatio * WIDTH_SCREEN) / 5,
                      sizeRatioFont * 26,
                      50,
                      Colors.blue,
                      playerDisplay,
                      () => {},
                      () => {}),
                  IconButton(
                    iconSize: (sizeRatioFont * WIDTH_SCREEN) / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      changeUiValue(characterSheetViewModel,
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
              buildCharacterSheetButton(
                  playerDisplay ? "Esprit" : "Esp",
                  character.esprit.toString(),
                  (sizeRatio * WIDTH_SCREEN) / 4.3,
                  sizeRatioFont * 26,
                  50,
                  Colors.blue,
                  playerDisplay,
                  () => sendRoll(characterSheetViewModel, RollType.ESPRIT, ''),
                  () => showEditStatAlertDialog(
                      context, characterSheetViewModel, character, "Esprit")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: (sizeRatioFont * WIDTH_SCREEN) / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      changeCharacterValue(
                          characterSheetViewModel, character, 'PF', -1);
                    },
                  ),
                  buildCharacterSheetButton(
                      "PF",
                      character.pf.toString() +
                          ' / ' +
                          character.pfMax.toString(),
                      (sizeRatio * WIDTH_SCREEN) / 5,
                      sizeRatioFont * 26,
                      50,
                      characterSheetState.uiState.focus
                          ? Colors.blueGrey
                          : Colors.blue,
                      playerDisplay, () {
                    changeUiSelect(characterSheetViewModel,
                        characterSheetState.uiState, 'PF');
                  },
                      () => showEditStatAlertDialog(context,
                          characterSheetViewModel, character, "PF_MAX")),
                  IconButton(
                    iconSize: (sizeRatioFont * WIDTH_SCREEN) / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      changeCharacterValue(
                          characterSheetViewModel, character, 'PF', 1);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: (sizeRatioFont * WIDTH_SCREEN) / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      changeUiValue(characterSheetViewModel,
                          characterSheetState.uiState, 'Malus', -1);
                    },
                  ),
                  buildCharacterSheetButton(
                      "Malus",
                      characterSheetState.uiState.malediction.toString() +
                          (character.getInjury() > 0
                              ? (' (' + character.getInjury().toString() + ')')
                              : ('')),
                      (sizeRatio * WIDTH_SCREEN) / 5,
                      sizeRatioFont * 26,
                      50,
                      Colors.blue,
                      playerDisplay,
                      () => {},
                      () => {}),
                  IconButton(
                    iconSize: (sizeRatioFont * WIDTH_SCREEN) / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      changeUiValue(characterSheetViewModel,
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
              buildCharacterSheetButton(
                  playerDisplay ? "Essence" : "Ess",
                  character.essence.toString(),
                  (sizeRatio * WIDTH_SCREEN) / 4.3,
                  sizeRatioFont * 26,
                  50,
                  Colors.blue,
                  playerDisplay,
                  () => sendRoll(characterSheetViewModel, RollType.ESSENCE, ''),
                  () => showEditStatAlertDialog(
                      context, characterSheetViewModel, character, "Essence")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: (sizeRatioFont * WIDTH_SCREEN) / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      changeCharacterValue(
                          characterSheetViewModel, character, 'PP', -1);
                    },
                  ),
                  buildCharacterSheetButton(
                      "PP",
                      character.pp.toString() +
                          ' / ' +
                          character.ppMax.toString(),
                      (sizeRatio * WIDTH_SCREEN) / 5,
                      sizeRatioFont * 26,
                      50,
                      characterSheetState.uiState.power
                          ? Colors.blueGrey
                          : Colors.blue,
                      playerDisplay, () {
                    changeUiSelect(characterSheetViewModel,
                        characterSheetState.uiState, 'PP');
                  },
                      () => showEditStatAlertDialog(context,
                          characterSheetViewModel, character, "PP_MAX")),
                  IconButton(
                    iconSize: (sizeRatioFont * WIDTH_SCREEN) / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      changeCharacterValue(
                          characterSheetViewModel, character, 'PP', 1);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: (sizeRatioFont * WIDTH_SCREEN) / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      changeCharacterValue(
                          characterSheetViewModel, character, 'Dettes', -1);
                    },
                  ),
                  buildCharacterSheetButton(
                      "Dettes",
                      character.dettes.toString(),
                      (sizeRatio * WIDTH_SCREEN) / 5,
                      sizeRatioFont * 26,
                      50,
                      Colors.blue,
                      playerDisplay,
                      () => {},
                      () => {}),
                  IconButton(
                    iconSize: (sizeRatioFont * WIDTH_SCREEN) / 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: Colors.blue,
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      changeCharacterValue(
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
              buildCharacterSheetButton(
                  '',
                  (playerDisplay ? "Arcane : " : "Arc ") +
                      character.arcanes.toString() +
                      (playerDisplay ? ' / ' +
                      character.arcanesMax.toString() : ''),
                  (sizeRatio * WIDTH_SCREEN) / 5,
                  sizeRatioFont * 14,
                  34,
                  Colors.blue,
                  playerDisplay,
                  () => showArcaneAlertDialog(context, characterSheetViewModel),
                  () => showEditStatAlertDialog(
                      context, characterSheetViewModel, character, "Arcane")),
              buildCharacterSheetButton(
                  '',
                  "Magie",
                  (sizeRatio * WIDTH_SCREEN) / 5,
                  sizeRatioFont * 14,
                  34,
                  Colors.blue,
                  playerDisplay,
                  () => sendRoll(
                      characterSheetViewModel, RollType.MAGIE_FORTE, ''),
                  () => showEditStatAlertDialog(context,
                      characterSheetViewModel, character, "MagieForte")),
              buildCharacterSheetButton(
                  '',
                  "Cantrip",
                  (sizeRatio * WIDTH_SCREEN) / 5,
                  sizeRatioFont * 14,
                  34,
                  Colors.blue,
                  playerDisplay,
                  () => sendRoll(
                      characterSheetViewModel, RollType.MAGIE_LEGERE, ''),
                  () => showEditStatAlertDialog(context,
                      characterSheetViewModel, character, "MagieLegere")),
              buildCharacterSheetButton(
                  '',
                  playerDisplay ? "Empirique" : "Emp",
                  (sizeRatio * WIDTH_SCREEN) / 5,
                  sizeRatioFont * 12,
                  34,
                  Colors.blue,
                  playerDisplay,
                  () => sendRoll(
                      characterSheetViewModel, RollType.EMPIRIQUE, "1d6"),
                  () => showEmpiriqueRollAlertDialog(
                      context, characterSheetViewModel, character)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildCharacterSheetButton(
                  '',
                  playerDisplay ? "Proficiency" : "Pr",
                  (sizeRatio * WIDTH_SCREEN) / 5,
                  sizeRatioFont * 14,
                  34,
                  characterSheetState.uiState.proficiency
                      ? Colors.blueGrey
                      : Colors.blue,
                  playerDisplay, () {
                changeUiSelect(characterSheetViewModel,
                    characterSheetState.uiState, 'Proficiency');
              }, () => {}),
              buildCharacterSheetButton(
                  '',
                  (characterSheetState.uiState.characterToHelp == null)
                      ? "Aider"
                      : "Aider ${characterSheetState.uiState.characterToHelp}",
                  (sizeRatio * WIDTH_SCREEN) / 5,
                  sizeRatioFont * 14,
                  34,
                  characterSheetState.uiState.help
                      ? Colors.blueGrey
                      : Colors.blue,
                  playerDisplay, () {
                if (characterSheetState.uiState.characterToHelp == null) {
                  showHelpingRollAlertDialog(context, characterSheetViewModel,
                      pjAlliesNames ?? [], characterSheetState.uiState);
                } else {
                  characterSheetState.uiState.characterToHelp = null;
                  characterSheetViewModel.updateUi(characterSheetState.uiState);
                }
              }, () => {}),
              buildCharacterSheetButton(
                  '',
                  "Secret",
                  (sizeRatio * WIDTH_SCREEN) / 5,
                  sizeRatioFont * 14,
                  34,
                  characterSheetState.uiState.secret
                      ? Colors.blueGrey
                      : Colors.blue,
                  playerDisplay, () {
                changeUiSelect(characterSheetViewModel,
                    characterSheetState.uiState, 'Secret');
              }, () => {}),
              buildCharacterSheetButton(
                  '',
                  "Relance : " + character.relance.toString(),
                  (sizeRatio * WIDTH_SCREEN) / 5,
                  sizeRatioFont * 12,
                  34,
                  Colors.blue,
                  playerDisplay,
                  () => sendRoll(characterSheetViewModel, RollType.RELANCE, ''),
                  () => showEditStatAlertDialog(
                      context, characterSheetViewModel, character, "Relance")),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [],
          ),
          if (rollList != null) rollList
//            if(rollList != null) buildRollList(rollList, character.name, resistRoll, [character.name])
        ],
      );

  static LayoutBuilder buildRollList(
      List<Roll>? rollList,
      String? characterName,
      CharacterSheetViewModel? characterSheetViewModel,
      MjViewModel? mjViewModel,
      List<String>? resistingCharacters) {
    return LayoutBuilder(builder: (context, constraints) {
      List<Widget> rolls = [];
      for (Roll roll in (rollList ?? [])) {
        if (!roll.secret ||
            characterName == null ||
            roll.rollerName == characterName) {
          rolls.add(getRollWidget(context, roll, characterSheetViewModel, mjViewModel,
              resistingCharacters, null));
          for (Roll resistRoll in roll.resistRollList) {
            rolls.add(getRollWidget(context, resistRoll, characterSheetViewModel,
                mjViewModel, resistingCharacters, roll));
          }
        }
      }
      return Column(
        children: rolls,
      );
    });
  }

  static buildCharacterSheetButton(
      String title,
      String value,
      double width,
      double fontSize,
      double height,
      MaterialColor color,
      bool playerDisplay,
      void Function() onPressed,
      void Function() onLongPress) {
    if (!playerDisplay) {
      if (title != '' && value != '') {
        height = height / 2;
        value = title + ' : ' + value;
        title = '';
      } else if (value != '') {
        height = height / 1.5;
        title = value;
        value = '';
        fontSize = fontSize * 4;
      }
    }
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
                      if (title != '')
                        Text(
                          title,
                          style: TextStyle(fontSize: fontSize / 2),
                          textAlign: TextAlign.center,
                        ),
                      if (value != '')
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

  static void changeCharacterValue(
      CharacterSheetViewModel characterSheetViewModel,
      Character character,
      String carac,
      int diff) {
    if (carac == 'PV') {
      character.pv += diff;
    } else if (carac == 'PF') {
      character.pf += diff;
    } else if (carac == 'PP') {
      character.pp += diff;
    } else if (carac == 'Dettes') {
      character.dettes += diff;
    }
    characterSheetViewModel.createOrUpdateCharacter(character);
  }

  static void changeUiValue(CharacterSheetViewModel characterSheetViewModel,
      CharacterSheetUIState uiState, String carac, int diff) {
    if (carac == 'Bonus') {
      uiState.benediction += diff;
    } else if (carac == 'Malus') {
      uiState.malediction += diff;
    }
    characterSheetViewModel.updateUi(uiState);
  }

  static void changeUiSelect(CharacterSheetViewModel characterSheetViewModel,
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

  static Container getRollWidget(
      BuildContext context,
      Roll roll,
      CharacterSheetViewModel? characterSheetViewModel,
      MjViewModel? mjViewModel,
      List<String>? resistingCharacters,
      Roll? resistingRoll) {
    List<TextSpan> rollText = [];
    List<TextSpan> rollDices = [];
    rollText.add(TextSpan(
        // (secret)
        text: roll.secretText(),
        style: TextStyle(height: 0 //You can set your custom height here
            )));
    rollText.add(TextSpan(
        // Jonathan
        text: roll.rollerName,
        style: TextStyle(fontWeight: FontWeight.bold)));
    resistingRoll !=null ?
    rollText.add(TextSpan(
      // fait un
        text: ' résiste avec un '))
    : rollText.add(TextSpan(
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

    if (roll.characterToHelp != null && roll.characterToHelp != "") {
      rollText.add(TextSpan(
        text: ' pour aider ${roll.characterToHelp}',
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
    if (resistingRoll == null &&
        (roll.rollType == RollType.ARCANE_ESPRIT ||
            roll.rollType == RollType.ARCANE_ESSENCE ||
            roll.rollType == RollType.CHAIR ||
            roll.rollType == RollType.ESPRIT ||
            roll.rollType == RollType.ESSENCE ||
            roll.rollType == RollType.MAGIE_FORTE)) {
      rollText.add(TextSpan(text: ' ('));
      rollText.add(
        TextSpan(
            text: " R-Chair",
            style: TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () => sendResistingRoll(context, RollType.CHAIR, roll.id,
                  characterSheetViewModel, mjViewModel, resistingCharacters)),
      );
      rollText.add(TextSpan(text: ' / '));
      rollText.add(
        TextSpan(
            text: " R-Esprit",
            style: TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () => sendResistingRoll(context, RollType.ESPRIT, roll.id,
                  characterSheetViewModel, mjViewModel, resistingCharacters)),
      );
      rollText.add(TextSpan(text: ' / '));
      rollText.add(
        TextSpan(
            text: " R-Essence",
            style: TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () => sendResistingRoll(context, RollType.ESSENCE, roll.id,
                  characterSheetViewModel, mjViewModel, resistingCharacters)),
      );
      rollText.add(TextSpan(text: ')'));
    }
    if (resistingRoll != null){
      rollText.add(TextSpan(text: ' ('));
      rollText.add(
        TextSpan(
            text: " Subir : ${roll.getDegats(resistingRoll)}",
            style: TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () => subir(roll.rollerName, characterSheetViewModel, mjViewModel, roll.getDegats(resistingRoll)),
      ));
      rollText.add(TextSpan(text: ')'));
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
    return Container(
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(width: 1.0, color: Colors.grey),
        )),
        child: Row(children: <Widget>[
          if (resistingRoll != null)
            Padding(
                padding: EdgeInsets.fromLTRB(24, 5, 34, 0),
                child: Container(
                  color: Colors.black45,
                  height: 80,
                  width: 2,
                )),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                foregroundImage: NetworkImage(roll.picture ?? ''),
                //"assets/images/portraits/${character.name}.png"),
              )),
          Flexible(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Wrap(children: [
                      Text.rich(TextSpan(
                          text: roll.dateText() + ' - ', // 10:19:22 -
                          children: rollText),)
                    ]),
                    Text.rich(TextSpan(
                        // 10:19:22 -
                        children: rollDices),
                    textAlign: TextAlign.center,),
                  ])))
        ]));
  }

  static Future<void Function()> showEditStatAlertDialog(
      BuildContext context,
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
                      characterSheetViewModel
                          .createOrUpdateCharacter(character);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  static Future<void Function()> showHelpingRollAlertDialog(
      BuildContext context,
      CharacterSheetViewModel characterSheetViewModel,
      List<String> pjAlliesNames,
      CharacterSheetUIState uiState) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String? characterToHelp = null;
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Jet d'aide"),
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: DropdownButton<String>(
                          hint: Text('Qui aides-tu ?'),
                          value: characterToHelp,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          onChanged: (String? newValue) {
                            setState(() {
                              characterToHelp = newValue;
                            });
                          },
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          items: pjAlliesNames
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  )),
              actions: <Widget>[
                InkWell(
                  child: Text('OK   '),
                  onTap: () {
                    if (characterToHelp != null) {
                      uiState.characterToHelp = characterToHelp;
                      characterSheetViewModel.updateUi(uiState);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  static Future<void Function()> showEmpiriqueRollAlertDialog(
      BuildContext context,
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

  static Future<void Function()> showArcaneAlertDialog(BuildContext context,
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

  static sendResistingRoll(
      BuildContext context,
      RollType rollType,
      String id,
      CharacterSheetViewModel? characterSheetViewModel,
      MjViewModel? mjViewModel,
      List<String>? resistingCharacters) {
    if (characterSheetViewModel != null) {
      sendRoll(characterSheetViewModel, rollType, '', id);
    } else if (mjViewModel != null && resistingCharacters != null) {
      showSelectResistDialog(context, mjViewModel, resistingCharacters, id, rollType);
    }
  }


  static Future<void Function()> showSelectResistDialog(
      BuildContext context,
      MjViewModel mjViewModel,
      List<String> characterNames,
      String id,
      RollType rollType) async {
    Map<String, bool> characterList = {};

    List<bool> characterNamesChecked = [];
    for( var i = 0 ; i < characterNames.length; i++ ) {
      characterList[characterNames[i]] = false;
    }
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Résistance'),
                actions: <Widget>[
                  InkWell(
                      child: Text('OK   '),
                      onTap: () {
                        for( var i = 0 ; i < characterNames.length; i++ ) {
                          if(characterNamesChecked[i])
                            sendRoll(mjViewModel.getCharacterViewModel(characterNames[i]), rollType, '', id);
                        }
                        Navigator.of(context).pop();
                      }
                  )
                ],
                content: Container(
                  width: double.minPositive,
                  height: (50 * characterNames.length).toDouble(),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: characterList.length,
                    itemBuilder: (BuildContext context, int index) {
                      String _key = characterList.keys.elementAt(index);
                      return CheckboxListTile(
                        value: characterList[_key],
                        title: Text(_key),
                        onChanged: (val) {
                          setState(() {
                            characterList[_key] = val ?? false;
                          });
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        });
    /*return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Résister"),
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.builder(
                        itemCount: characterNames.length,
                        itemBuilder: (_, index) {
                          return ListView.builder(
                            itemCount: characterNames.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                title: Text(characterNames[index]),
                                value: characterNamesChecked[index],
                                onChanged: (val) {
                                  setState(
                                        () {
                                          characterNamesChecked[index] = val ?? false;
                                    },
                                  );
                                },
                              );
                            },
                          );/*CheckboxListTile(
                            title: Text(characterNames[index]),
                            value: characterNamesChecked[index],
                            onChanged: (val) {
                              setState(() {
                                characterNamesChecked[index] = val ?? false;
                              });
                            },
                          );*/
                        },
                      ),
                    ],
                  )),
              actions: <Widget>[
                InkWell(
                  child: Text('OK   '),
                  onTap: () {
                    for( var i = 0 ; i < characterNames.length; i++ ) {
                      if(characterNamesChecked[i])
                      sendRoll(mjViewModel.getCharacterViewModel(characterNames[i]), RollType.CHAIR, '', id);
                    }
                      Navigator.of(context).pop();
                    }
            )
              ],
            );
          });
        });*/
  }


  static subir( String name, CharacterSheetViewModel? characterSheetViewModel, MjViewModel? mjViewModel, int degats) {
    if(characterSheetViewModel != null) {
      characterSheetViewModel.subir(degats);
    } else if (mjViewModel != null) {
      mjViewModel.subir(name, degats);
    }
  }
}
