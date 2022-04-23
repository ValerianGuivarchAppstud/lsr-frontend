import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    var size = MediaQuery
        .of(context)
        .size;
    CharacterSheetViewModel characterSheetViewModel =
        Injector
            .of(context)
            .characterSheetViewModel;
    return StreamBuilder<CharacterSheetState>(
        stream: characterSheetViewModel.streamController.stream,
        initialData: CharacterSheetState.loading(),
        builder: (context, state) {
          if (state.data?.showLoading ?? true) {
            Injector
                .of(context)
                .characterSheetViewModel
                .getCharacterSheet("Viktor");
          }
          return Scaffold(
              body: Container(
                  height: size.height,
                  width: size.width,
                  color: Colors.white,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: LayoutBuilder(builder: (context, constraints) {
                        if (state.data == null ||
                            (state.data!.showLoading ?? true)) {
                          return LoadingWidget(
                              key: Key(
                                "LoadingWidget",
                              ));
                        } else if (state.data?.character == null) {
                          return Center(
                            child: Text("Aucun personnage..."),
                          );
                        } else {
                          return _buildCharacter(state.data!.character!,
                              size.width, characterSheetViewModel, state.data!);
                        }
                      }))));
        });
  }

  _buildCharacter(Character character,
      double sizeWidth,
      CharacterSheetViewModel characterSheetViewModel,
      CharacterSheetState characterSheetState) =>
      Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 62),
                    child: Image.asset(
                      "assets/images/background/${describeEnum(
                          character.bloodline).toLowerCase()}.jpg",
                      fit: BoxFit.fill,
                      height: 100,
                      width: sizeWidth,
                    )),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 62,
                      backgroundColor: Colors.white,
                    ),
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      foregroundImage: AssetImage(
                          "assets/images/portraits/${character.name}.png"),
                    )
                  ],
                )
              ],
            ),
            Text(
              character.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              character.description(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.all(8),
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
                CharacterSheetButton("Chair", character.chair.toString(), sizeWidth / 4.3, 26, Colors.blue, () => sendRoll(character, characterSheetViewModel, RollType.CHAIR, characterSheetState), () => showEditStatAlertDialog(characterSheetViewModel, character, "Chair")),
                CharacterSheetButton("Esprit", character.esprit.toString(), sizeWidth / 4.3, 26, Colors.blue, () => sendRoll(character, characterSheetViewModel, RollType.ESPRIT, characterSheetState), () => {}),
                CharacterSheetButton("Essence", character.essence.toString(),   sizeWidth / 4.3, 26, Colors.blue, () => sendRoll(character, characterSheetViewModel, RollType.ESSENCE, characterSheetState), () => {}),
                CharacterSheetButton("Dettes", character.dettes.toString(), sizeWidth / 4.3, 26, Colors.blue, () => {}, () => {}),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CharacterSheetButton("Lux", character.lux.toString(),
                    sizeWidth / 4.3, 12, Colors.blue, () => {}, () => {}),
                CharacterSheetButton("Umbra", character.umbra.toString(),
                    sizeWidth / 4.3, 12, Colors.blue, () => {}, () => {}),
                CharacterSheetButton("Secunda", character.secunda.toString(),
                    sizeWidth / 4.3, 12, Colors.blue, () => {}, () => {}),
                CharacterSheetButton("Proficiency", 'Vitesse/Agilité',
                    sizeWidth / 4.3, 10, Colors.blue, () => {}, () => {}),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CharacterSheetButton(
                    "PV",
                    character.pv.toString() + '/ ' + character.pvMax.toString(),
                    sizeWidth / 4.3,
                    26,
                    Colors.blue, () => {}, () => {}),
                CharacterSheetButton(
                    "PF",
                    character.pf.toString() + '/ ' + character.pfMax.toString(),
                    sizeWidth / 4.3,
                    26,
                    Colors.blue, () => {}, () => {}),
                CharacterSheetButton(
                    "PP",
                    character.pp.toString() + '/ ' + character.ppMax.toString(),
                    sizeWidth / 4.3,
                    26,
                    Colors.blue, () => {}, () => {}),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CharacterSheetButton(
                            "Malus", '1', sizeWidth / 3.5, 26, Colors.red, () => {}, () => {}),
                        Padding(
                            padding: EdgeInsets.only(right: sizeWidth /3),
                            child: IconButton(
                              iconSize: 40,
                              color: Colors.red,
                              icon: Icon(Icons.remove_circle),
                              onPressed: () {},
                            )),
                        Padding(
                            padding: EdgeInsets.only(left: sizeWidth / 3),
                            child: IconButton(
                              iconSize: 40,
                              color: Colors.red,
                              icon: Icon(Icons.add_circle),
                              onPressed: () {},
                            ))
                      ],
                    )
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CharacterSheetButton("Bonus", '0', sizeWidth / 3.5, 26,
                            Colors.green, () => {}, () => {}),
                        Padding(
                            padding: EdgeInsets.only(right: sizeWidth / 3),
                            child: IconButton(
                              iconSize: 40,
                              color: Colors.green,
                              icon: Icon(Icons.remove_circle),
                              onPressed: () {},
                            )),
                        Padding(
                            padding: EdgeInsets.only(left: sizeWidth / 3),
                            child: IconButton(
                              iconSize: 40,
                              color: Colors.green,
                              icon: Icon(Icons.add_circle),
                              onPressed: () {},
                            ))
                      ],
                    )
                  ],
                ),
              ],
            ),
            LayoutBuilder(builder: (context, constraints) {
              const T1 = Text("t1");
              const T2 = Text("t2");
              List<Widget> rolls = [];
              for (Roll roll in (characterSheetState.rollList ?? [])) {
                rolls.add(RollWidget(roll));
              }
              return Column(
                children: rolls,
              );
            }),
          ]);

  void sendRoll(Character character,
      CharacterSheetViewModel characterSheetViewModel,
      RollType rollType,
      CharacterSheetState characterSheetState) {
    characterSheetViewModel.sendRoll(
        character: character,
        rollType: rollType,
        secret: characterSheetState.secret ?? false,
        focus: characterSheetState.focus ?? false,
        power: characterSheetState.power ?? false,
        proficiency: characterSheetState.proficiency ?? false,
        benediction: characterSheetState.benediction ?? 0,
        malediction: characterSheetState.malediction ?? 0);
  }

  CharacterSheetButton(String title, String value, double width,
      double fontSize, MaterialColor color, void Function() onPressed, void Function() onLongPress) {
    return Padding(
        padding: EdgeInsets.all(2),
        child: SizedBox(
            height: 50,
            width: width, // <-- match_parent
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: color,
                  //     primary: Colors.white,
                  minimumSize: Size.zero, // Set this
                  padding: EdgeInsets.zero, // and this
                ),
                onPressed:onPressed,
                onLongPress:onLongPress,
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
                          fontWeight: FontWeight.bold,),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                ]))));
  }


  Widget RollWidget2(Roll roll) {
    List<TextSpan> rollText = [];
    rollText.add(TextSpan( // (secret)
        text: roll.secretText()
    ));
    if (roll.malediction > 0 && roll.benediction == 0) {
      rollText.add(TextSpan( // Avec 2 bénédictions et 1 malédiction,
          text: 'Avec ${roll.malediction} malédiction' +
              (roll.malediction > 0 ? 's' : '') + ', '));
    } else if (roll.malediction == 0 && roll.benediction > 0) {
      rollText.add(TextSpan( // Avec 2 bénédictions et 1 malédiction,
          text: 'Avec ${roll.benediction} benediction' +
              (roll.benediction > 0 ? 's' : '') + ', '));
    } if (roll.malediction > 0 && roll.benediction > 0) {
      rollText.add(TextSpan( // Avec 2 bénédictions et 1 malédiction,
          text: 'Avec ${roll.malediction} malédiction' +
              (roll.malediction > 0 ? 's' : '') +
              ' et ${roll.benediction} benediction' +
              (roll.benediction > 0 ? 's' : '') + ', '));
    }
    rollText.add(TextSpan( // Jonathan
        text: roll.rollerName,
        style: TextStyle(
            fontWeight: FontWeight.bold
        )
    ));
    if (roll.focus) {
      rollText.add(TextSpan( // se concentre et
        text: ' se ',
      ));
      rollText.add(TextSpan( // se concentre et
          text: 'concentre',
          style: TextStyle(
              fontStyle: FontStyle.italic
          ))
      );
      rollText.add(TextSpan(
        text: ' et',
      ));
    }

    rollText.add(TextSpan( // fait un
        text: ' fait un '
    ));
    rollText.add(TextSpan( // jet de Chair
        text: roll.rollTypeText(),
        style: TextStyle(
            fontStyle: FontStyle.italic
        )));

    if (roll.focus) {
      rollText.add(TextSpan( // se concentre et
        text: ' en y mettant toute sa ',
      ));
      rollText.add(TextSpan( // se concentre et
          text: 'puissance',
          style: TextStyle(
              fontStyle: FontStyle.italic
          ))
      );
    }
    if(roll.rollType == RollType.ARCANE_FIXE) {
      rollText.add(TextSpan(
        text: '.',
      ));
    } else {
      rollText.add(TextSpan(
        text: ' :\n',
      ));
    }
    switch(roll.rollType){
      case RollType.CHAIR:
      case RollType.ESPRIT:
      case RollType.ESSENCE:
      case RollType.MAGIE_LEGERE:
      case RollType.MAGIE_FORTE:
      case RollType.SOIN:
      case RollType.ARCANE_ESPRIT:
      case RollType.ARCANE_ESSENCE:
        for(var value in roll.result) {
          if(value <5) {
            rollText.add(TextSpan(
                text: Roll.diceValueToIcon(value)
            ));
          } else if (value == 5) {
            rollText.add(TextSpan(
                text: Roll.diceValueToIcon(value),
                style: TextStyle(
                    color: Colors.orange
                )
            ));
          } else if (value == 6) {
            rollText.add(TextSpan(
                text: Roll.diceValueToIcon(value),
                style: TextStyle(
                    color: Colors.red
                )
            ));
          }
        }
        break;
      case RollType.EMPIRIQUE:
        for(var value in roll.result) {
          rollText.add(TextSpan(
              text: '[$value]'
          ));
        }
        break;
      case RollType.ARCANE_FIXE:
        break;
      case RollType.SAUVEGARDE_VS_MORT:
        for(var value in roll.result) {
          if (value < 10) {
            rollText.add(TextSpan(
                text: '[$value]',
                style: TextStyle(
                    color: Colors.red
                )
            ));
          } else {
            rollText.add(TextSpan(
                text: '[$value]',
                style: TextStyle(
                    color: Colors.green
                )
            ));
          }
        }
        break;
    }
    rollText.add(TextSpan(
      text: '\n et obtient ${roll.success} succès',
    ));
    if(roll.proficiency) {
      rollText.add(TextSpan(
        text: ', grâce à son heritage latent',
      ));
    }
    rollText.add(TextSpan(
      text: '.',
    ));
    return Text.rich(
        TextSpan(
            text: roll.dateText() + ' - ', // 10:19:22 -
            children: rollText
        )
    );
  }
  Widget RollWidget(Roll roll) {
    List<TextSpan> rollText = [];
    rollText.add(TextSpan( // (secret)
        text: roll.secretText()
    ));
    rollText.add(TextSpan( // Jonathan
        text: roll.rollerName,
        style: TextStyle(
            fontWeight: FontWeight.bold
        )
    ));

    rollText.add(TextSpan( // fait un
        text: ' fait un '
    ));
    rollText.add(TextSpan( // jet de Chair
        text: roll.rollTypeText(),
        style: TextStyle(
            fontStyle: FontStyle.italic
        )));

    String textBonus = '';
    if(roll.malediction > 0) {
      textBonus+='${roll.malediction}m,';
    }
    if(roll.benediction > 0) {
      textBonus+='${roll.benediction}b,';
    }
    if(roll.focus) {
      textBonus+='pf,';
    }
    if(roll.power) {
      textBonus+='pp,';
    }
    if(roll.proficiency) {
      textBonus+='h,';
    }
    if(textBonus.isNotEmpty){
      textBonus=textBonus.substring(0, textBonus.length-3);
      rollText.add(TextSpan(
        text: ' ('+textBonus+')',
      ));
    }
    if(roll.success!=null) {
      rollText.add(TextSpan(
        text: ' et obtient ${roll.success} succès',
      ));
    }
    if(roll.rollType == RollType.ARCANE_FIXE) {
      rollText.add(TextSpan(
        text: '.',
      ));
    } else {
      rollText.add(TextSpan(
        text: ' :\n',
      ));
    }
    switch(roll.rollType){
      case RollType.CHAIR:
      case RollType.ESPRIT:
      case RollType.ESSENCE:
      case RollType.MAGIE_LEGERE:
      case RollType.MAGIE_FORTE:
      case RollType.SOIN:
      case RollType.ARCANE_ESPRIT:
      case RollType.ARCANE_ESSENCE:
        for(var value in roll.result) {
          if(value <5) {
            rollText.add(TextSpan(
                text: Roll.diceValueToIcon(value)
            ));
          } else if (value == 5) {
            rollText.add(TextSpan(
                text: Roll.diceValueToIcon(value),
                style: TextStyle(
                    color: Colors.orange
                )
            ));
          } else if (value == 6) {
            rollText.add(TextSpan(
                text: Roll.diceValueToIcon(value),
                style: TextStyle(
                    color: Colors.red
                )
            ));
          }
        }
        break;
      case RollType.EMPIRIQUE:
        for(var value in roll.result) {
            rollText.add(TextSpan(
                text: '[$value]'
            ));
        }
        break;
      case RollType.ARCANE_FIXE:
        break;
      case RollType.SAUVEGARDE_VS_MORT:
        for(var value in roll.result) {
          if (value < 10) {
            rollText.add(TextSpan(
                text: '[$value]',
                style: TextStyle(
                    color: Colors.red
                )
            ));
          } else {
            rollText.add(TextSpan(
                text: '[$value]',
                style: TextStyle(
                    color: Colors.green
                )
            ));
          }
        }
        break;
    }
      return Text.rich(
          TextSpan(
              text: roll.dateText() + ' - ', // 10:19:22 -
              children: rollText
          )
      );
    }

  Future<void Function()> showEditStatAlertDialog(CharacterSheetViewModel characterSheetViewModel, Character character, String statToEdit) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    late String initialValue;
    if(statToEdit == 'Chair') {
      initialValue = character.chair.toString();
    } else if(statToEdit == 'Esprit') {
      initialValue = character.esprit.toString();
    } else {//if(statToEdit == 'Essence') {
      initialValue = character.essence.toString();
    }
    final TextEditingController _textEditingController = TextEditingController(text: initialValue);
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
                          return value != null ?((value.isNotEmpty && double.tryParse(value) != null)? null : "Enter any text") : null;
                        },
                        decoration:
                        InputDecoration(hintText: "Nouvelle valeur"),
                      ),
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Choice Box"),
                          Checkbox(
                              value: isChecked,
                              onChanged: (checked) {
                                setState(() {
                                  isChecked = checked ?? false;
                                });
                              })
                        ],
                      )*/
                    ],
                  )),
              actions: <Widget>[
                InkWell(
                  child: Text('OK   '),
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if(statToEdit == 'Chair') {
                        character.chair = int.tryParse(_textEditingController.value.text) ??character.chair;
                      } else if(statToEdit == 'Esprit') {
                        character.esprit = int.tryParse(_textEditingController.value.text) ??character.esprit;
                      } else if(statToEdit == 'Essence') {
                        character.essence = int.tryParse(_textEditingController.value.text) ??character.essence;
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
  }

/*
class CharacterPage extends Page {

  CharacterPage() : super();

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) =>
          CharacterScreen(
          ),
    );
  }
}



class CharacterScreen extends StatefulWidget {

  const CharacterScreen() : super();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var size = MediaQuery
        .of(context)
        .size;
    return Consumer(builder: (context, watch, child) {
      final _futureAsyncValue = watch(characterStateProvider);
      Character? currentCharacter = _futureAsyncValue.when(
          data: (data) => data,
          loading: () => null,
          error: (e, st) => null
      );
      return Scaffold(
      body: Container(
      height: size.height,
      width: size.width,
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 62),
                      child: Image.asset(
                        "images/vent.jpg",
                        fit: BoxFit.cover,
                        height: 100,
                        width: size.width,
                      )),
                  Stack(
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
                        AssetImage("images/portraits/Viktor.png"),
                      )
                    ],
                  )
                ],
              ),
              Text(
                currentCharacter?.name ??" loading",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Champion du Vent, niveau 16",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatRow(
                          statName: "Chair",
                          statValue: 3.toString()
                      ),
                      StatRow(
                          statName: "Esprit",
                          statValue: 5.toString()
                      ),
                      StatRow(
                          statName: "Essence",
                          statValue: 7.toString()
                      ),
                    ],
                  ), Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatRow(
                          statName: "Lux",
                          statValue: "Voyageur"
                      ),
                      StatRow(
                          statName: "Umbra",
                          statValue: "Pipelette"
                      ),
                      StatRow(
                          statName: "Secunda",
                          statValue: "Arbolesque"
                      ),
                    ],
                  ),
                ],
              ),
            ]
        )
        ,
      )
      ,
    ),);
  }

  );
}

CircleAvatar profilePicture({required double radius}) {
  return CircleAvatar(
    radius: radius,
    backgroundColor: Colors.blue,
    foregroundImage: NetworkImage(
        "https://images.pexels.com/photos/1756086/pexels-photo-1756086.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"),
  );
}

Text simpleText(String text) {
  return Text(
    text,
    style: TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    ),
    textAlign: TextAlign.center,
  );
}

Image fromAsset({required double height, required double width}) {
  return Image.asset(
    "images/beach.jpg",
    fit: BoxFit.cover,
    height: height,
    width: width,
  );
}

Image fromNetwork() {
  return Image.network(
    "https://images.pexels.com/photos/1756086/pexels-photo-1756086.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    height: 200,
  );
}

Text spanDemo() {
  return Text.rich(
      TextSpan(text: "Salut", style: TextStyle(color: Colors.red), children: [
        TextSpan(
            text: "second style",
            style: TextStyle(fontSize: 30, color: Colors.grey)),
        TextSpan(
            text: "A l'infini",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue))
      ]));
}}
*/
