import 'package:flutter/material.dart';

class SettingsClass {
  Color color =  Color.fromARGB(255,2,124,125);
  Color color_ =  Color.fromARGB(255,1,155,137);
  Color bottunColor =  Color.fromARGB(255,8,131,120);
  Color progressBGC =  Color.fromARGB(255,8,131,120);
  Color noProgressBGC =  Color.fromARGB(255,245,243,240);

  // FontP titlePrimaryFS = FontStyle.normal
  FontWeight titlePrimaryFW = FontWeight.w700;

  // Widget ApartmentCardItem;
}

class ApartmentCard {
  final String imageUrl;
  final String title;
  final String description;
  final String location;
  final String date;
  final String price;
  final double rating;
  final int reviews;
  final int crownPoints;

  ApartmentCard({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.crownPoints,
  });
}
