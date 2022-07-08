import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'RollType.dart';
part 'Roll.g.dart';

//  flutter pub run build_runner build
@JsonSerializable()
class Roll {
  String id;

  Roll(
      this.id,
      this.rollerName,
      this.rollType,
      this.date,
      this.secret,
      this.focus,
      this.power,
      this.proficiency,
      this.benediction,
      this.malediction,
      this.result,
      this.success);

  String rollerName;
  RollType rollType;
  DateTime date;
  bool secret;
  bool focus;
  bool power;
  bool proficiency;
  int benediction;
  int malediction;
  List<int> result;
  int? success;

  /*
  static successRoll(RollType rollType) {
    switch(rollType) {
      case RollType.CHAIR:
      case RollType.ESPRIT :
      case RollType.ESSENCE:
      case RollType.MAGIE:
      case RollType.MAGIE:
      case RollType.ARCANE_ESPRIT:
      case RollType.ARCANE_ESSENCE:
      case RollType.SOIN:
        return true;
      case RollType.SAUVEGARDE_VS_MORT:
      case RollType.EMPIRIQUE :
        return false;
    }
  }

  Roll({required this.rollType, required this.secret, required this.focus, required this.power,
    required this.proficiency, required this.benediction, required this.malediction,
    required int diceNumber, required int diceValue}){
    diceNumber = diceNumber + benediction - malediction + (focus ? 1 : 0);
    result = [];
    success = 0;
    var rng = new Random();
    for(var i = 0 ; i < diceNumber; i++ ) {
      result.add(rng.nextInt(diceValue - 1)+1);
    }
  }

  factory Roll.rollChair({required Character roller, required bool secret, required bool focus, required bool power,
    required bool proficiency, required bool benediction, required bool malediction}) {
    Roll()
  }


  factory Roll.statRoll({required Character roller, required RollType rollType, required bool secret, required bool focus, required bool power,
    required bool proficiency, required bool benediction, required bool malediction}) {
    int state = 0;
    switch(rollType) {
      case RollType.CHAIR:
        state = roller.chair;
        break;
      case RollType.ESPRIT:
        state = roller.esprit;
        break;
      case RollType.ESSENCE:
        state = roller.essence;
        break;
      case RollType.MAGIE:
        state = roller.essence; // TODO check Tibo
        break;
      case RollType.SOIN:
        state = roller.essence;
        break;
      case RollType.ARCANE_ESPRIT:
        state = roller.esprit;
        break;
      case RollType.ARCANE_ESSENCE:
        state = roller.essence;
        break;
      case RollType.SAUVEGARDE_VS_MORT:
        state = roller.essence; // TODO check
        break;
    }
  }

  Roll({required Character roller, required this.rollType, required this.secret, required this.focus, required this.power,
    required this.proficiency, required this.benediction, required this.malediction}){
    rollerName = roller.name;
    int state = 0;
    switch(rollType) {
      case RollType.CHAIR:
        state = roller.chair;
        break;
      case RollType.ESPRIT:
        state = roller.esprit;
        break;
      case RollType.ESSENCE:
        state = roller.essence;
        break;
      case RollType.EMPIRIQUE:
        state = roller.chair; // TODO add
        break;
      case RollType.MAGIE:
        state = roller.essence; // TODO check Tibo
        break;
      case RollType.SOIN:
        state = roller.essence;
        break;
      case RollType.ARCANE_ESPRIT:
        state = roller.esprit;
        break;
      case RollType.ARCANE_ESSENCE:
        state = roller.essence;
        break;
      case RollType.SAUVEGARDE_VS_MORT:
        state = roller.essence; // TODO check
        break;
    }

    this.result = [];
  }
*/

  secretText() {
    return secret ? '(secret) ' : '';
  }

  bonusMalusText() {
    String text = '';
    if(malediction==0 && benediction==0) {
      return '';
    } else if (malediction>0 && benediction==0) {
      return 'Avec $malediction malédiction' + (malediction>0 ? 's' : '')+ ', ';
    } else if(malediction==0 && benediction>0) {
    return 'Avec $benediction benediction' + (benediction>0 ? 's' : '')+ ', ';
    } else {
      return 'Avec $malediction malédiction' + (malediction>0 ? 's' : '') + ' et $benediction benediction' + (benediction>0 ? 's' : '')+ ', ';
    }
  }

  rollTypeText() {
    switch(rollType){
      case RollType.CHAIR:
        return 'Jet de Chair';
      case RollType.ESPRIT:
        return 'Jet d\'Esprit';
      case RollType.ESSENCE:
        return 'Jet d\'Essence';
      case RollType.EMPIRIQUE:
        return 'Jet empirique';
      case RollType.MAGIE_LEGERE:
        return 'Jet de Magie légère';
      case RollType.MAGIE_FORTE:
        return 'Jet de Magie forte';
      case RollType.SOIN:
        return 'Jet de Soin';
      case RollType.ARCANE_FIXE:
        return 'Jet d\'Arcane fixe';
      case RollType.ARCANE_ESPRIT:
        return 'Jet d\'Arcane d\'Esprit';
      case RollType.ARCANE_ESSENCE:
        return 'Jet d\'Arcane d\'Essence';
      case RollType.SAUVEGARDE_VS_MORT:
        return ;
    }
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Roll.fromJson(Map<String, dynamic> json) => _$RollFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RollToJson(this);

  powerText() {
    if (power) {
      return {TextSpan( // se concentre et
        text: 'en y mettant toute sa ',
      ),
        TextSpan( // se concentre et
            text: 'puissance',
            style: TextStyle(
                fontStyle: FontStyle.italic
            )
        ),
      };
    }
  }

  dateText() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('hh-mm-ss');
    final String formatted = formatter.format(now);
    return formatted; // something like 2013-04-20
  }

  static diceValueToIcon(int value) {
    switch(value) {
      case 1:
        return '1';
      case 2:
        return '2';
      case 3:
        return '3';
      case 4:
        return '4';
      case 5:
        return '5';
      case 6:
        return "6";
      default:
        return '[$value]';
    }
  }
}