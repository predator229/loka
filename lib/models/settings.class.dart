import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:loka/models/country.class.dart';
import 'package:loka/views/mymoins.view.dart';
import 'package:loka/views/profil.view.dart';

class SettingsClass {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Color color =  Color.fromARGB(255,2,124,125);
  Color color_ =  Color.fromARGB(255,1,155,137);
  Color bottunColor =  Color.fromARGB(255,8,131,120);
  Color progressBGC =  Color.fromARGB(255,8,131,120);
  Color noProgressBGC =  Color.fromARGB(255,245,243,240);
  FontWeight titlePrimaryFW = FontWeight.w700;
  List<TypeApartment> typesApartments = [
    TypeApartment(id: '0', icone: Icons.view_comfortable_outlined, name: "Tous les logements"),
    TypeApartment(id: '1', icone: Icons.home_filled, name: "Chambre salon"),
    TypeApartment(id: '2', icone: Icons.home_work, name: "Appartement meublé"),
    TypeApartment(id: '3', icone: Icons.blinds_closed_outlined, name: "Imeubles a vendre"),
    TypeApartment(id: '4', icone: Icons.local_offer_rounded, name: "Imeubles a vendre"),
  ];
  List<RoomType> roomTypes = [
    RoomType(id: '1', name: 'Chambre', description: "Chambre a couche", icon: Icons.bed_rounded),
    RoomType(id: '2', name: 'Salon', description: "Salon", icon: Icons.chair),
  ];

  List<EquimentType> equipementsType = [
    EquimentType(id: '1', name: 'TV', description: "TV 40", icon: Icons.tv),
    EquimentType(id: '2', name: 'Escalier', description: "Escalier sur deux etages", icon: Icons.wallet_sharp),
    EquimentType(id: '3', name: 'Véranda', description: "Véranda sur 40", icon: Icons.waterfall_chart_sharp),
    EquimentType(id: '4', name: 'Plafond', description: "Plafond en bois massif", icon: Icons.panorama_wide_angle_select_sharp),
    EquimentType(id: '5', name: 'Avec cour', description: "Avec cour", icon: Icons.outdoor_grill_sharp),
    EquimentType(id: '6', name: 'Cuisine', description: "Cuisine americaine", icon: Icons.kitchen_sharp),
    EquimentType(id: '7', name: 'Portail', description: "Portail blinde", icon: Icons.door_back_door),
    EquimentType(id: '8', name: 'Toillettes', description: "Toillettes americaine", icon: Icons.sanitizer_outlined),
    EquimentType(id: '9', name: 'Dégagement', description: "Dégagement", icon: Icons.self_improvement),
    EquimentType(id: '10', name: 'Salle de bain', description: "Toillettes americaine", icon: Icons.bathroom),
    EquimentType(id: '11', name: 'Jardin', description: "Toillettes americaine", icon: Icons.gradient_rounded),
  ];
  List<CouvertureChambre> couvertureChambres = [
    CouvertureChambre(id: '1', name: 'Plafonné', description: "Plafonné", icon: "images/couverture_plafonnnee.png"),
    CouvertureChambre(id: '2', name: 'Dallé', description: "Dallé", icon: "images/couverture_dallee.png"),
    CouvertureChambre(id: '3', name: 'Staffée', description: "Staffée", icon: "images/couverture_staffee.png"),
  ];

  List<ProfilMenu> profilsMenu = [
    ProfilMenu(id: '1', title: 'Informations personnelles', icon: Icons.person, routeName: ProfilView.routeName),
    ProfilMenu(id: '2', title: 'Mes pièces', icon: Icons.monetization_on_outlined, routeName: MyCoinsView.routeName),
    ProfilMenu(id: '3', title: 'Paramètres', icon: Icons.settings),
    ProfilMenu(id: '4', title: 'Aide', icon: Icons.report_gmailerrorred),
    ProfilMenu(id: '5', title: 'Protection des données (RGPD)', icon: Icons.private_connectivity_sharp),
    ProfilMenu(id: '6', title: 'Conditions d’utilisations', icon: Icons.filter_none_sharp),
    ProfilMenu(id: '7', title: 'Déconnection', isLogout: true,),
  ];

  List<PayementMethod> payementMethods = [
    PayementMethod(id: '1', title: 'Mobile money', icon: Icons.sd_card, routeName: ProfilView.routeName),
    PayementMethod(id: '2', title: 'Carte bancaire', icon: Icons.credit_card_outlined, routeName: MyCoinsView.routeName),
  ];

  List<TypeUser> typeUser = [
    TypeUser(id: '1', title: 'Propriétaire',),
    TypeUser(id: '2', title: 'Compte client',),
    TypeUser(id: '3', title: 'Administrateur',),
  ];
}

