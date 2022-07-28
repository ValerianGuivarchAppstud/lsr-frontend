import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lsr/domain/models/Apotheose.dart';
import 'package:lsr/domain/models/Category.dart';
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/Classe.dart';

import '../../../domain/models/Bloodline.dart';
import '../../../domain/models/Genre.dart';
import '../character/CharacterWidgets.dart';

class MjWidgets {
  static Future<void Function()> buildCreateCharacterAlertDialog(
      Character? initialCharacter,
      BuildContext context,
      List<String> playersName,
      void Function(Character character) addCharacterList) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _name =
        TextEditingController(text: initialCharacter?.name ?? '');
    final TextEditingController _level =
        TextEditingController(text: initialCharacter?.niveau.toString() ?? '');
    final TextEditingController _chair =
        TextEditingController(text: initialCharacter?.chair.toString() ?? '2');
    final TextEditingController _esprit =
        TextEditingController(text: initialCharacter?.esprit.toString() ?? '2');
    final TextEditingController _essence = TextEditingController(
        text: initialCharacter?.essence.toString() ?? '2');
    final TextEditingController _pvMax =
        TextEditingController(text: initialCharacter?.pvMax.toString() ?? '');
    final TextEditingController _pfMax =
        TextEditingController(text: initialCharacter?.pfMax.toString() ?? '');
    final TextEditingController _ppMax =
        TextEditingController(text: initialCharacter?.ppMax.toString() ?? '');
    final TextEditingController _lux =
        TextEditingController(text: initialCharacter?.lux ?? '');
    final TextEditingController _umbra =
        TextEditingController(text: initialCharacter?.umbra ?? '');
    final TextEditingController _secunda =
        TextEditingController(text: initialCharacter?.secunda ?? '');
    final TextEditingController _picture =
    TextEditingController(text: initialCharacter?.picture ?? '');
    final TextEditingController _pictureApotheose =
    TextEditingController(text: initialCharacter?.pictureApotheose ?? '');
    final TextEditingController _background =
        TextEditingController(text: initialCharacter?.background ?? '');
    Classe? classe = initialCharacter?.classe ?? null;
    Bloodline? bloodline = initialCharacter?.bloodline ?? null;
    Genre? genre = initialCharacter?.genre ?? null;
    Category? category = initialCharacter?.category ?? null;
    Color? buttonColor = initialCharacter?.buttonColorOrDefault();
    Color? textColor = initialCharacter?.textColorOrDefault();
    String? player = initialCharacter?.playerName ?? null;
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Ajouter personnage"),
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(children: [
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                            child: SizedBox(
                                width: 200.0,
                                child: TextFormField(
                                  controller: _name,
                                  validator: (value) {
                                    return value != null
                                        ? ((value.isNotEmpty)
                                            ? null
                                            : "Entrez un nom de personnage")
                                        : null;
                                  },
                                  decoration: InputDecoration(hintText: "Nom"),
                                ))),
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: SizedBox(
                                width: 100.0,
                                child: TextFormField(
                                  controller: _level,
                                  decoration:
                                      InputDecoration(hintText: "Niveau"),
                                )))
                      ]),
                      Row(children: [
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                            child: SizedBox(
                                width: 100.0,
                                child: TextFormField(
                                  controller: _chair,
                                  validator: (value) {
                                    return value != null
                                        ? ((value.isNotEmpty &&
                                                int.tryParse(value) != null)
                                            ? null
                                            : "Chair?")
                                        : null;
                                  },
                                  decoration:
                                      InputDecoration(hintText: "Chair"),
                                ))),
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                            child: SizedBox(
                                width: 100.0,
                                child: TextFormField(
                                  controller: _esprit,
                                  validator: (value) {
                                    return value != null
                                        ? ((value.isNotEmpty &&
                                                double.tryParse(value) != null)
                                            ? null
                                            : "Esprit?")
                                        : null;
                                  },
                                  decoration:
                                      InputDecoration(hintText: "Esprit"),
                                ))),
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: SizedBox(
                                width: 100.0,
                                child: TextFormField(
                                  controller: _essence,
                                  validator: (value) {
                                    return value != null
                                        ? ((value.isNotEmpty &&
                                                double.tryParse(value) != null)
                                            ? null
                                            : "Essence?")
                                        : null;
                                  },
                                  decoration:
                                      InputDecoration(hintText: "Essence"),
                                ))),
                      ]),
                      Row(children: [
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                            child: SizedBox(
                                width: 100.0,
                                child: TextFormField(
                                  controller: _pvMax,
                                  decoration: InputDecoration(hintText: "PV"),
                                ))),
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                            child: SizedBox(
                                width: 100.0,
                                child: TextFormField(
                                  controller: _pfMax,
                                  decoration: InputDecoration(hintText: "PF"),
                                ))),
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: SizedBox(
                                width: 100.0,
                                child: TextFormField(
                                  controller: _ppMax,
                                  decoration: InputDecoration(hintText: "PP"),
                                ))),
                      ]),
                      Row(children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                          child: DropdownButton<Classe>(
                            hint: Text('Classe'),
                            value: classe,
                            icon: const Icon(Icons.arrow_downward),
                            onChanged: (Classe? newValue) {
                              setState(() {
                                classe = newValue;
                              });
                            },
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            items: Classe.values
                                .map<DropdownMenuItem<Classe>>((Classe value) {
                              return DropdownMenuItem<Classe>(
                                value: value,
                                child: Text(value.name),
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: DropdownButton<Bloodline>(
                            hint: Text('Ligne'),
                            value: bloodline,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            onChanged: (Bloodline? newValue) {
                              setState(() {
                                bloodline = newValue;
                              });
                            },
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            items: Bloodline.values
                                .map<DropdownMenuItem<Bloodline>>(
                                    (Bloodline value) {
                              return DropdownMenuItem<Bloodline>(
                                value: value,
                                child: Text(value.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ]),
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                          child: TextFormField(
                            controller: _lux,
                            decoration: InputDecoration(hintText: "Lux"),
                          )),
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                          child: TextFormField(
                            controller: _umbra,
                            decoration: InputDecoration(hintText: "Umbra"),
                          )),
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                          child: TextFormField(
                            controller: _secunda,
                            decoration: InputDecoration(hintText: "Secunda"),
                          )),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                              child: DropdownButton<Genre>(
                                hint: Text('Genre'),
                                value: genre,
                                icon: const Icon(Icons.arrow_downward),
                                onChanged: (Genre? newValue) {
                                  setState(() {
                                    genre = newValue;
                                  });
                                },
                                style:
                                const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                items: Genre.values
                                    .map<DropdownMenuItem<Genre>>(
                                        (Genre value) {
                                      return DropdownMenuItem<Genre>(
                                        value: value,
                                        child: Text(value.name),
                                      );
                                    }).toList(),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: DropdownButton<Category>(
                                hint: Text('Categorie'),
                                value: category,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                onChanged: (Category? newValue) {
                                  setState(() {
                                    category = newValue;
                                  });
                                },
                                style:
                                const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                items: Category.values
                                    .map<DropdownMenuItem<Category>>(
                                        (Category value) {
                                      return DropdownMenuItem<Category>(
                                        value: value,
                                        child: Text(value.name),
                                      );
                                    }).toList(),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: DropdownButton<String>(
                                hint: Text('Joueuse'),
                                value: player,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    player = newValue;
                                  });
                                },
                                style:
                                const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                items: playersName
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: DropdownButton<Color>(
                                hint: Text('Couleur Bouton'),
                                value: buttonColor,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                onChanged: (Color? newValue) {
                                  setState(() {
                                    buttonColor = Color(newValue?.value ?? 0);
                                  });
                                },
                                style:
                                const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                items: CharacterWidgets.getColorList()
                                    .map<DropdownMenuItem<Color>>(
                                        (Color value) {
                                      return DropdownMenuItem<Color>(
                                        value: value,
                                        child: Text(value.toString(),
                                          style: TextStyle(
                                              backgroundColor: value,
                                              color: value
                                          ),),
                                      );
                                    }).toList(),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: DropdownButton<Color>(
                                hint: Text('Couleur Text'),
                                value: textColor,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                onChanged: (Color? newValue) {
                                  setState(() {
                                    textColor = Color(newValue?.value ?? 0);
                                  });
                                },
                                style:
                                const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                items: CharacterWidgets.getColorList()
                                    .map<DropdownMenuItem<Color>>(
                                        (Color value) {
                                      return DropdownMenuItem<Color>(
                                        value: value,
                                        child: Text(value.toString(),
                                          style: TextStyle(
                                              backgroundColor: value,
                                              color: value
                                          ),),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ]),
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [SizedBox(
                          width: 150.0,
                          child: TextFormField(
                            controller: _picture,
                            decoration: InputDecoration(hintText: "Picture"),
                          )),
                      SizedBox(
                          width: 150.0,
                          child: TextFormField(
                            controller: _pictureApotheose,
                            decoration: InputDecoration(hintText: "Picture Apothéose"),
                          ))]),
                      SizedBox(
                          width: 300.0,
                          child: TextFormField(
                            controller: _background,
                            decoration: InputDecoration(hintText: "Background"),
                          )),
                    ],
                  )),
              actions: <Widget>[
                InkWell(
                  child: Text('OK   '),
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      addCharacterList(Character(
                          name: _name.value.text,
                          classe: classe ??
                              initialCharacter?.classe ??
                              Classe.INCONNU,
                          bloodline: bloodline ??
                              initialCharacter?.bloodline ??
                              Bloodline.AUCUN,
                          apotheose: initialCharacter?.apotheose ??
                              Apotheose.NONE,
                          apotheoseImprovement: initialCharacter?.apotheoseImprovement,
                          apotheoseImprovementList: initialCharacter?.apotheoseImprovementList ?? [],
                          chair: int.parse(_chair.value.text),
                          esprit: int.parse(_esprit.value.text),
                          essence: int.parse(_essence.value.text),
                          pv: initialCharacter?.pv ??
                              int.tryParse(_pvMax.value.text) ??
                              (int.parse(_chair.value.text) * 2),
                          pvMax: int.tryParse(_pvMax.value.text) ??
                              initialCharacter?.pvMax ??
                              (int.parse(_chair.value.text) * 2),
                          pf: initialCharacter?.pf ??
                              int.tryParse(_pfMax.value.text) ??
                              (int.parse(_esprit.value.text)),
                          pfMax: int.tryParse(_pfMax.value.text) ??
                              initialCharacter?.pfMax ??
                              (int.parse(_esprit.value.text)),
                          pp: initialCharacter?.pp ??
                              int.tryParse(_ppMax.value.text) ??
                              (int.parse(_essence.value.text)),
                          ppMax: int.tryParse(_ppMax.value.text) ??
                              initialCharacter?.pvMax ??
                              (int.parse(_essence.value.text)),
                          niveau: int.tryParse(_level.value.text) ??
                              initialCharacter?.niveau ??
                              Random().nextInt(20),
                          arcanes: initialCharacter?.arcanes ?? 3,
                          arcanesMax: initialCharacter?.arcanesMax ?? 3,
                          lux: _lux.value.text,
                          umbra: _umbra.value.text,
                          secunda: _secunda.value.text,
                          dettes:
                              initialCharacter?.dettes ?? Random().nextInt(11),
                          picture: _picture.value.text,
                          pictureApotheose: _pictureApotheose.value.text,
                          background: _background.value.text,
                          notes: initialCharacter?.notes ?? '',
                          category: category ??
                              initialCharacter?.category ??
                              Category.TEMPO,
                          genre:
                              genre ?? initialCharacter?.genre ?? Genre.AUTRE,
                          relance: initialCharacter?.relance ?? 0,
                          playerName:
                              player ?? initialCharacter?.playerName ?? null,
                          buttonColor: buttonColor?.value.toString() ?? initialCharacter?.buttonColor ?? null,
                          textColor: textColor?.value.toString() ?? initialCharacter?.textColor ?? null,
                      uid: null));
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  static Future<void Function()> buildCreateCharacterWithTemplateAlertDialog(
      BuildContext context,
      String templateName,
      void Function(String templateName, String customName, int level, int number) addCharacterWithTemplate) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _name =
        TextEditingController(text: templateName);
    final TextEditingController _level = TextEditingController(text: '');
    final TextEditingController _number = TextEditingController(text: '');
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Ajouter ${templateName}"),
              content: Form(
                  key: _formKey,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Row(children: [
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                          child: SizedBox(
                              width: 100.0,
                              child: TextFormField(
                                controller: _name,
                                validator: (value) {
                                  return value != null
                                      ? ((value.isNotEmpty)
                                          ? null
                                          : "Entrez un nom de personnage")
                                      : null;
                                },
                                decoration: InputDecoration(hintText: "Nom"),
                              ))),
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: SizedBox(
                              width: 100.0,
                              child: TextFormField(
                                controller: _level,
                                decoration: InputDecoration(hintText: "Niveau"),
                              ))),
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: SizedBox(
                              width: 100.0,
                              child: TextFormField(
                                controller: _number,
                                decoration: InputDecoration(hintText: "Nombre"),
                              ))),
                    ]),
                  ])),
              actions: <Widget>[
                InkWell(
                  child: Text('OK   '),
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      addCharacterWithTemplate(templateName, _name.value.text, int.parse(_level.value.text),  int.parse(_number.value.text));
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
