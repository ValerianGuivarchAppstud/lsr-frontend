// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      name: json['name'] as String,
      classe: $enumDecode(_$ClasseEnumMap, json['classe']),
      bloodline: $enumDecode(_$BloodlineEnumMap, json['bloodline']),
      apotheose: $enumDecode(_$ApotheoseEnumMap, json['apotheose']),
      chair: json['chair'] as int,
      esprit: json['esprit'] as int,
      essence: json['essence'] as int,
      pv: json['pv'] as int,
      pvMax: json['pvMax'] as int,
      pf: json['pf'] as int,
      pfMax: json['pfMax'] as int,
      pp: json['pp'] as int,
      ppMax: json['ppMax'] as int,
      dettes: json['dettes'] as int,
      arcanes: json['arcanes'] as int,
      arcanesMax: json['arcanesMax'] as int,
      niveau: json['niveau'] as int,
      lux: json['lux'] as String,
      umbra: json['umbra'] as String,
      secunda: json['secunda'] as String,
      notes: json['notes'] as String,
      category: $enumDecode(_$CategoryEnumMap, json['category']),
      genre: $enumDecode(_$GenreEnumMap, json['genre']),
      relance: json['relance'] as int,
      picture: json['picture'] as String,
      pictureApotheose: json['pictureApotheose'] as String,
      background: json['background'] as String,
      playerName: json['playerName'] as String?,
      buttonColor: json['buttonColor'] as String?,
      textColor: json['textColor'] as String?,
      apotheoseImprovement: json['apotheoseImprovement'] as String?,
      apotheoseImprovementList:
          (json['apotheoseImprovementList'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      uid: json['uid'] as int?,
      alliesName: (json['alliesName'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      help: json['help'] as int?,
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'name': instance.name,
      'classe': _$ClasseEnumMap[instance.classe]!,
      'bloodline': _$BloodlineEnumMap[instance.bloodline]!,
      'apotheose': _$ApotheoseEnumMap[instance.apotheose]!,
      'chair': instance.chair,
      'esprit': instance.esprit,
      'essence': instance.essence,
      'pv': instance.pv,
      'pvMax': instance.pvMax,
      'pf': instance.pf,
      'pfMax': instance.pfMax,
      'pp': instance.pp,
      'ppMax': instance.ppMax,
      'dettes': instance.dettes,
      'arcanes': instance.arcanes,
      'arcanesMax': instance.arcanesMax,
      'niveau': instance.niveau,
      'lux': instance.lux,
      'umbra': instance.umbra,
      'secunda': instance.secunda,
      'notes': instance.notes,
      'category': _$CategoryEnumMap[instance.category]!,
      'genre': _$GenreEnumMap[instance.genre]!,
      'relance': instance.relance,
      'picture': instance.picture,
      'pictureApotheose': instance.pictureApotheose,
      'background': instance.background,
      'playerName': instance.playerName,
      'buttonColor': instance.buttonColor,
      'textColor': instance.textColor,
      'apotheoseImprovement': instance.apotheoseImprovement,
      'apotheoseImprovementList': instance.apotheoseImprovementList,
      'alliesName': instance.alliesName,
      'uid': instance.uid,
      'help': instance.help,
    };

const _$ClasseEnumMap = {
  Classe.CHAMPION: 'CHAMPION',
  Classe.CORROMPU: 'CORROMPU',
  Classe.REJETE: 'REJETE',
  Classe.PACIFICATEUR: 'PACIFICATEUR',
  Classe.SPIRITE: 'SPIRITE',
  Classe.ARCANISTE: 'ARCANISTE',
  Classe.CHAMPION_ARCANIQUE: 'CHAMPION_ARCANIQUE',
  Classe.SOLDAT: 'SOLDAT',
  Classe.SKINWALKER: 'SKINWALKER',
  Classe.AVATAR: 'AVATAR',
  Classe.DRAGON: 'DRAGON',
  Classe.GAME_MASTER: 'GAME_MASTER',
  Classe.ROI: 'ROI',
  Classe.PAROLIER: 'PAROLIER',
  Classe.INCONNU: 'INCONNU',
};

const _$BloodlineEnumMap = {
  Bloodline.LUMIERE: 'LUMIERE',
  Bloodline.TENEBRE: 'TENEBRE',
  Bloodline.EAU: 'EAU',
  Bloodline.FEU: 'FEU',
  Bloodline.VENT: 'VENT',
  Bloodline.TERRE: 'TERRE',
  Bloodline.FOUDRE: 'FOUDRE',
  Bloodline.GLACE: 'GLACE',
  Bloodline.NAGA: 'NAGA',
  Bloodline.TROGLODYTE: 'TROGLODYTE',
  Bloodline.LYCAN: 'LYCAN',
  Bloodline.GOULE: 'GOULE',
  Bloodline.SUCCUBE: 'SUCCUBE',
  Bloodline.ILLITHIDE: 'ILLITHIDE',
  Bloodline.GORGONNE: 'GORGONNE',
  Bloodline.ARBRE: 'ARBRE',
  Bloodline.TERREUR: 'TERREUR',
  Bloodline.COLLECTIONNEUR: 'COLLECTIONNEUR',
  Bloodline.NECROMANCIE: 'NECROMANCIE',
  Bloodline.VOYAGEUR: 'VOYAGEUR',
  Bloodline.JUGE: 'JUGE',
  Bloodline.VOLEUR: 'VOLEUR',
  Bloodline.AUCUN: 'AUCUN',
};

const _$ApotheoseEnumMap = {
  Apotheose.NONE: 'NONE',
  Apotheose.NORMALE: 'NORMALE',
  Apotheose.IMPROVED: 'IMPROVED',
  Apotheose.ARCANIQUE: 'ARCANIQUE',
  Apotheose.FORME_VENGERESSE: 'FORME_VENGERESSE',
  Apotheose.SURCHARGE: 'SURCHARGE',
  Apotheose.SURCHARGE_IMPROVED: 'SURCHARGE_IMPROVED',
  Apotheose.FINALE: 'FINALE',
};

const _$CategoryEnumMap = {
  Category.PJ: 'PJ',
  Category.PNJ_ALLY: 'PNJ_ALLY',
  Category.PNJ_ENNEMY: 'PNJ_ENNEMY',
  Category.TEMPO: 'TEMPO',
  Category.TEMPLATE: 'TEMPLATE',
};

const _$GenreEnumMap = {
  Genre.HOMME: 'HOMME',
  Genre.FEMME: 'FEMME',
  Genre.AUTRE: 'AUTRE',
};
