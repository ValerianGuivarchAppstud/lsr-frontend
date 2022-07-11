import 'dart:math';
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:lsr/domain/models/Bloodline.dart';
import 'package:lsr/domain/models/Category.dart';

import 'Classe.dart';
import 'Genre.dart';
part 'Character.g.dart';

@JsonSerializable()
class Character {
  String name;
  late Classe classe;
  late Bloodline bloodline;
  int chair;
  int esprit;
  int essence;
  late int pv;
  late int pvMax;
  late int pf;
  late int pfMax;
  late int pp;
  late int ppMax;
  late int dettes;
  late int arcanes;
  late int arcanesMax;
  late int niveau;
  late String lux;
  late String umbra;
  late String secunda;
  late String notes;
  late Category category;
  late Genre genre;
  late int relance;
  late String? picture;
  late String? background;
  late String? playerName;
  Character({
      required this.name,
      required this.classe,
      required this.bloodline,
      required this.chair,
      required this.esprit,
      required this.essence,
      required this.pv,
      required this.pvMax,
      required this.pf,
      required this.pfMax,
      required this.pp,
      required this.ppMax,
      required this.dettes,
      required this.arcanes,
      required this.arcanesMax,
      required this.niveau,
      required this.lux,
      required this.umbra,
      required this.secunda,
      required this.notes,
      required this.category,
    required this.genre,
    required this.relance,
    required this.picture,
    required this.background,
    required this.playerName
  });



  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CharacterToJson(this);

  String description() {
    return getClasseDescription() + ' ' + getBloodlineDescription()+', niveau ${niveau}';
  }

  String getClasseDescription() {
    switch(classe){
      case Classe.CHAMPION:
        return genre == Genre.HOMME ? "Champion" : genre == Genre.FEMME ? "Championne" : "Champion.ne";
      case Classe.CORROMPU:
        return genre == Genre.HOMME ? "Corrompu" : genre == Genre.FEMME ?  "Corrompue" : "Corrompu.e";
      case Classe.REJETE:
        return genre == Genre.HOMME ? "Rejeté" : genre == Genre.FEMME ?  "Rejetée" : "Rejeté.e";
      case Classe.PACIFICATEUR:
        return genre == Genre.HOMME ? "Pacificateur" : genre == Genre.FEMME ?  "Pacificatrice" : "Pacificateurice";
      case Classe.SPIRITE:
        return genre == Genre.HOMME ? "Spirit" : genre == Genre.FEMME ?  "Spirite" : "Spirit.e";
      case Classe.ARCANISTE:
        return "Arcaniste";
      case Classe.CHAMPION_ARCANIQUE:
        return genre == Genre.HOMME ? "Champion Arcanique" : genre == Genre.FEMME ?  "Championne Arcanique" :  "Champion.ne Arcanique";
      case Classe.SOLDAT:
        return genre == Genre.HOMME ? "Soldat" : genre == Genre.FEMME ?  "Soldate" : "Soldat.e";
      case Classe.INCONNU:
        return "Classe inconnue";
    }
  }

  String getBloodlineDescription() {
    switch (bloodline) {
      case Bloodline.EAU:
        return "de l'Eau";
      case Bloodline.LUMIERE:
        return "de la Lumière";
      case Bloodline.TENEBRE:
        return "des Ténèbres";
      case Bloodline.FEU:
        return "du Feu";
      case Bloodline.VENT:
        return "du Vent";
      case Bloodline.TERRE:
        return "de la Terre";
      case Bloodline.FOUDRE:
        return "de la Foudre";
      case Bloodline.GLACE:
        return "de la Glace";
      case Bloodline.NAGA:
        return "Naga";
      case Bloodline.TROGLODYTE:
        return "Troglodyte";
      case Bloodline.LYCAN:
        return "Lycan";
      case Bloodline.GOULE:
        return "Goule";
      case Bloodline.SUCCUBE:
        return "Succube";
      case Bloodline.ILLITHIDE:
        return "Illithide";
      case Bloodline.ARBRE:
        return "de l'Arbre";
      case Bloodline.AUCUN:
        return "";
    }
  }

  int getInjury() {
    double diff = (pvMax - pv + 1) / 6;
    return diff.floor();
  }

  @override
  String toString() {
    return 'Character{name: $name}';
  }
}