class JournalCard {
  int index;
  String date;
  ApartmentCard apartmentCard;
  int status;
  JournalCard({ required this.index, required this.date, required this.apartmentCard, required this.status});
}

class ApartmentCard {
  String index;
  List<String> imageUrl;
  String title;
  String description;
  String? descriptionLocation;
  String location;
  String date;
  double price;
  double rating;
  int reviews;
  int crownPoints;
  String devise;
  String perPeriod;
  bool isFavourite;
  List<TypeApartment>? typeApartment;
  int nrColoc;
  int nbrNeightbord;
  ApartmentCaracteristique? caracteristiques;

  ApartmentCard({
    required this.index,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.location,
    this.descriptionLocation,
    required this.date,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.crownPoints,
    required this.devise,
    required this.perPeriod,
    required this.isFavourite,
    this.typeApartment,
    required this.nrColoc,
    required this.nbrNeightbord,
    this.caracteristiques,
  });

  factory ApartmentCard.fromJson(Map<String, dynamic> json) {
    return ApartmentCard(
      index: json['_id'].toString(),
      imageUrl: List<String>.from(json['imageUrl']),
      title: json['title'],
      description: json['description'],
      location: json['location'],
      descriptionLocation: json['descriptionLocation'],
      date: json['date'],
      price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
      reviews: json['reviews'],
      crownPoints: json['crownPoints'],
      devise: json['devise'],
      perPeriod: json['perPeriod'],
      isFavourite: json['isFavourite'],
      typeApartment: json['typeApartment'] != null && (json['typeApartment'] as List).isNotEmpty  ? (json['typeApartment'] as List).map((i) => TypeApartment.fromJson(i)).toList()  : [], 
      nrColoc: json['nrColoc'],
      nbrNeightbord: json['nbrNeightbord'],
      caracteristiques: (json['caracteristiques'] != null)
          ? ApartmentCaracteristique.fromJson(json['caracteristiques'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'location': location,
      'descriptionLocation': descriptionLocation,
      'date': date,
      'price': price,
      'rating': rating,
      'reviews': reviews,
      'crownPoints': crownPoints,
      'devise': devise,
      'perPeriod': perPeriod,
      'isFavourite': isFavourite,
      'typeApartment': typeApartment,
      'nrColoc': nrColoc,
      'nbrNeightbord': nbrNeightbord,
      'caracteristiques': caracteristiques,
    };
  }
}

class TypeApartment {
  String id;
  String name;
  IconData icone;

  TypeApartment({
    required this.id,
    required this.name,
    required this.icone,
  });

  factory TypeApartment.fromJson(Map<String, dynamic> json) {
    return TypeApartment(
      id: json['_id'],
      name: json['name'],
      icone: getIconFromString(json['icone']),
    );
  }
  static IconData getIconFromString(String iconName) { //damien
    const Map<String, IconData> iconsMap = {
      'view_comfortable_outlined': Icons.view_comfortable_outlined,
      'home_filled': Icons.home_filled,
      'home_work': Icons.home_work,
      "blinds_closed_outlined" : Icons.blinds_closed_outlined,
      "local_offer_rounded" : Icons.local_offer_rounded,
    };
    return iconsMap[iconName] ?? Icons.error;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'icone': getIconName(icone),
    };
  }

  static String getIconName(IconData iconData) {
    return iconData.codePoint.toString();
  }

}

class Room {
  String id;
  String? moreinformation;
  String superficie;
  RoomType type;

  Room({required this.id, this.moreinformation, required this.superficie, required this.type});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['_id'],
      moreinformation: json['moreinformation'],
      superficie: json['superficie'],
      type: RoomType.fromJson(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moreinformation': moreinformation,
      'superficie': superficie,
      'type': type.toJson(),
    };
  }
}

class RoomType {
  String id;
  String name;
  String? description;
  IconData? icon;

  RoomType({required this.id, this.description, required this.name, this.icon});

  factory RoomType.fromJson(Map<String, dynamic> json) {
    return RoomType(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'] != null ?getIconFromString( json['icon']): null,
    );
  }
  static IconData getIconFromString(String iconName) { //damien
    const Map<String, IconData> iconsMap = {
      'view_comfortable_outlined': Icons.view_comfortable_outlined,
      'home_filled': Icons.home_filled,
      'home_work': Icons.home_work,
      "blinds_closed_outlined" : Icons.blinds_closed_outlined,
      "local_offer_rounded" : Icons.local_offer_rounded,
      "tv" : Icons.tv,
      "wallet_sharp" : Icons.wallet_sharp,
      "waterfall_chart_sharp" : Icons.waterfall_chart_sharp,
      "panorama_wide_angle_select_sharp" : Icons.panorama_wide_angle_select_sharp,
      "outdoor_grill_sharp" : Icons.outdoor_grill_sharp,
      "kitchen_sharp" : Icons.kitchen_sharp,
      "door_back_door" : Icons.door_back_door,
      "sanitizer_outlined" : Icons.sanitizer_outlined,
      "self_improvement" : Icons.self_improvement,
      "bathroom" : Icons.bathroom,
      "bed_rounded" : Icons.bed_rounded,
      "gradient_rounded" : Icons.gradient_rounded,
      "chair" : Icons.chair,
    };
    return iconsMap[iconName] ?? Icons.error;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon?.codePoint,
    };
  }
}

