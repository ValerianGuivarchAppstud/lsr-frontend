import 'package:json_annotation/json_annotation.dart';
import 'package:lsr/domain/models/Bloodline.dart';

import 'Classe.dart';
part 'Character.g.dart';

@JsonSerializable()
class Character {
  String name;
  Classe classe;
  Bloodline bloodline;
  int chair;
  int esprit;
  int essence;
  int pv;
  int pvMax;
  int pf;
  int pfMax;
  int pp;
  int ppMax;
  int dettes;
  int arcanes;
  int arcanesMax;
  int niveau;
  String lux;
  String umbra;
  String secunda;
  String notes;
  String category;
  bool genreMasculin;
  int relance;
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
    required this.genreMasculin,
    required this.relance
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
        return genreMasculin ? "Champion" : "Championne";
      case Classe.CORROMPU:
        return genreMasculin ? "Corrompu" : "Corrompue";
      case Classe.REJETE:
        return genreMasculin ? "Rejeté" : "Rejetée";
      case Classe.PACIFICATEUR:
        return genreMasculin ? "Pacificateur" : "Pacificatrice";
      case Classe.SPIRITE:
        return genreMasculin ? "Spirite" : "Spirite";
      case Classe.ARCANISTE:
        return genreMasculin ? "Arcaniste" : "Arcaniste";
      case Classe.CHAMPION_ARCANIQUE:
        return genreMasculin ? "Champion Arcanique" : "Championne Arcanique";
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
}