import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lsr/domain/models/Apotheose.dart';
import 'package:lsr/domain/models/Classe.dart';
import 'package:lsr/domain/models/RollType.dart';
import 'package:lsr/view/modules/mj/MjViewModel.dart';

import '../../../domain/models/Character.dart';
import '../../../domain/models/Roll.dart';
import '../mj/MjWidgets.dart';
import 'CharacterSheetState.dart';
import 'CharacterSheetViewModel.dart';

class CharacterWidgets {
  static List<Color> colors = [];

  static getColorList() {
    if (colors.length == 0) {
      colors.add(Colors.white);
      for (MaterialColor materialColor in Colors.primaries) {
        colors.add(materialColor.shade100);
        colors.add(materialColor.shade200);
        colors.add(materialColor.shade300);
        colors.add(materialColor.shade400);
        colors.add(materialColor.shade500);
        colors.add(materialColor.shade600);
        colors.add(materialColor.shade700);
        colors.add(materialColor.shade800);
        colors.add(materialColor.shade900);
      }
//      colors.sort((c1, c2) => c1.value - c2.value);
    } else {
      return colors;
    }
  }

  static void sendRoll(
      CharacterSheetViewModel characterSheetViewModel, RollType rollType,
      [String empirique = '', String? resistRoll = null]) {
    characterSheetViewModel.sendRoll(rollType, empirique, resistRoll);
  }