class ApartmentCaracteristique {
  String id;
  List<Room> rooms;
  String superficieTotale;
  List<ApartementEquipement>? equipements;
  List<ServiceClosest> services;

  ApartmentCaracteristique({
    required this.id,
    required this.rooms,
    required this.superficieTotale,
    this.equipements,
    required this.services,
  });

  factory ApartmentCaracteristique.fromJson(Map<String, dynamic> json) {
    return ApartmentCaracteristique(
      id: json['_id'],
      rooms: (json['rooms'] != null && json['rooms'] is List)
          ? (json['rooms'] as List).map((room) => Room.fromJson(room)).toList()
          : [],
      superficieTotale: json['superficieTotale'] ?? '',
      equipements: json['equipements'] != null
          ? (json['equipements'] as List)
              .map((e) => ApartementEquipement.fromJson(e))
              .toList()
          : [],
      services: json['services'] != null
          ? (json['services'] as List)
              .map((s) => ServiceClosest.fromJson(s))
              .toList()
          : [],
    );
  }
}

class ApartementEquipement {
  String id;
  String? moreinformation;
  String? superficie;
  EquimentType type;

  ApartementEquipement({required this.id, this.moreinformation, this.superficie, required this.type});

  factory ApartementEquipement.fromJson(Map<String, dynamic> json) {
    return ApartementEquipement(
      id: json['_id'],
      moreinformation: json['moreinformation'],
      superficie: json['superficie'],
      type: EquimentType.fromJson(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moreinformation': moreinformation,
      'superficie': superficie,
      'type': type.toJson(),
    };
  }
}

class EquimentType {
  String id;
  String name;
  String? description;
  IconData? icon;

  EquimentType({this.description, required this.id, this.icon, required this.name});

  factory EquimentType.fromJson(Map<String, dynamic> json) {
    return EquimentType(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      icon: getIconFromString(json['icon']),
    );
  }

  static IconData getIconFromString(String iconName) { //damien
    const Map<String, IconData> iconsMap = {
      'view_comfortable_outlined': Icons.view_comfortable_outlined,
      'home_filled': Icons.home_filled,
      'home_work': Icons.home_work,
      "blinds_closed_outlined" : Icons.blinds_closed_outlined,
      "local_offer_rounded" : Icons.local_offer_rounded,
      "tv" : Icons.tv,
      "wallet_sharp" : Icons.wallet_sharp,
      "waterfall_chart_sharp" : Icons.waterfall_chart_sharp,
      "panorama_wide_angle_select_sharp" : Icons.panorama_wide_angle_select_sharp,
      "outdoor_grill_sharp" : Icons.outdoor_grill_sharp,
      "kitchen_sharp" : Icons.kitchen_sharp,
      "door_back_door" : Icons.door_back_door,
      "sanitizer_outlined" : Icons.sanitizer_outlined,
      "self_improvement" : Icons.self_improvement,
      "bathroom" : Icons.bathroom,
      "bed_rounded" : Icons.bed_rounded,
      "gradient_rounded" : Icons.gradient_rounded,
      "chair" : Icons.chair,
    };
    return iconsMap[iconName] ?? Icons.error;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon?.codePoint,
    };
  }
}

class ServiceClosest {
  String id;
  String name;
  String description;

  ServiceClosest({required this.id, required this.description, required this.name});

