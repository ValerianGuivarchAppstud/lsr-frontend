import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/Settings.dart';
import '../character/CharacterSheetViewModel.dart';
import 'SettingsViewModel.dart';

class SettingsWidgets {
  static Padding buildCharacterSelection(
      Settings settings,
      SettingsViewModel? settingsViewModel,
      CharacterSheetViewModel? characterViewModel,
      void Function(VoidCallback fn) setState) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              if (settingsViewModel != null) {
                settingsViewModel.selectPlayerName(newValue);
              } else if (characterViewModel != null) {
                characterViewModel.selectPlayerName(newValue);
              }
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
              if (settingsViewModel != null) {
                settingsViewModel.selectCharacterName(newValue);
              } else if (characterViewModel != null) {
                characterViewModel.selectCharacterName(newValue);
              }
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
        ]));
  }
}
