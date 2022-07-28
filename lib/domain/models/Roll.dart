import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lsr/domain/models/Apotheose.dart';

import 'RollType.dart';

part 'Roll.g.dart';

//  flutter pub run build_runner build
@JsonSerializable()
class Roll {
  String id;
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
  int? juge12;
  int? juge34;
  String? characterToHelp;
  String? picture;
  String? empirique;
  String? data;
  Apotheose? apotheose;
  List<Roll> resistRollList;

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
      this.picture,
      this.data,
      this.empirique,
      this.apotheose,
      this.success,
      this.resistRollList);

  secretText() {
    return secret ? '(secret) ' : '';
  }

  bonusMalusText() {
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
        return 'Jet de Sauvegarde contre la Mort';
      case RollType.RELANCE:
        return ;
      case RollType.APOTHEOSE:
        return 'Jet de Contrôle de l\'Apotheose';
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
    final DateFormat formatter = DateFormat('HH-mm-ss');
    final String formatted = formatter.format(date.toLocal());
    return formatted; // something like 2013-04-20
  }

  int getDegats(Roll resistingRoll) {
    return max(((((resistingRoll.success ?? 0) - (this.success ?? 0) )/ 2).round()), 0);
  }
}