  factory ServiceClosest.fromJson(Map<String, dynamic> json) {
    return ServiceClosest(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

class CouvertureChambre {
  String id;
  String name;
  String? description;
  String icon;

  CouvertureChambre({required this.name, required this.id, required this.icon, this.description});

  factory CouvertureChambre.fromJson(Map<String, dynamic> json) {
    return CouvertureChambre(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
    };
  }
}

class ProfilMenu {
  String id;
  String title;
  String? description;
  IconData? icon;
  String? routeName;
  bool? isLogout;

  ProfilMenu({this.icon, this.isLogout, required this.id, required this.title, this.description, this.routeName});

  factory ProfilMenu.fromJson(Map<String, dynamic> json) {
    return ProfilMenu(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'] != null ? IconData(json['icon'], fontFamily: 'MaterialIcons') : null,
      routeName: json['routeName'],
      isLogout: json['isLogout'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon?.codePoint,
      'routeName': routeName,
      'isLogout': isLogout,
    };
  }
}

class UserAuthentificate {
  String id;
  String? email;
  Country? country;
  Mobil? phoneNumber;
  String? name;
  String? surname;
  String? imgPath;
  int new_user;
  TypeUser typeUser;
  double coins;
  SelectedPayement? selectedPayementMethod;
  List<CardModel> ? cards;
  List<Mobil> ? mobils;
  UserAuthentificate({required this.coins, this.email, this.imgPath, this.name, this.surname, this.phoneNumber, required this.typeUser, required this.id, this.selectedPayementMethod, this.cards, this.country, this.mobils, required this.new_user});

factory UserAuthentificate.fromJson(Map<String, dynamic> json) {
  return UserAuthentificate(
    id: json['_id'].toString(),
    email: json['email'].toString(),
    country: json['country'] != null ? Country.fromJson(json['country']) : null,
    phoneNumber: json['phone'] != null ? Mobil.fromJson(json['phone']) : null,
    name: json['name'].toString(),
    new_user: json['new_user'] is int ? json['new_user'] : int.tryParse(json['new_user'].toString()) ?? 0,
    surname: json['surname'].toString(),
    imgPath: json['imgPath'].toString() ?? 'https://ui-avatars.com/api/?size=500&background=green&name=${json['name']}',
    typeUser: json['role'] == 'admin' ? SettingsClass().typeUser[2] : (json['role'] == 'sealler' ? SettingsClass().typeUser[0] : SettingsClass().typeUser[1]) ,
    coins: json['coins']?.toDouble() ?? 0.0,
    selectedPayementMethod: json['selectedPayementMethod'] != null 
        ? SelectedPayement.fromJson(json['selectedPayementMethod']) 
        : null,
    cards: json['cards'] != null && (json['cards'] as List).isNotEmpty 
        ? (json['cards'] as List).map((i) => CardModel.fromJson(i)).toList() 
        : [],  // Gestion des listes vides
    mobils: json['mobils'] != null && (json['mobils'] as List).isNotEmpty 
        ? (json['mobils'] as List).map((i) => Mobil.fromJson(i)).toList() 
        : [],  // Gestion des listes vides
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'country': country?.toJson(),
      'phoneNumber': phoneNumber?.toJson(),
      'name': name,
      'surname': surname,
      'imgPath': imgPath,
      'typeUser': typeUser.toJson(),
      'coins': coins,
      'selectedPayementMethod': selectedPayementMethod?.toJson(),
      'cards': cards?.map((i) => i.toJson()).toList(),
      'mobils': mobils?.map((i) => i.toJson()).toList(),
    };
  }
}

class TypeUser{
  String id;
  String title;
  String? description;

  TypeUser({ required this.id, required this.title, this.description});
    factory TypeUser.fromJson(Map<String, dynamic> json) {
    return TypeUser(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'title': title,
      'description': description?? '',
    };
  }
}

class PayementMethod {
  String id;
  String title;
  String? description;
  IconData? icon;
  String? assetPath;
  String? routeName;
  PayementMethod({this.icon, this.assetPath, required this.id, required this.title, this.description, this.routeName});
}

class CardModel{
  String id;
  String digits;
  String title;
  String expiration;
  String cvv;

  CardModel({required this.id, required this.digits, required this.title, required this.expiration, required this.cvv});
  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['_id'].toString(),
      digits: json['digits'],
      expiration: json['expiration'],
      title: json['title'],
      cvv: json['cvv'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'digits': digits,
      'expiration': expiration,
      'title': title,
      'cvv': cvv,
    };
  }

}

class Mobil{
  String id;
  String digits;
  String indicatif;
  String title;
  Mobil({required this.id, required this.digits, required this.title, required this.indicatif});

  factory Mobil.fromJson(Map<String, dynamic> json) {
    return Mobil(
      id: json['_id'].toString(),
      digits: json['digits'],
      indicatif: json['indicatif'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'digits': digits,
      'indicatif': indicatif,
      'title': title,
    };
  }
}

class SelectedPayement{
  String id;
  Mobil? mobil;
  CardModel? card;
  SelectedPayement({required this.id, this.mobil, this.card});
  factory SelectedPayement.fromJson(Map<String, dynamic> json) {
    return SelectedPayement(
      id: json['_id'].toString(),
      mobil: json['mobil'] != null && json['mobil'] != '' ? Mobil.fromJson(json['mobil']) : null,
      card: json['card'] != null && json['card'] != ''  ? CardModel.fromJson(json['card']) : null,
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'mobil': mobil?.toJson(),
      'card': card?.toJson(),
    };
  }
}