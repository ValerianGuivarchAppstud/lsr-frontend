import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsr/view/modules/character/CharacterWidgets.dart';

import '../../../domain/models/Character.dart';
import '../../../utils/view/Const.dart';
import 'HealSheetState.dart';
import 'HealSheetViewModel.dart';

class HealWidgets {
  static buildHeal(
          BuildContext context,
          Character character,
          double sizeRatio,
          double sizeRatioFont,
          HealSheetViewModel healSheetViewModel,
          HealSheetState healSheetState,
          List<Character>? pjAllies,
          LayoutBuilder? rollList) =>
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            CharacterWidgets.buildCharacterSheetButton(
              "Soin",
              healSheetState.uiState.heal.toString() +
                  ' / ' +
                  healSheetState.uiState.healMax.toString(),
              (sizeRatio * WIDTH_SCREEN) / 5,
              sizeRatioFont * 26,
              50,
              Colors.blue,
              Colors.white,
              true,
              () => healSheetViewModel.sendHealRoll(),
              () => showHealStatAlertDialog(
                  context, healSheetViewModel, healSheetState, character),
            ),
            CharacterWidgets.buildCharacterSheetButton(
                "PF",
                character.pf.toString() + ' / ' + character.pfMax.toString(),
                (sizeRatio * WIDTH_SCREEN) / 5,
                sizeRatioFont * 26,
                50,
                healSheetState.uiState.focus ? Colors.blueGrey : Colors.blue,
                Colors.white,
                true, () {
              changeUiSelect(healSheetViewModel, healSheetState.uiState, 'PF');
            }, () => {}),
            CharacterWidgets.buildCharacterSheetButton(
                "PP",
                character.pp.toString() + ' / ' + character.ppMax.toString(),
                (sizeRatio * WIDTH_SCREEN) / 5,
                sizeRatioFont * 26,
                50,
                healSheetState.uiState.power ? Colors.blueGrey : Colors.blue,
                Colors.white,
                true, () {
              changeUiSelect(healSheetViewModel, healSheetState.uiState, 'PP');
            }, () => {}),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [],
          ),
          if (rollList != null) rollList
//            if(rollList != null) buildRollList(rollList, character.name, resistRoll, [character.name])
        ],
      );

  static Future<void Function()> showHealStatAlertDialog(
      BuildContext context,
      HealSheetViewModel healSheetViewModel,
      HealSheetState healSheetState,
      Character character) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String initialValue = healSheetState.uiState.heal.toString();
    final TextEditingController _textEditingController =
        TextEditingController(text: initialValue);
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Soins disponibles"),
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
                      healSheetState.uiState.heal =
                          int.tryParse(_textEditingController.value.text) ??
                              healSheetState.uiState.heal;
                      healSheetViewModel.updateUi(healSheetState.uiState);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  static void changeUiSelect(HealSheetViewModel healSheetViewModel,
      HealSheetUIState uiState, String carac) {
    if (carac == 'PF') {
      uiState.focus = !uiState.focus;
    } else if (carac == 'PP') {
      uiState.power = !uiState.power;
    }
    healSheetViewModel.updateUi(uiState);
  }
}
