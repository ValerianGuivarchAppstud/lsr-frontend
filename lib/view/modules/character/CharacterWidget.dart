import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/Character.dart';
import '../../widgets/StatRow.dart';
import '../../widgets/common/DisplayErrorWidget.dart';
import '../../widgets/common/LoadingWidget.dart';

class CharacterWidget extends StatelessWidget {
  static final characterKey = Key("character_key");
  static final snackKey = Key("snackbar_key");

  final bool loading;
  final Character? character;
  final String? error;
  final Size size;
  final TextEditingController noteFieldController;

  CharacterWidget(
      {required Key key,
      required this.loading,
      required this.character,
      required this.error,
      required this.size,
      required this.noteFieldController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return LoadingWidget(
          key: Key(
        "LoadingWidget",
      ));
    } else if (error != null) {
      return DisplayErrorWidget(
          key: Key(
        "ErrorWidget",
      ));
    } else if (character == null) {
      return Center(
        child: Text("Aucun personnage"),
      );
    } else {
      return _buildCharacter(character!);
    }
  }

  _buildCharacter(Character character) => Column(
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
                      "assets/images/background/${describeEnum(character.bloodline).toLowerCase()}.jpg",
                      fit: BoxFit.fill,
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
                        statValue: character.chair.toString(),
                        statOnPressed: () {
                          print("chair1");
                          character.chair = character.chair + 1;
                          print("chair2");
                          //presenter.updateCharacter(character);
                        }),
                    StatRow(
                        statName: "Esprit",
                        statValue: character.esprit.toString(),
                        statOnPressed: () {
                          character.chair = character.chair + 1;
                          //presenter.updateCharacter(character);
                        }),
                    StatRow(
                        statName: "Essence",
                        statValue: character.essence.toString(),
                        statOnPressed: () {
                          character.chair = character.chair + 1;
                          //presenter.updateCharacter(character);
                        }),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatRow(
                        statName: "Lux",
                        statValue: character.lux,
                        statOnPressed: () {
                          character.chair = character.chair + 1;
                          //presenter.updateCharacter(character);
                        }),
                    StatRow(
                        statName: "Umbra",
                        statValue: character.umbra,
                        statOnPressed: () {
                          character.chair = character.chair + 1;
                          //presenter.updateCharacter(character);
                        }),
                    StatRow(
                        statName: "Secunda",
                        statValue: character.secunda,
                        statOnPressed: () {
                          character.chair = character.chair + 1;
                          //presenter.updateCharacter(character);
                        }),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: noteFieldController,
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                decoration: InputDecoration(
                    hintText: "Entrez vos notes ici",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.redAccent))),
              ),
            )
          ]);

  CircleAvatar profilePicture({required double radius}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.blue,
      foregroundImage: NetworkImage(
          "https://images.pexels.com/photos/1756086/pexels-photo-1756086.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"),
    );
  }
}