  static buildCharacter(
          BuildContext context,
          bool playerDisplay,
          bool? played,
          bool turn,
          Character character,
          double width,
          double sizeRatio,
          double sizeRatioFont,
          CharacterSheetViewModel characterSheetViewModel,
          CharacterSheetState characterSheetState,
          TextEditingController? noteFieldController,
          List<String>? alliesName,
          LayoutBuilder? rollList,
          MjViewModel? mjViewModel) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (playerDisplay)
            Stack(
              alignment: Alignment.topLeft,
              children: [
                if (character.background != "")
                  Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Image.network(
                        character.background,
                        fit: BoxFit.fill,
                        height: 120,
                        width: (sizeRatio * width),
                      )),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                        onLongPress: () => {
                              MjWidgets.buildCreateCharacterAlertDialog(
                                  characterSheetState.character,
                                  context,
                                  characterSheetState.playersName ?? [],
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
                                  character.apotheose == Apotheose.NONE
                                      ? NetworkImage(character.picture)
                                      : NetworkImage(
                                          character.pictureApotheose != ""
                                              ? character.pictureApotheose
                                              : character.picture),
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
                            ])))),
              ],
            )
          else
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                  onLongPress: () => {
                        MjWidgets.buildCreateCharacterAlertDialog(
                            characterSheetState.character,
                            context,
                            characterSheetState.playersName ?? [],
                            characterSheetViewModel.createOrUpdateCharacter)
                      },
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        foregroundImage: character.apotheose == Apotheose.NONE
                            ? NetworkImage(character.picture)
                            : NetworkImage(character.pictureApotheose != ""
                                ? character.pictureApotheose
                                : character.picture),
                      ))),
              Text(
                character.name,
                style: TextStyle(
                  color: character.dettes >= 5 ? Colors.red : Colors.black,
                  fontSize: 20,
                  fontWeight: character.dettes >= 5
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
                textAlign: TextAlign.start,
              ),
              if (played != null)
                if (!played)
                  if (turn)
                    IconButton(
                        color: Colors.transparent,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: (Colors.green),
                        ))
                  else
                    IconButton(
                        color: Colors.transparent,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: (Colors.blueGrey),
                        )),
              if (played != null)
                if (played)
                  if (turn)
                    IconButton(
                        color: Colors.transparent,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.check_circle,
                          color: (Colors.green),
                        ))
                  else
                    IconButton(
                        color: Colors.transparent,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.check_circle,
                          color: (Colors.blueGrey),
                        )),
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
          if (character.apotheose == Apotheose.NORMALE)
            Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: Text('Apothéose',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: playerDisplay ? 18 : 12,
                        fontWeight: FontWeight.bold))),
          if (character.apotheose == Apotheose.ARCANIQUE)
            Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: Text('Apothéose Arcanique',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: playerDisplay ? 18 : 12,
                        fontWeight: FontWeight.bold))),
          if (character.apotheose == Apotheose.FINALE)
            Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: Text('Apothéose Finale',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: playerDisplay ? 18 : 12,
                        fontWeight: FontWeight.bold))),
          if (character.apotheose == Apotheose.FORME_VENGERESSE)
            Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: Text('forme Vengeresse',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: playerDisplay ? 18 : 12,
                        fontWeight: FontWeight.bold))),
          if (character.apotheose == Apotheose.IMPROVED)
            Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: Text(
                    'Apothéose Amélioré : ${character.apotheoseImprovement}',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: playerDisplay ? 18 : 12,
                        fontWeight: FontWeight.bold))),
          if (character.apotheose == Apotheose.SURCHARGE_IMPROVED)
            Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: Text(
                    'Surcharge Améliorée : ${character.apotheoseImprovement}',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: playerDisplay ? 18 : 12,
                        fontWeight: FontWeight.bold))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildCharacterSheetButton(
                  playerDisplay ? "Chair" : "Ch",
                  character.chair.toString(),
                  (sizeRatio * width) / 4.3,
                  sizeRatioFont * 26,
                  50,
                  character.buttonColorOrDefault(),
                  character.textColorOrDefault(),
                  playerDisplay,
                  () => sendRoll(characterSheetViewModel, RollType.CHAIR, ''),
                  () => showEditStatAlertDialog(
                      context, characterSheetViewModel, character, "Chair")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: (sizeRatio * width) / 12,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: character.buttonColorOrDefault(),
                    //character.buttonColorOrDefault(),
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
                      (sizeRatio * width) / 5,
                      sizeRatioFont * 26,
                      50,
                      character.pv <= 0
                          ? Colors.blueGrey
                          : character.buttonColorOrDefault(),
                      character.pv <= 0
                          ? Colors.white
                          : character.textColorOrDefault(),
                      playerDisplay,
                      () => {
                            if (character.pv <= 0)
                              {
                                sendRoll(characterSheetViewModel,
                                    RollType.SAUVEGARDE_VS_MORT)
                              }
                          },
                      () => showEditStatAlertDialog(context,
                          characterSheetViewModel, character, "PV_MAX")),
                  IconButton(
                    iconSize: (sizeRatio * width) / 12,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: character.buttonColorOrDefault(),
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
                    iconSize: (sizeRatio * width) / 12,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: character.buttonColorOrDefault(),
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      changeUiValue(characterSheetViewModel,
                          characterSheetState.uiState, 'Bonus', -1);
                    },
                  ),
                  buildCharacterSheetButton(
                      "Bonus",
                      (character.apotheose == Apotheose.NONE
                              ? characterSheetState.uiState.benediction
                                  .toString()
                              : character.apotheose == Apotheose.FINALE
                                  ? characterSheetState.uiState.benediction
                                          .toString() +
                                      '+5'
                                  : character.apotheose == Apotheose.ARCANIQUE
                                      ? characterSheetState.uiState.benediction
                                              .toString() +
                                          '+2'
                                      : characterSheetState.uiState.benediction
                                              .toString() +
                                          '+3') +
                          ((character.help ?? 0) > 0
                              ? (' (' + character.help!.toString() + ')')
                              : ('')),
                      (sizeRatio * width) / 5,
                      sizeRatioFont * 26,
                      50,
                      character.buttonColorOrDefault(),
                      character.textColorOrDefault(),
                      playerDisplay,
                      () => {},
                      () => {}),
                  IconButton(
                    iconSize: (sizeRatio * width) / 12,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: character.buttonColorOrDefault(),
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
                  (sizeRatio * width) / 4.3,
                  sizeRatioFont * 26,
                  50,
                  character.buttonColorOrDefault(),
                  character.textColorOrDefault(),
                  playerDisplay,
                  () => sendRoll(characterSheetViewModel, RollType.ESPRIT, ''),
                  () => showEditStatAlertDialog(
                      context, characterSheetViewModel, character, "Esprit")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: (sizeRatio * width) / 12,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: character.buttonColorOrDefault(),
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
                      (sizeRatio * width) / 5,
                      sizeRatioFont * 26,
                      50,
                      characterSheetState.uiState.focus
                          ? Colors.blueGrey
                          : character.buttonColorOrDefault(),
                      characterSheetState.uiState.focus
                          ? Colors.white
                          : character.textColorOrDefault(),
                      playerDisplay, () {
                    changeUiSelect(characterSheetViewModel,
                        characterSheetState.uiState, 'PF');
                  },
                      () => showEditStatAlertDialog(context,
                          characterSheetViewModel, character, "PF_MAX")),
                  IconButton(
                    iconSize: (sizeRatio * width) / 12,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: character.buttonColorOrDefault(),
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
                    iconSize: (sizeRatio * width) / 12,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: character.buttonColorOrDefault(),
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
                      (sizeRatio * width) / 5,
                      sizeRatioFont * 26,
                      50,
                      character.buttonColorOrDefault(),
                      character.textColorOrDefault(),
                      playerDisplay,
                      () => {},
                      () => {}),
                  IconButton(
                    iconSize: (sizeRatio * width) / 12,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: character.buttonColorOrDefault(),
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
                  (sizeRatio * width) / 4.3,
                  sizeRatioFont * 26,
                  50,
                  character.buttonColorOrDefault(),
                  character.textColorOrDefault(),
                  playerDisplay,
                  () => sendRoll(characterSheetViewModel, RollType.ESSENCE, ''),
                  () => showEditStatAlertDialog(
                      context, characterSheetViewModel, character, "Essence")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: (sizeRatio * width) / 12,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: character.buttonColorOrDefault(),
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
                      (sizeRatio * width) / 5,
                      sizeRatioFont * 26,
                      50,
                      characterSheetState.uiState.power
                          ? Colors.blueGrey
                          : character.buttonColorOrDefault(),
                      characterSheetState.uiState.power
                          ? Colors.white
                          : character.textColorOrDefault(),
                      playerDisplay, () {
                    changeUiSelect(characterSheetViewModel,
                        characterSheetState.uiState, 'PP');
                  },
                      () => showEditStatAlertDialog(context,
                          characterSheetViewModel, character, "PP_MAX")),
                  IconButton(
                    iconSize: (sizeRatio * width) / 12,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: character.buttonColorOrDefault(),
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
                    iconSize: (sizeRatio * width) / 12,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: character.buttonColorOrDefault(),
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      changeCharacterValue(
                          characterSheetViewModel, character, 'Dettes', -1);
                    },
                  ),
                  buildCharacterSheetButton(
                      "Dettes",
                      character.dettes.toString(),
                      (sizeRatio * width) / 5,
                      sizeRatioFont * 26,
                      50,
                      character.buttonColorOrDefault(),
                      character.textColorOrDefault(),
                      playerDisplay,
                      () => {},
                      () => {}),
                  IconButton(
                    iconSize: (sizeRatio * width) / 12,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: character.buttonColorOrDefault(),
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
                      (playerDisplay
                          ? ' / ' + character.arcanesMax.toString()
                          : ''),
                  (sizeRatio * width) / 6.5,
                  sizeRatioFont * 14,
                  34,
                  character.buttonColorOrDefault(),
                  character.textColorOrDefault(),
                  playerDisplay,
                  () => showArcaneAlertDialog(context, characterSheetViewModel),
                  () => showEditStatAlertDialog(
                      context, characterSheetViewModel, character, "Arcane")),
              buildCharacterSheetButton(
                  '',
                  playerDisplay ? "Magie" : "Mag",
                  (sizeRatio * width) / 6.5,
                  sizeRatioFont * 14,
                  34,
                  character.buttonColorOrDefault(),
                  character.textColorOrDefault(),
                  playerDisplay,
                  () => sendRoll(
                      characterSheetViewModel, RollType.MAGIE_FORTE, ''),
                  () => showEditStatAlertDialog(context,
                      characterSheetViewModel, character, "MagieForte")),
              buildCharacterSheetButton(
                  '',
                  playerDisplay ? "Cantrip" : "Cant",
                  (sizeRatio * width) / 6.5,
                  sizeRatioFont * 14,
                  34,
                  character.buttonColorOrDefault(),
                  character.textColorOrDefault(),
                  playerDisplay,
                  () => sendRoll(
                      characterSheetViewModel, RollType.MAGIE_LEGERE, ''),
                  () => showEditStatAlertDialog(context,
                      characterSheetViewModel, character, "MagieLegere")),
              buildCharacterSheetButton(
                  '',
                  playerDisplay ? "Empirique" : "Emp",
                  (sizeRatio * width) / 6.5,
                  sizeRatioFont * 12,
                  34,
                  character.buttonColorOrDefault(),
                  character.textColorOrDefault(),
                  playerDisplay,
                  () => sendRoll(
                      characterSheetViewModel, RollType.EMPIRIQUE, "1d6"),
                  () => showEmpiriqueRollAlertDialog(
                      context, characterSheetViewModel, character)),
              buildCharacterSheetButton(
                  '',
                  playerDisplay ? "Apothéose" : "Apo",
                  (sizeRatio * width) / 6.5,
                  sizeRatioFont * 12,
                  34,
                  character.buttonColorOrDefault(),
                  character.textColorOrDefault(),
                  playerDisplay,
                  () => {
                        if (character.classe == Classe.AVATAR &&
                            character.apotheose == Apotheose.NONE)
                          {
                            character.apotheose = Apotheose.ARCANIQUE,
                            characterSheetViewModel
                                .createOrUpdateCharacter(character)
                          }
                        else if (character.classe == Classe.SPIRITE &&
                            character.apotheose == Apotheose.NONE)
                          {
                            character.apotheose = Apotheose.FORME_VENGERESSE,
                            characterSheetViewModel
                                .createOrUpdateCharacter(character)
                          }
                        /*else if (character.classe == Classe.PACIFICATEUR &&
                            character.apotheose == Apotheose.NONE)
                          {
                            character.apotheose = Apotheose.SURCHARGE,
                            characterSheetViewModel
                                .createOrUpdateCharacter(character)
                          }*/
                        else if (character.niveau < 10 &&
                            character.apotheose == Apotheose.NONE)
                          {
                            character.apotheose = Apotheose.NORMALE,
                            characterSheetViewModel
                                .createOrUpdateCharacter(character)
                          }
                        else
                          {
                            showApotheoseAlertDialog(
                                context, characterSheetViewModel, character)
                          }
                      },
                  () => {}),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildCharacterSheetButton(
                  '',
                  playerDisplay ? "Proficiency" : "Pr",
                  (sizeRatio * width) / 6.5,
                  sizeRatioFont * 14,
                  34,
                  characterSheetState.uiState.proficiency
                      ? Colors.blueGrey
                      : character.buttonColorOrDefault(),
                  characterSheetState.uiState.proficiency
                      ? Colors.white
                      : character.textColorOrDefault(),
                  playerDisplay, () {
                changeUiSelect(characterSheetViewModel,
                    characterSheetState.uiState, 'Proficiency');
              }, () => {}),
              buildCharacterSheetButton(
                  '',
                  (characterSheetState.uiState.characterToHelp == null)
                      ? "Aider"
                      : "Aider ${characterSheetState.uiState.characterToHelp}",
                  (sizeRatio * width) / 6.5,
                  sizeRatioFont * 14,
                  34,
                  characterSheetState.uiState.help
                      ? Colors.blueGrey
                      : character.buttonColorOrDefault(),
                  characterSheetState.uiState.help
                      ? Colors.white
                      : character.textColorOrDefault(),
                  playerDisplay, () {
                if (characterSheetState.uiState.characterToHelp == null) {
                  showHelpingRollAlertDialog(context, characterSheetViewModel,
                      alliesName ?? [], characterSheetState.uiState);
                } else {
                  characterSheetState.uiState.characterToHelp = null;
                  characterSheetViewModel.updateUi(characterSheetState.uiState);
                }
              }, () => {}),
              buildCharacterSheetButton(
                  '',
                  "Secret",
                  (sizeRatio * width) / 6.5,
                  sizeRatioFont * 14,
                  34,
                  characterSheetState.uiState.secret
                      ? Colors.blueGrey
                      : character.buttonColorOrDefault(),
                  characterSheetState.uiState.secret
                      ? Colors.white
                      : character.textColorOrDefault(),
                  playerDisplay, () {
                changeUiSelect(characterSheetViewModel,
                    characterSheetState.uiState, 'Secret');
              }, () => {}),
              buildCharacterSheetButton(
                  '',
                  (playerDisplay ? "Relance" : "Rel") +
                      " : " +
                      character.relance.toString(),
                  (sizeRatio * width) / 6.5,
                  sizeRatioFont * 12,
                  34,
                  character.buttonColorOrDefault(),
                  character.textColorOrDefault(),
                  playerDisplay,
                  () => sendRoll(characterSheetViewModel, RollType.RELANCE, ''),
                  () => showEditStatAlertDialog(
                      context, characterSheetViewModel, character, "Relance")),
              buildCharacterSheetButton(
                '',
                "Repos",
                (sizeRatio * width) / 6.5,
                sizeRatioFont * 12,
                34,
                character.buttonColorOrDefault(),
                character.textColorOrDefault(),
                playerDisplay,
                () => showRestAlertDialog(
                    context, characterSheetViewModel, character),
                () => {},
              )
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
          rolls.add(getRollWidget(context, roll, characterSheetViewModel,
              mjViewModel, resistingCharacters, null));
          for (Roll resistRoll in roll.resistRollList) {
            rolls.add(getRollWidget(
                context,
                resistRoll,
                characterSheetViewModel,
                mjViewModel,
                resistingCharacters,
                roll));
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
      Color color,
      Color colorText,
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
                          style: TextStyle(
                              fontSize: fontSize / 2, color: colorText),
                          textAlign: TextAlign.center,
                        ),
                      if (value != '')
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: colorText,
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
      uiState.benediction = max(uiState.benediction + diff, 0);
    } else if (carac == 'Malus') {
      uiState.malediction = max(uiState.malediction + diff, 0);
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
    resistingRoll != null
        ? rollText.add(TextSpan(
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

    if (roll.rollType == RollType.CHAIR ||
        roll.rollType == RollType.ESPRIT ||
        roll.rollType == RollType.ESSENCE ||
        roll.rollType == RollType.SOIN ||
        roll.rollType == RollType.MAGIE_FORTE ||
        roll.rollType == RollType.MAGIE_LEGERE)
      switch (roll.apotheose) {
        case null:
        case Apotheose.NONE:
          break;
        case Apotheose.NORMALE:
          rollText.add(TextSpan(
            text: ' en Apothéose',
          ));
          break;
        case Apotheose.IMPROVED:
          rollText.add(TextSpan(
            text: ' en Apothéose Améliorée',
          ));
          break;
        case Apotheose.SURCHARGE_IMPROVED:
          rollText.add(TextSpan(
            text: ' en Surcharge Améliorée',
          ));
          break;
        case Apotheose.FINALE:
          rollText.add(TextSpan(
            text: ' en Apothéose Finale',
          ));
          break;
        case Apotheose.ARCANIQUE:
          rollText.add(TextSpan(
            text: ' en Apothéose Arcanique',
          ));
          break;
        case Apotheose.FORME_VENGERESSE:
          rollText.add(TextSpan(
            text: ' en Forme Vengeresse',
          ));
          break;
        case Apotheose.SURCHARGE:
          rollText.add(TextSpan(
            text: ' en Surcharge',
          ));
          break;
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
      case RollType.ARCANE_ESPRIT:
      case RollType.ARCANE_ESSENCE:
        rollText.add(TextSpan(
          text: ' et obtient ',
        ));
        rollText.add(TextSpan(
          text: '${roll.success}',
        ));
        rollText.add(TextSpan(
          text: ' succès',
        ));
        break;
      case RollType.SOIN:
        rollText.add(TextSpan(
          text: ' et peut donner ${roll.success} PV',
        ));
        break;
      case RollType.SAUVEGARDE_VS_MORT:
        if (roll.result[0] >= 10)
          rollText.add(TextSpan(
            text: ' et réussit.',
          ));
        else
          rollText.add(TextSpan(
            text: ' et échoue.',
          ));
        break;
      case RollType.EMPIRIQUE:
        rollText.add(TextSpan(
          text: ' (${roll.empirique}).',
        ));
        break;
      case RollType.ARCANE_FIXE:
      case RollType.RELANCE:
        break;
      case RollType.APOTHEOSE:
        if (roll.result[0] == 1) {
          rollText.add(TextSpan(
            text: ' et perd le contrôle !',
          ));
        } else {
          rollText.add(TextSpan(
            text: ' et garde le contrôle',
          ));
        }
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
              ..onTap = () => sendResistingRoll(
                  context,
                  RollType.CHAIR,
                  roll.id,
                  characterSheetViewModel,
                  mjViewModel,
                  resistingCharacters)),
      );
      rollText.add(TextSpan(text: ' / '));
      rollText.add(
        TextSpan(
            text: " R-Esprit",
            style: TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () => sendResistingRoll(
                  context,
                  RollType.ESPRIT,
                  roll.id,
                  characterSheetViewModel,
                  mjViewModel,
                  resistingCharacters)),
      );
      rollText.add(TextSpan(text: ' / '));
      rollText.add(
        TextSpan(
            text: " R-Essence",
            style: TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () => sendResistingRoll(
                  context,
                  RollType.ESSENCE,
                  roll.id,
                  characterSheetViewModel,
                  mjViewModel,
                  resistingCharacters)),
      );
      rollText.add(TextSpan(text: ')'));
    }
    if (resistingRoll != null) {
      rollText.add(TextSpan(text: ' ('));
      rollText.add(TextSpan(
        text: " Subir : ${roll.getDegats(resistingRoll)}",
        style: TextStyle(color: Colors.blue),
        recognizer: TapGestureRecognizer()
          ..onTap = () => subir(roll.rollerName, characterSheetViewModel,
              mjViewModel, roll.getDegats(resistingRoll)),
      ));
      rollText.add(TextSpan(text: ')'));
    }
    if (roll.displayDices || mjViewModel != null)
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
                  text: value.toString() + '',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 26,
                      fontFamily: 'DiceFont')));
            } else if (value == 5) {
              rollDices.add(TextSpan(
                  text: value.toString() + '',
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 26,
                      fontFamily: 'DiceFont')));
            } else if (value == 6) {
              rollDices.add(TextSpan(
                  text: value.toString() + '',
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 26,
                      fontFamily: 'DiceFont')));
            }
          }
          break;
        case RollType.EMPIRIQUE:
          // TODO si c'est d6, mettre le style visuel ?
          for (var value in roll.result) {
            rollDices.add(TextSpan(text: '[$value]'));
          }
          break;
        case RollType.APOTHEOSE:
          if (roll.result[0] == 1) {
            rollDices.add(TextSpan(
                text: roll.result[0].toString(),
                style: TextStyle(
                    color: Colors.red, fontSize: 26, fontFamily: 'DiceFont')));
          } else {
            rollDices.add(TextSpan(
                text: roll.result[0].toString(),
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 26,
                    fontFamily: 'DiceFont')));
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
          top: BorderSide(
              width: 1.0,
              color: resistingRoll == null ? Colors.grey : Colors.white),
        )),
        child: Padding(
            padding: resistingRoll != null
                ? EdgeInsets.fromLTRB(60, 5, 0, 5)
                : EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                      width: 1.0,
                      color:
                          resistingRoll != null ? Colors.white : Colors.white),
                )),
                child: Row(children: <Widget>[
//          if (resistingRoll != null)
                  Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        foregroundImage: NetworkImage(roll.picture ?? ''),
                      )),
                  Flexible(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(children: [
                                  Tooltip(
                                    message: (roll.juge12 != null &&
                                            roll.juge34 != null)
                                        ? "Juge12=${roll.juge12}, Juge34=${roll.juge34}"
                                        : "",
                                    child: RichText(
                                        text: TextSpan(
                                            text: roll.dateText() + ' - ',
                                            // 10:19:22 -
                                            children: rollText)),
                                  ),
                                ]),
                                Text.rich(
                                  TextSpan(
                                      // 10:19:22 -
                                      children: rollDices),
                                  textAlign: TextAlign.center,
                                ),
                              ]))),
                  if (mjViewModel != null)
                    IconButton(
                        onPressed: () => {mjViewModel.deleteRoll(roll.id)},
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ))
                ]))));
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
      List<String> alliesName,
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
                          items: alliesName
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

  static Future<void Function()> showRestAlertDialog(
      BuildContext context,
      CharacterSheetViewModel characterSheetViewModel,
      Character character) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    int restPoints = 3;
    int pv = character.pv;
    int pf = character.pf;
    int pp = character.pp;
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: restPoints > 1
                  ? Text("Repos : ${restPoints} pierres restantes")
                  : Text("Repos : ${restPoints} pierre restante"),
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              if (pv < character.pvMax && restPoints > 0) {
                                pv = pv + 1;
                                restPoints = restPoints - 1;
                              }
                            });
                          },
                          child: Text("PV : ${pv} / ${character.pvMax}"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              if (pf < character.pfMax && restPoints > 0) {
                                pf = pf + 1;
                                restPoints = restPoints - 1;
                              }
                            });
                          },
                          child: Text("PF : ${pf} / ${character.pfMax}"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              if (pp < character.ppMax && restPoints > 0) {
                                pp = pp + 1;
                                restPoints = restPoints - 1;
                              }
                            });
                          },
                          child: Text("PP : ${pp} / ${character.ppMax}"),
                        ),
                      ),
                    ],
                  )),
              actions: <Widget>[
                InkWell(
                  child: Text('OK   '),
                  onTap: () {
                    character.pv = pv;
                    character.pf = pf;
                    character.pp = pp;
                    character.arcanes = character.arcanesMax;
                    characterSheetViewModel.createOrUpdateCharacter(character);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }

  static Future<void Function()> showApotheoseAlertDialog(
      BuildContext context,
      CharacterSheetViewModel characterSheetViewModel,
      Character character) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    Roll? roll = null;
    if (character.apotheose != Apotheose.NONE) {
      roll = await characterSheetViewModel.sendRoll(RollType.APOTHEOSE);
    }
    int penalityPoints = character.apotheose == Apotheose.ARCANIQUE ? 2 : 3;
    List<String> apotheoseImprovementList =
        character.niveau >= 20 ? ["Apothéose Finale"] : [];
    String? apotheoseImprovement = null;
    apotheoseImprovementList.addAll(character.apotheoseImprovementList ?? []);
    if (!apotheoseImprovementList.contains("Aucune")) {
      apotheoseImprovementList.add("Aucune");
    }
    apotheoseImprovementList.add("(Ajouter)");
    Apotheose apotheose = character.apotheose;
    final TextEditingController _textEditingController =
        TextEditingController(text: '');
    int pv = character.pv;
    int pf = character.pf;
    int pp = character.pp;
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Apotheose"),
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (character.apotheose == Apotheose.NONE)
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: DropdownButton<String>(
                            hint: Text('Choix de l\'Apothéose'),
                            value: apotheoseImprovement,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            onChanged: (String? newValue) {
                              setState(() {
                                if (newValue == "Aucune") {
                                if (character.classe == Classe.PACIFICATEUR)
                                apotheose = Apotheose.SURCHARGE;
                                else
                                apotheose = Apotheose.NORMALE;

                                } else if (newValue == "Apothéose Finale") {
                                  apotheose = Apotheose.FINALE;
                                } else {
                                  if (character.classe == Classe.PACIFICATEUR)
                                    apotheose = Apotheose.SURCHARGE_IMPROVED;
                                  else
                                    apotheose = Apotheose.IMPROVED;
                                }
                                apotheoseImprovement = newValue;
                              });
                            },
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            items: apotheoseImprovementList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      if (character.apotheose == Apotheose.NONE &&
                          apotheoseImprovement == "(Ajouter)")
                        TextFormField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                              hintText: "Amélioration de l\'Apothéose"),
                        ),
                      if (roll != null)
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: roll.result[0] != 1
                                ? Text("Pas de perte de contrôle.")
                                : Text("Perte de contrôle !")),
                      if (roll?.data != null)
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: Text(roll!.data!)),
                      if (roll != null)
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: Text("------------")),
                      if (character.apotheose != Apotheose.NONE)
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child:
                                Text("Pierres à perdre : ${penalityPoints}")),
                      if (character.apotheose != Apotheose.NONE)
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                if (pv > 0 && penalityPoints > 0) {
                                  pv = pv - 1;
                                  penalityPoints = penalityPoints - 1;
                                }
                              });
                            },
                            child: Text("PV : ${pv} / ${character.pvMax}"),
                          ),
                        ),
                      if (character.apotheose != Apotheose.NONE)
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                if (pf > 0 && penalityPoints > 0) {
                                  pf = pf - 1;
                                  penalityPoints = penalityPoints - 1;
                                }
                              });
                            },
                            child: Text("PF : ${pf} / ${character.pfMax}"),
                          ),
                        ),
                      if (character.apotheose != Apotheose.NONE)
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                if (pp > 0 && penalityPoints > 0) {
                                  pp = pp - 1;
                                  penalityPoints = penalityPoints - 1;
                                }
                              });
                            },
                            child: Text("PP : ${pp} / ${character.ppMax}"),
                          ),
                        ),
                    ],
                  )),
              actions: <Widget>[
                if (character.apotheose == Apotheose.NONE)
                  InkWell(
                    child: Text('Passer en Apothéose   '),
                    onTap: () {
                      character.apotheose = apotheose;
                      character.apotheoseImprovement =
                          apotheoseImprovement == "(Ajouter)"
                              ? _textEditingController.text
                              : apotheoseImprovement;
                      characterSheetViewModel
                          .createOrUpdateCharacter(character);
                      Navigator.of(context).pop();
                    },
                  ),
                if (character.apotheose != Apotheose.NONE)
                  InkWell(
                    child: Text('Continuer   '),
                    onTap: () {
                      character.pv = pv;
                      character.pf = pf;
                      character.pp = pp;
                      characterSheetViewModel
                          .createOrUpdateCharacter(character);
                      Navigator.of(context).pop();
                    },
                  ),
                if (character.apotheose != Apotheose.NONE)
                  InkWell(
                    child: Text('S\'arrêter   '),
                    onTap: () {
                      character.apotheose = Apotheose.NONE;
                      characterSheetViewModel
                          .createOrUpdateCharacter(character);
                      Navigator.of(context).pop();
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
      showSelectResistDialog(
          context, mjViewModel, resistingCharacters, id, rollType);
    }
  }

  static Future<void Function()> showSelectResistDialog(
      BuildContext context,
      MjViewModel mjViewModel,
      List<String> characterNames,
      String id,
      RollType rollType) async {
    Map<String, bool> characterList = {};

    for (var i = 0; i < characterNames.length; i++) {
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
                        print("SENDOU ${characterList}");
                        for (String key in characterList.keys) {
                          if (characterList[key]!) {
                            print("SENDOU ${characterList[key]}");
                            sendRoll(mjViewModel.getCharacterViewModel(key),
                                rollType, '', id);
                          }
                        }
                        Navigator.of(context).pop();
                      })
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

  static subir(String name, CharacterSheetViewModel? characterSheetViewModel,
      MjViewModel? mjViewModel, int degats) {
    if (characterSheetViewModel != null) {
      characterSheetViewModel.subir(degats);
    } else if (mjViewModel != null) {
      mjViewModel.subir(name, degats);
    }
  }
}
