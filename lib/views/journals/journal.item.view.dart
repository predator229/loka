import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/models/settings.class.dart';
import 'package:loka/views/apartement.view.dart';

class JournalItem extends StatefulWidget {
  static const String routeName = '/journal-item';
  const JournalItem({super.key});

  @override
  State<JournalItem> createState() => _JournalItemState();
}

class _JournalItemState extends State<JournalItem> with SingleTickerProviderStateMixin {

  late BaseAuth auth;
  bool _isExpanded = true;
  int currentImage = 0;

  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        auth = AuthProviders.of(context).auth;
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = AuthProviders.of(context).auth;
  }

  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    if (args == null) { return const Text('No data');}
    if (args['journal'] == null) { return const Text('No data');}
    if (args['typeJ'] == null) { return const Text('No data');}
    JournalCard journalCard = args['journal'] as JournalCard;
    dynamic activJournal = args['typeJ'];
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color:  Color.fromARGB(39, 255, 255, 255),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: (){ Navigator.of(context).pop(); },
            icon: Icon(Icons.cancel, color: Colors.grey, size: 41),
          ),
        ),
        title: Text('Détails de la demande', style: TextStyle(fontFamily: "Figtree",fontSize: 20, fontWeight: FontWeight.w600)),
      ),
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:20),
          child: ListView(
            children: [
              SizedBox(height: 10,),
              Stack(
                children: [
                  ClipRRect(
                    key: ValueKey("${journalCard.index}-${journalCard.date}"),
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      journalCard.apartmentCard.imageUrl[currentImage],
                      height: 267,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: !journalCard.apartmentCard.isFavourite ? Colors.white : Colors.white,
                      child: IconButton(
                        icon: Icon(Icons.favorite, color: !journalCard.apartmentCard.isFavourite ? Colors.grey : Colors.red,),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  if (currentImage < (journalCard.apartmentCard.imageUrl.length - 1))
                  Positioned(
                    top: 100,
                    bottom: 100,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(150, 23, 23, 23),
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward_outlined, color: Colors.white, ),
                        onPressed: () {
                          setState(() { currentImage += 1; });
                        },
                      ),
                    ),
                  ),
                  if (currentImage >0)
                  Positioned(
                    top: 100,
                    bottom: 100,
                    left: 8,
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(150, 23, 23, 23),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_outlined, color: Colors.white,),
                        onPressed: () {
                          setState(() { currentImage -= 1; });
                        },
                      ),
                    ),
                  ),
                  // if (currentImage == 0)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(150, 23, 23, 23),
                      ),
                      child: Text(
                        "${currentImage+1}/${journalCard.apartmentCard.imageUrl.length}",
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
              SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 17),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 249, 249, 249),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      journalCard.apartmentCard.title,
                      style: TextStyle(fontFamily: "Figtree",
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(journalCard.apartmentCard.location),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "${journalCard.apartmentCard.price.toString()} ${journalCard.apartmentCard.devise} / ${journalCard.apartmentCard.perPeriod}",
                          style: const TextStyle(fontFamily: "Figtree",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          width: 93,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                          decoration: BoxDecoration(
                            color: activJournal['type'] == 0 ? Color.fromARGB (138, 255, 30, 23) : ( activJournal['type'] == 1 ? Color.fromARGB(137, 255, 193, 23) : Color.fromARGB(137, 23, 255, 185) ),
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                activJournal['title'],
                                style: TextStyle(fontFamily: "Figtree",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextButton(
                          onPressed: (){
                            if (auth.userAuthentificate.coins <= journalCard.apartmentCard.crownPoints){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vous n'avez pas assez de pièces pour voir cet appartement. Veuillez recharger votre compte.")));
                              return;
                            }
                            setState(() { auth.userAuthentificate.coins -= journalCard.apartmentCard.crownPoints; });
                            Navigator.of(context).pushNamed(ApartementView.routeName, arguments: journalCard.apartmentCard);
                          },
                          child: Row(
                            children: [
                              Text("Voir tous les detaills", style: TextStyle(fontFamily: "Figtree",color: SettingsClass().bottunColor),),
                              Icon(Icons.arrow_forward, color: SettingsClass().bottunColor, size: 30,)
                            ],
                          )
                        ),
                        TextButton(
                          onPressed: (){},
                          child: Text("Annuler", style: TextStyle(fontFamily: "Figtree",color: const Color.fromARGB(255, 70, 57, 57)),),

                        ),
                      ],
                    ),
                  ],
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
    );
  }
}