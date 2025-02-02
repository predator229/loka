import 'package:flutter/material.dart';

class SettingsClass {
  Color color =  Color.fromARGB(255,2,124,125);
  Color color_ =  Color.fromARGB(255,1,155,137);
  Color bottunColor =  Color.fromARGB(255,8,131,120);
  Color progressBGC =  Color.fromARGB(255,8,131,120);
  Color noProgressBGC =  Color.fromARGB(255,245,243,240);
  FontWeight titlePrimaryFW = FontWeight.w700;
  List<TypeApartment> typesApartments = [
    TypeApartment(id: 0, icone: Icons.view_comfortable_outlined, name: "Tous les logements"),
    TypeApartment(id: 1, icone: Icons.home_filled, name: "Chambre salon"),
    TypeApartment(id: 2, icone: Icons.home_work, name: "Appartement meublé"),
    TypeApartment(id: 3, icone: Icons.blinds_closed_outlined, name: "Imeubles a vendre"),
    TypeApartment(id: 4, icone: Icons.local_offer_rounded, name: "Imeubles a vendre"),
  ];
  List<RoomType> roomTypes = [
    RoomType(id: 1, name: 'Chambre', description: "Chambre a couche", icon: Icons.bed_rounded),
    RoomType(id: 2, name: 'Salon', description: "Salon", icon: Icons.chair),
                          
    // RoomType(id: 3, name: 'Jardin', description: "Jardin inclus"),
    // RoomType(id: 3, name: 'Cuisine', description: "Jardin inclus"),
  ];
  List<EquimentType> equipementsType = [
    EquimentType(id: 1, name: 'TV', description: "TV 40", icon: Icons.tv),
    EquimentType(id: 2, name: 'Escalier', description: "Escalier sur deux etages", icon: Icons.wallet_sharp),
    EquimentType(id: 3, name: 'Véranda', description: "Véranda sur 40", icon: Icons.waterfall_chart_sharp),
    EquimentType(id: 4, name: 'Plafond', description: "Plafond en bois massif", icon: Icons.panorama_wide_angle_select_sharp),
    EquimentType(id: 5, name: 'Avec cour', description: "Avec cour", icon: Icons.outdoor_grill_sharp),
    EquimentType(id: 6, name: 'Cuisine', description: "Cuisine americaine", icon: Icons.kitchen_sharp),
    EquimentType(id: 7, name: 'Portail', description: "Portail blinde", icon: Icons.door_back_door),
    EquimentType(id: 8, name: 'Toillettes', description: "Toillettes americaine", icon: Icons.sanitizer_outlined),
    EquimentType(id: 9, name: 'Dégagement', description: "Dégagement", icon: Icons.self_improvement),
    EquimentType(id: 10, name: 'Salle de bain', description: "Toillettes americaine", icon: Icons.bathroom),
    EquimentType(id: 11, name: 'Jardin', description: "Toillettes americaine", icon: Icons.gradient_rounded),
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
  int index;
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
  List<int> typeApartment;
  int nrColoc;
  int nbrNeightbord;
  ApartmentCaracteristique caracteristiques;

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
    required this.typeApartment,
    required this.nrColoc,
    required this.nbrNeightbord,
    required this.caracteristiques,
  });
}

class TypeApartment {
  int id;
  String name;
  IconData icone;

  TypeApartment({
    required this.id,
    required this.name,
    required this.icone,
  });
}

class Room {
  int id;
  String? moreinformation;
  String superficie;
  RoomType type;
  Room({required this.id, this.moreinformation, required this.superficie, required this.type});
}

class RoomType {
  int id;
  String name;
  String? description;
  IconData? icon;
  RoomType({required this.id, this.description, required this.name, this.icon});
}

class ApartmentCaracteristique {
  int id;
  List<Room> rooms;
  String superficieTotale;
  List<ApartementEquipement>? equipements;
  List<ServiceClosest> services;
  ApartmentCaracteristique ({ required this.id, required this.rooms, required this.superficieTotale, this.equipements, required this.services});
}

class ApartementEquipement{
  int id;
  String? moreinformation;
  String? superficie;
  EquimentType type;
  ApartementEquipement({required this.id, this.moreinformation, this.superficie, required this.type});

}
class EquimentType {
  int id;
  String name;
  String? description;
  IconData? icon;
  EquimentType({this.description, required this.id, this.icon, required this.name});
}

class ServiceClosest {
  int id;
  String name;
  String description;

  ServiceClosest({required this.id, required this.description, required this.name});
}