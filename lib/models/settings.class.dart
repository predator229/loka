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
}

class ApartmentCard {
  int index;
  String imageUrl;
  String title;
  String description;
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

  ApartmentCard({
    required this.index,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.crownPoints,
    required this.devise,
    required this.perPeriod,
    required this.isFavourite,
    required this.typeApartment,
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