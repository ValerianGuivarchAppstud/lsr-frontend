import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lsr/domain/models/Category.dart';
import 'package:lsr/domain/models/MjSheet.dart';
import 'package:lsr/domain/models/Round.dart';
import 'package:lsr/view/modules/character/CharacterWidgets.dart';
import 'package:lsr/view/modules/mj/MjWidgets.dart';

import '../../../utils/view/Const.dart';
import '../../widgets/common/LoadingWidget.dart';
import 'MjState.dart';
import 'MjViewModel.dart';

class MjPage extends StatefulWidget {
  MjViewModel mjViewModel;

  MjPage(this.mjViewModel, {required Key key}) : super(key: key) {
    print("onst");
  }

  @override
  _MjPageState createState() => _MjPageState(this.mjViewModel);
}

class _MjPageState extends State<MjPage> {
  MjViewModel mjViewModel;

  _MjPageState(this.mjViewModel);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    mjViewModel.getMj();
    return StreamBuilder<MjState>(
        stream: mjViewModel.streamController.stream,
        initialData: mjViewModel.getState(),
        builder: (context, state) {
          if (state.data?.showLoading ?? true) {
            const oneSec = Duration(seconds: 1);
            Timer.periodic(oneSec, (Timer t) => mjViewModel.getMj());
          }
          return Container(
              height: height,
              width: width,
              color: Colors.white,
              child: LayoutBuilder(builder: (context, constraints) {
                if (state.data?.uiState.errorMessage != null) {
                  print(state.data!.uiState.errorMessage!);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    SnackBar snackBar = SnackBar(
                      content: Text(state.data!.uiState.errorMessage!),
                    );
                    mjViewModel.getState().uiState.errorMessage = null;
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                }

                if (state.data == null || (state.data!.showLoading)) {
                  return LoadingWidget(
                      key: Key(
                    "LoadingWidget",
                  ));
                } else if (state.data?.mjSheet == null) {
                  return Center(
                    child: Text(state.error?.toString() ?? "erreur"),
                  );
                } else {
                  var width = MediaQuery.of(context)
                      .size
                      .width; /* <
                              WIDTH_SCREEN * RATIO_SCREEN
                          ? MediaQuery.of(context).size.width
                          : WIDTH_SCREEN * RATIO_SCREEN;*/

                  return _buildMj(state.data!.mjSheet!, state.data!.uiState,
                      mjViewModel, width, state.data!.uiState.camera);
                }
              }));
        });
  }

  _buildMj(MjSheet mjSheet, MjUIState uiState, MjViewModel mjViewModel,
          double width, bool camera) =>
      Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: camera ? width * 3 / 9 : width * 6 / 9,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: [
                      Row(children: [
                        Text(
                          'PJ ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        DropdownButton<String>(
                          hint: Text('Ajout PJ'),
                          value: null,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              mjViewModel.addCharacterList(newValue);
                            }
                            setState(() {});
                          },
                          items: mjSheet.pjNames
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        TextButton(
                            onPressed: () => {mjViewModel.deleteRolls()},
                            child: Text("Supprimer les lancers")),
                        if (mjSheet.round == Round.NONE)
                          TextButton(
                              onPressed: () => {mjViewModel.nextRound()},
                              child: Text("Start combat")),
                        if (mjSheet.round == Round.PJ)
                          TextButton(
                              onPressed: () => {mjViewModel.nextRound()},
                              child: Text("Tour des PNJ")),
                        if (mjSheet.round == Round.PNJ)
                          TextButton(
                              onPressed: () => {mjViewModel.nextRound()},
                              child: Text("Tour des PJ")),
                        if (mjSheet.round != Round.NONE)
                          TextButton(
                              onPressed: () => {mjViewModel.stopBattle()},
                              child: Text("Stop combat"))
                      ]),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Wrap(
                              children: mjSheet.characters
                                  .where((character) =>
                                      character.category == Category.PJ)
                                  .map((character) {
                            return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                width: width * RATIO_BUTTON,
                                child: CharacterWidgets.buildCharacter(
                                    context,
                                    false,
                                    mjSheet.round == Round.NONE ?
                                        null :
                                         mjSheet.charactersBattleAllies
                                        .contains(character.name),
                                    mjSheet.round != Round.PNJ,
                                    character,
                                    width,
                                    RATIO_BUTTON,
                                    RATIO_FONT,
                                    mjViewModel
                                        .getCharacterViewModel(character.name),
                                    mjViewModel
                                        .getCharacterStateData(character.name),
                                    null,
                                    null,
                                    null,
                                    mjViewModel,
                                0));
                          }).toList())),
                      Row(children: [
                        Text(
                          'PNJ ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Row(children: [
                          DropdownButton<String>(
                            hint: Text('Ajout PNJ'),
                            value: null,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                mjViewModel.addCharacterList(newValue);
                              }
                              setState(() {});
                            },
                            items: mjSheet.pnjNames
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          DropdownButton<String>(
                            hint: Text('Ajout tempo'),
                            value: null,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                mjViewModel.addCharacterList(newValue);
                              }
                              setState(() {});
                            },
                            items: mjSheet.tempoNames
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          DropdownButton<String>(
                            hint: Text('Ajout template'),
                            value: null,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                MjWidgets
                                    .buildCreateCharacterWithTemplateAlertDialog(
                                        context,
                                        newValue,
                                        mjViewModel.addCharacterWithTemplate);
                              }
                              setState(() {});
                            },
                            items: mjSheet.templateNames
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey)),
                            child: Text("Ajouter"),
                            onPressed: () => {
                              MjWidgets.buildCreateCharacterAlertDialog(
                                  null,
                                  context,
                                  mjSheet.playersName,
                                  mjViewModel.createNewCharacter)
                            },
                          )
                        ]),
                      ]),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Wrap(
                              children: mjSheet.characters
                                  .where((character) =>
                                      character.category != Category.PJ)
                                  .map((character) {
                            return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                width: width * RATIO_BUTTON,
                                child: CharacterWidgets.buildCharacter(
                                    context,
                                    false,
                                    mjSheet.round == Round.NONE ?
                                    null :
                                    mjSheet.charactersBattleEnnemies
                                            .contains(character.name),
                                    mjSheet.round != Round.PJ,
                                    character,
                                    width,
                                    RATIO_BUTTON,
                                    RATIO_FONT,
                                    mjViewModel
                                        .getCharacterViewModel(character.name),
                                    mjViewModel
                                        .getCharacterStateData(character.name),
                                    null,
                                    null,
                                    null,
                                    mjViewModel,
                                    0));
                          }).toList())),
                    ]))),
            SizedBox(
                width: camera ? width * 3 / 9 : width * 3 / 9,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CharacterWidgets.buildRollList(
                              mjSheet.rollList,
                              null,
                              null,
                              mjViewModel,
                              mjViewModel
                                  .getState()
                                  .mjSheet
                                  ?.characters
                                  .where((c) => c.category != Category.PJ)
                                  .map((e) => e.name)
                                  .toList())
                        ])))
          ]);
}
