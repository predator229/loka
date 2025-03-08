
import 'package:flutter/material.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/models/settings.class.dart';

class ApartementView extends StatefulWidget {
  static const String routeName = '/apartment-item';
  const ApartementView({super.key});

  @override
  State<ApartementView> createState() => _ApartementViewState();
}

class _ApartementViewState extends State<ApartementView> with SingleTickerProviderStateMixin{

  int currentImgIndex = 0;
  bool showMoreDescription = false;
  bool showMoreDescriptionLocation = false;
  bool showMoreEchipment = false;
  bool showMoreServices = false;
  bool _isExpanded = true;

  late BaseAuth auth;

  bool displayAllPicture = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = AuthProviders.of(context).auth;
  }

  @override
  Widget build(BuildContext context) {
    ApartmentCard apartentCard = ModalRoute.of(context)!.settings.arguments as ApartmentCard;
    List<int> nr_room = List<int>.filled(SettingsClass().roomTypes.length, 0, growable: false);
    List<int> nr_amenagements = List<int>.filled(SettingsClass().equipementsType.length, 0, growable: false);

    for (int i = 0; i< SettingsClass().roomTypes.length; i++) {
      for (var j = 0; j < apartentCard.caracteristiques.rooms.length; j++) {
        if (apartentCard.caracteristiques.rooms[j].type.id == SettingsClass().roomTypes[i].id) {
          nr_room[i] += 1;
        }
      }
    }


    int nbrEquipLeft = 0;
    int nbrEquipRigth = 0;

    for (int i = 0; i< SettingsClass().equipementsType.length; i++) {
      if (apartentCard.caracteristiques.equipements != null){
        for (var j = 0; j < apartentCard.caracteristiques.equipements!.length; j++) {
          if (apartentCard.caracteristiques.equipements![j].type.id == SettingsClass().equipementsType[i].id) {
            nr_amenagements[i] += 1;
          }
        }
      }
      if(nr_amenagements[i] >0 && i%2 == 0){ nbrEquipLeft += 1;}
      else{ nbrEquipRigth +=1;  }
    }

    List<ServiceClosest> servicess = showMoreServices ? (apartentCard.caracteristiques.services.length > 2 ? apartentCard.caracteristiques.services.sublist(1, 2) : apartentCard.caracteristiques.services)  : apartentCard.caracteristiques.services;

    return Scaffold(
      body: 
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true, 
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              key: ValueKey("${apartentCard.index}-${apartentCard.date}"),
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                apartentCard.imageUrl[currentImgIndex],
                                height: 270,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 49,
                              right: 20,
                              child: CircleAvatar(
                                backgroundColor: !apartentCard.isFavourite ? Colors.white : Colors.white,
                                child: IconButton(
                                  icon: Icon(Icons.favorite, color: !apartentCard.isFavourite ? Colors.grey : Colors.red,),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                            Positioned(
                              top: 49,
                              left: 20,
                              child: CircleAvatar(
                                backgroundColor: const Color.fromARGB(150, 23, 23, 23),
                                child: IconButton(
                                  icon: Icon(Icons.arrow_back_outlined, color: Colors.white,),
                                  onPressed: (){ Navigator.of(context).pop(); },
                                ),
                              ),
                            ),
                            Positioned(
                              top: 50,
                              right:70,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                height: 40,
                                width: 57,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 244, 247, 226),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset("images/coin.png", width: 15),
                                    Text(
                                      apartentCard.crownPoints.toString(),
                                      style: TextStyle(fontFamily: "Figtree",
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(150, 23, 23, 23),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${currentImgIndex+1}/${apartentCard.imageUrl.length}",
                                  style: TextStyle(fontFamily: "Figtree",
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                         if (!displayAllPicture)
  Row(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      for (int i = 0; i < (apartentCard.imageUrl.length > 4 ? 4 : apartentCard.imageUrl.length); i++)
        InkWell(
          onTap: () {
            setState(() {
              currentImgIndex = i;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: MediaQuery.of(context).size.width / 6 - (currentImgIndex == i ? 8 : 0),
              height: MediaQuery.of(context).size.width / 6 - (currentImgIndex == i ? 8 : 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(apartentCard.imageUrl[i], fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      if (apartentCard.imageUrl.length > 4)
        InkWell(
          onTap: () {
            setState(() {
              displayAllPicture = true;
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 6,
            height: MediaQuery.of(context).size.width / 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 254, 247, 226),
              border: Border.all(color: const Color.fromARGB(255, 254, 226, 104)),
            ),
            child: Center(
              child: Text(
                "+ ${apartentCard.imageUrl.length - 4}",
                style: const TextStyle(fontFamily: "Figtree",fontSize: 22, color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
    ],
  ),
if (displayAllPicture)
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            setState(() {
              displayAllPicture = false;
            });
          },
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.width / 6, // Définit une hauteur pour ListView
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (int i = 0; i < apartentCard.imageUrl.length; i++)
              InkWell(
                onTap: () {
                  setState(() {
                    currentImgIndex = i;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 6 - (currentImgIndex == i ? 8 : 0),
                    height: MediaQuery.of(context).size.width / 6 - (currentImgIndex == i ? 8 : 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(apartentCard.imageUrl[i], fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  ),

                          SizedBox(height: 20),
                          if (apartentCard.nrColoc > 0)
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 245, 245, 245),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(22),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 217, 217, 217),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Icon(Icons.add_home_outlined)
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 22),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Colocataires", style: TextStyle(fontFamily: "Figtree",fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),),
                                          InkWell(
                                            onTap: (){},
                                            child: Text(
                                              "Vous pourrez être dans le même lieu d’appartement avec ${apartentCard.nrColoc} colocataires.",
                                              softWrap: true,
                                              style: TextStyle(fontFamily: "Figtree",
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              border: Border( bottom: BorderSide(color: const Color.fromARGB(255, 233, 233, 233)),),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Caractéristiques", style: TextStyle(fontFamily: "Figtree",fontSize: 20, color: Colors.black, fontWeight:FontWeight.w600),),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (int i = 0; i< SettingsClass().roomTypes.length; i++)
                                    if(nr_room[i] >0)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(SettingsClass().roomTypes[i].icon, color: Colors.black),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${nr_room[i]} ${SettingsClass().roomTypes[i].name}"),
                                                for (var j = 0; j < apartentCard.caracteristiques.rooms.length; j++) 
                                                if (apartentCard.caracteristiques.rooms[j].type.id == SettingsClass().roomTypes[i].id) 
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical:2.0),
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromARGB(23, 8, 131, 120)
                                                    ),
                                                    child: Text(apartentCard.caracteristiques.rooms[j].superficie, style: TextStyle(fontFamily: "Figtree",fontSize: 12, fontWeight: FontWeight.w400, color: SettingsClass().bottunColor),),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.view_array_outlined, color: Colors.black),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Surface de la maison"),
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(23, 8, 131, 120)
                                                  ),
                                                  child: Text(apartentCard.caracteristiques.superficieTotale, style: TextStyle(fontFamily: "Figtree",fontSize: 12, fontWeight: FontWeight.w400, color: SettingsClass().bottunColor),),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              border: Border( bottom: BorderSide(color: const Color.fromARGB(255, 233, 233, 233)),),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Description du domicile", style: TextStyle(fontFamily: "Figtree",fontSize: 20, color: Colors.black, fontWeight:FontWeight.w600),),
                                SizedBox(height: 10),
                                if (!showMoreDescription)
                                Text(
                                  apartentCard.description,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  style: TextStyle(fontFamily: "Figtree",
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (showMoreDescription)
                                Text(
                                  apartentCard.description,
                                  softWrap: true,
                                  style: TextStyle(fontFamily: "Figtree",
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                InkWell(
                                onTap: (){
                                  setState(() { showMoreDescription = !showMoreDescription; });
                                },
                                child: Text( showMoreDescription ? "Lire moins .." :  "Lire plus ...", style: TextStyle(fontFamily: "Figtree",color: SettingsClass().bottunColor, decoration: TextDecoration.underline, decorationColor: SettingsClass().bottunColor, fontSize: 15, fontWeight: FontWeight.w600),),
                                ),
                              ],
                            )
                          ),
                          SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ 
                              Text("Aménagement.s disponible", style: TextStyle(fontFamily: "Figtree",fontSize: 20, color: Colors.black, fontWeight:FontWeight.w600),),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (nbrEquipLeft >= 1)
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        for (int i = 0; i < SettingsClass().equipementsType.length; i++)
                                        if(nr_amenagements[i] >0 && i%2 == 0) //(showMoreEchipment && i)
                                          Padding(
                                            padding: const EdgeInsets.only(right: 40),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(SettingsClass().equipementsType[i].icon, color: Colors.black),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                  child: Text(SettingsClass().equipementsType[i].name,),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (nbrEquipRigth >= 1)
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        for (int i = 0; i < SettingsClass().equipementsType.length; i++)
                                        if(nr_amenagements[i] >0  && i%2 != 0)
                                          Padding(
                                            padding: const EdgeInsets.only(right: 40),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(SettingsClass().equipementsType[i].icon, color: Colors.black),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                  child: Text(SettingsClass().equipementsType[i].name,),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    ],
                                ),
                              ),
                              InkWell(
                                onTap: (){ setState(() { showMoreEchipment = !showMoreEchipment; });},
                                child: Row(
                                  children: [
                                    Text( !showMoreEchipment ? "Voir toutes les aménagements " :  "Voir  moins ...", style: TextStyle(fontFamily: "Figtree",color: SettingsClass().bottunColor, decoration: TextDecoration.underline, decorationColor: SettingsClass().bottunColor, fontSize: 15, fontWeight: FontWeight.w600),),
                                    Icon(!showMoreEchipment ? Icons.arrow_forward : Icons.arrow_back, color: SettingsClass().bottunColor, size: 30,)
                                  ],
                                ),
                                ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color.fromARGB(255, 254, 247, 226),
                                  border: Border.all(color: const Color.fromARGB(255, 254, 226, 104)),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Icon(Icons.group_rounded),
                                    ),
                                    Text("Il y a ${apartentCard.nbrNeightbord} voisins proche de chez vous",),
                                  ],
                                ),
                            ),
                          SizedBox(height: 20,),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Color.fromARGB(60, 239, 225, 159),)
                              )
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            padding: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              border: Border( bottom: BorderSide(color: const Color.fromARGB(255, 233, 233, 233)),),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Localisation du lieu", style: TextStyle(fontFamily: "Figtree",fontSize: 20, color: Colors.black, fontWeight:FontWeight.w600),),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(apartentCard.location, style: TextStyle(fontFamily: "Figtree",fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),),
                                ),
                                if (!showMoreDescriptionLocation && apartentCard.descriptionLocation!.isNotEmpty)
                                Text(
                                  "${apartentCard.descriptionLocation}",
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  style: TextStyle(fontFamily: "Figtree",
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (showMoreDescriptionLocation && apartentCard.descriptionLocation!.isNotEmpty)
                                Text(
                                  "${apartentCard.descriptionLocation}",
                                  softWrap: true,
                                  style: TextStyle(fontFamily: "Figtree",
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (apartentCard.descriptionLocation!.isNotEmpty && !showMoreDescriptionLocation)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: InkWell(
                                  onTap: (){
                                    setState(() { showMoreDescriptionLocation = !showMoreDescriptionLocation; });
                                  },
                                  child: Text( showMoreDescriptionLocation ? "Lire moins .." :  "Lire plus ...", style: TextStyle(fontFamily: "Figtree",color: SettingsClass().bottunColor, decoration: TextDecoration.underline, decorationColor: SettingsClass().bottunColor, fontSize: 15, fontWeight: FontWeight.w600),),
                                  ),
                                ),
                              ],
                            )
                          ),
                          SizedBox(height: 20,),
                          Container(
                            height: 44,
                            decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(8),
                              color: const Color.fromARGB(18, 8, 131, 120),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Voir l’itinéraire", style: TextStyle(fontFamily: "Figtree",color: Color.fromARGB(255,8, 131, 120),),),
                                  Icon(Icons.location_on_sharp, color: SettingsClass().bottunColor, size: 30,),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(8),
                              color: const Color.fromARGB(18, 8, 131, 120),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: InkWell(
                                onTap: (){},
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      child: Image.asset("images/map_loader.png", fit: BoxFit.cover,),
                                    ),
                                    Positioned(
                                      top: 50,
                                      left: MediaQuery.of(context).size.width/3, 
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: 8,bottom: 20,
                                              left: 6, right: 20,
                                              child: Icon(Icons.location_on_rounded, color: SettingsClass().bottunColor, size: 70,),
                                            ),
                                            Positioned(top: 17,bottom: 20,
                                              left: 22, right: 20,
                                              child: Icon(Icons.home, color: Colors.white, size: 35,),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Services à proximité", style: TextStyle(fontFamily: "Figtree",fontSize: 20, color: Colors.black, fontWeight:FontWeight.w600),),
                              SizedBox(height: 10),
                              for (int i=0; i < (apartentCard.caracteristiques.services.length > 2 && !showMoreServices ? 2 : apartentCard.caracteristiques.services.length ) ; i++ )
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${apartentCard.caracteristiques.services[i].name} : ",
                                      style: const TextStyle(fontFamily: "Figtree",fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600,),
                                    ),
                                    Text(
                                      apartentCard.caracteristiques.services[i].description,
                                      softWrap: true,
                                      style: TextStyle(fontFamily: "Figtree",
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          InkWell(
                            onTap: (){
                              setState(() { showMoreServices =!showMoreServices ; });
                            },
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(showMoreServices ? "Voir moins de services proches" : "Voir tous les services proches", style: TextStyle(fontFamily: "Figtree",fontSize: 14, fontWeight: FontWeight.w400),),
                                  Icon(showMoreServices ? Icons.keyboard_arrow_left_outlined : Icons.arrow_forward_ios, color: Colors.black, size: 20,),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              border: Border( bottom: BorderSide(color: const Color.fromARGB(255, 233, 233, 233)),),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Informations de l’annonceur", style: TextStyle(fontFamily: "Figtree",fontSize: 20, fontWeight: FontWeight.w600),),
                              IconButton(
                                onPressed: (){
                                  setState(() { _isExpanded = !_isExpanded; });
                                },
                                icon: Icon(_isExpanded ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined, size: 30,)
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          if (_isExpanded)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 50.0, ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(60, 239, 225, 159),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color.fromARGB(22, 0, 0, 0),
                                  width: 1,
                                )
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all( 20.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SizedBox(
                                          width: 52,
                                          height: 52,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: Image.asset("images/damien.jpeg", width: 52, height: 52,),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Damien le vrai boss",
                                                style: TextStyle(fontFamily: "Figtree",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text("Demarcheur", style: TextStyle(fontFamily: "Figtree",fontSize: 13,overflow: TextOverflow.ellipsis,),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                      Row(
                                        children: [
                                            Icon(Icons.star, color: SettingsClass().bottunColor, size: 30,),
                                            Icon(Icons.star, color: SettingsClass().bottunColor, size: 30,),
                                            Icon(Icons.star, color: SettingsClass().bottunColor, size: 30,),
                                            Icon(Icons.star, color: SettingsClass().bottunColor, size: 30,),
                                            Icon(Icons.star_border, color: Colors.black, size: 30,),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Text("4,5", style: TextStyle(fontFamily: "Figtree",color: Colors.black),),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 248, 234, 154),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text( "Certifié", style: TextStyle(fontFamily: "Figtree", fontWeight: FontWeight.w500, ), ),
                                              Image.asset("images/certificat.jpg", width: 20,)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: BorderDirectional(),
                                          ),
                                          child: Icon(Icons.trending_up_sharp),
                                        ),
                                        Text("  2 456", style: TextStyle(fontFamily: "Figtree",fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700),),
                                        Text("  biens vendus", style: TextStyle(fontFamily: "Figtree",fontSize: 15, color: Colors.black,),),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: InkWell(
                                      onTap: (){
                                        // setState(() { showMoreServices =!showMoreServices ; });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("Prendre un rendez-vous", style: TextStyle(fontFamily: "Figtree",fontSize: 14, fontWeight: FontWeight.w400),),
                                            Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ),
          Container(
            height: 91,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 1),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                      "${apartentCard.price.toString()} ${apartentCard.devise} / ${apartentCard.perPeriod}",
                        style: const TextStyle(fontFamily: "Figtree",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                      "Jusqu'au ${apartentCard.date}",
                      style: TextStyle(fontFamily: "Figtree",
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SettingsClass().bottunColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10), ), 
                    ),
                    child: const Text("Je suis interressé"),
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
    );
  }

}