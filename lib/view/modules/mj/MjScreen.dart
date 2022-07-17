import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lsr/domain/models/Category.dart';
import 'package:lsr/domain/models/MjSheet.dart';
import 'package:lsr/view/modules/character/CharacterWidgets.dart';
import 'package:lsr/view/modules/mj/MjWidgets.dart';

import '../../../utils/Injector.dart';
import '../../../utils/view/Const.dart';
import '../../widgets/common/LoadingWidget.dart';
import 'MjState.dart';
import 'MjViewModel.dart';

class MjPage extends StatefulWidget {
  bool camera;

  MjPage(this.camera, {required Key key}) : super(key: key);

  @override
  _MjPageState createState() => _MjPageState(this.camera);
}

class _MjPageState extends State<MjPage> {
  bool camera;

  _MjPageState(this.camera);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    MjViewModel mjViewModel = Injector.of(context).mjViewModel;
    Injector.of(context).mjViewModel.getMj();
    return StreamBuilder<MjState>(
        stream: mjViewModel.streamController.stream,
        initialData: mjViewModel.getState(),
        builder: (context, state) {
          if (state.data?.showLoading ?? true) {
            const oneSec = Duration(seconds: 1);
            Timer.periodic(
                oneSec, (Timer t) => Injector.of(context).mjViewModel.getMj());
          }
          return Container(
              height: height,
              width: width,
              color: Colors.white,
              child:  LayoutBuilder(builder: (context, constraints) {
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
                      var width = MediaQuery.of(context).size.width <
                              WIDTH_SCREEN * RATIO_SCREEN
                          ? MediaQuery.of(context).size.width
                          : WIDTH_SCREEN * RATIO_SCREEN;
                      var widthScreen = MediaQuery.of(context).size.width;
                      return _buildMj(state.data!.mjSheet!, state.data!.uiState,
                          mjViewModel, camera ? (width / 2) : width, widthScreen);
                    }
                  }));
        });
  }

  _buildMj(MjSheet mjSheet, MjUIState uiState, MjViewModel mjViewModel,
          double width, double widthScreen) =>
      Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SizedBox(
            width: widthScreen * 2 / 3,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:Column(children: [
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
              ]),
              Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                      children: mjSheet.characters
                          .where(
                              (character) => character.category == Category.PJ)
                          .map((character) {
                    return Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        width: width,
                        child: CharacterWidgets.buildCharacter(
                            context,
                            false,
                            character,
                            RATIO_BUTTON,
                            RATIO_FONT,
                            mjViewModel.getCharacterViewModel(character.name),
                            mjViewModel.getCharacterStateData(character.name),
                            null,
                            null,
                            null,
                        mjViewModel));
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
                        MjWidgets.buildCreateCharacterWithTemplateAlertDialog(context, newValue,
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
                            MaterialStateProperty.all<Color>(Colors.grey)),
                    child: Text("Ajouter"),
                    onPressed: () => {
                      MjWidgets.buildCreateCharacterAlertDialog(null, context, mjSheet.playersName,
                          mjViewModel.createNewCharacter)
                    },
                  )
                ]),
              ]),
              Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                      children: mjSheet.characters
                          .where(
                              (character) => character.category != Category.PJ)
                          .map((character) {
                    return Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        width: width,
                        child: CharacterWidgets.buildCharacter(
                            context,
                            false,
                            character,
                            RATIO_BUTTON,
                            RATIO_FONT,
                            mjViewModel.getCharacterViewModel(character.name),
                            mjViewModel.getCharacterStateData(character.name),
                            null,
                            null,
                            null,
                            mjViewModel));
                  }).toList())),
            ]))),
        SizedBox(
            width: widthScreen * 0.9 / 3,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [CharacterWidgets.buildRollList(mjSheet.rollList, null, null, mjViewModel, mjViewModel.getState().mjSheet?.characters.map((e) => e.name).toList())])))
      ]);
}
