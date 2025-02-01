
import 'package:flutter/material.dart';
import 'package:loka/models/settings.class.dart';

class ApartementView extends StatefulWidget {
  static const String routeName = '/apartment-item';
  const ApartementView({super.key});

  @override
  State<ApartementView> createState() => _ApartementViewState();
}

class _ApartementViewState extends State<ApartementView> {

  int currentImgIndex = 0;
  bool showMoreDescription = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ApartmentCard apartentCard = ModalRoute.of(context)!.settings.arguments as ApartmentCard;
    List<int> nr_room = List<int>.filled(SettingsClass().roomTypes.length, 0, growable: false);
    for (int i = 0; i< SettingsClass().roomTypes.length; i++) {
      for (var j = 0; j < apartentCard.caracteristiques.rooms.length; j++) {
        if (apartentCard.caracteristiques.rooms[j].type.id == SettingsClass().roomTypes[i].id) {
          nr_room[i] += 1;
        }
      }
    }

    return Scaffold(
      body: 
      Column(
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
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
                          child: Image.network(
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
                                  style: TextStyle(
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
                              style: TextStyle(
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
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                  shrinkWrap: true, 
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for (int i =0; i < (apartentCard.imageUrl.length > 4 ? 4 : apartentCard.imageUrl.length); i++)
                        InkWell(
                          onTap: () { setState(() { currentImgIndex = i; }); },
                          child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Container(
                            width: MediaQuery.of(context).size.width/6 - (currentImgIndex == i ? 8 : 0),
                            height: MediaQuery.of(context).size.width/6 - (currentImgIndex == i ? 8 : 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(apartentCard.imageUrl[i], fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                        if (apartentCard.imageUrl.length > 4)
                        Container(
                          width: MediaQuery.of(context).size.width/6,
                          height: MediaQuery.of(context).size.width/6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color.fromARGB(255, 254, 247, 226),
                            border: Border.all(color: const Color.fromARGB(255, 254, 226, 104)),
                          ),
                          child: Center(child: Text("+ ${apartentCard.imageUrl.length - 4}", style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w700),)),
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
                                    Text("Colocataires", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),),
                                    InkWell(
                                      onTap: (){},
                                      child: Text(
                                        "Vous pourrez être dans le même lieu d’appartement avec ${apartentCard.nrColoc} colocataires.",
                                        softWrap: true,
                                        style: TextStyle(
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
                          Text("Caractéristiques", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight:FontWeight.w600),),
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
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(23, 8, 131, 120) //background: rgba(8, 131, 120, 0.09);
                                            ),
                                            child: Text(apartentCard.caracteristiques.rooms[j].superficie, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: SettingsClass().bottunColor),),
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
                                              color: const Color.fromARGB(23, 8, 131, 120) //background: rgba(8, 131, 120, 0.09);
                                            ),
                                            child: Text(apartentCard.caracteristiques.superficie, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: SettingsClass().bottunColor),),
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
                          Text("Description du domicile", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight:FontWeight.w600),),
                          SizedBox(height: 10),
                          if (!showMoreDescription)
                          Text(
                            apartentCard.description,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (showMoreDescription)
                          Text(
                            apartentCard.description,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          InkWell(
                          onTap: (){
                            setState(() { showMoreDescription = !showMoreDescription; });
                          },
                          child: Text( showMoreDescription ? "Lire moins .." :  "Lire plus ...", style: TextStyle(color: SettingsClass().bottunColor, decoration: TextDecoration.underline, decorationColor: SettingsClass().bottunColor, fontSize: 15, fontWeight: FontWeight.w600),),
                          ),
                        ],
                      )
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(60, 239, 225, 159),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
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
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text("Demarcheur", style: TextStyle(fontSize: 13,overflow: TextOverflow.ellipsis,),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: (){},
                                child: Row(
                                  children: [
                                    Icon(Icons.star, color: SettingsClass().bottunColor, size: 30,),
                                    Icon(Icons.star, color: SettingsClass().bottunColor, size: 30,),
                                    Icon(Icons.star, color: SettingsClass().bottunColor, size: 30,),
                                    Icon(Icons.star, color: SettingsClass().bottunColor, size: 30,),
                                    Icon(Icons.star_border, color: Colors.black, size: 30,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text("4,5", style: TextStyle(color: Colors.black),),
                                    ),
                                  ],
                                )
                              ),
                              Container(
                                width: 93,
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 248, 234, 154),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text( "Certifié", style: TextStyle( fontWeight: FontWeight.w500, ), ),
                                    Image.asset("images/certificat.jpg", width: 20,)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 17),
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
                                Text("  2 456", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700),),
                                Text("  biens vendus", style: TextStyle(fontSize: 15, color: Colors.black,),),
                              ],
                            ),
                          ),
                        ],
                      ),
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