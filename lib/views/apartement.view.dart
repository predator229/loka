
import 'package:flutter/material.dart';
import 'package:loka/models/settings.class.dart';

class ApartementView extends StatefulWidget {
  static const String routeName = '/apartment-item';
  const ApartementView({super.key});

  @override
  State<ApartementView> createState() => _ApartementViewState();
}

class _ApartementViewState extends State<ApartementView> {

  bool _isExpanded = true;
  @override
  Widget build(BuildContext context) {
    ApartmentCard apartentCard = ModalRoute.of(context)!.settings.arguments as ApartmentCard;
    return Scaffold(
      // appBar: AppBar(
      //   leading: Container(
      //     padding: EdgeInsets.only(left: 20),
      //     decoration: BoxDecoration(
      //       color:  Color.fromARGB(39, 255, 255, 255),
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     child: IconButton(
      //       onPressed: (){ Navigator.of(context).pop(); },
      //       icon: Icon(Icons.cancel, color: Colors.grey, size: 41),
      //     ),
      //   ),
      //   title: Text('Détails de la demande', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      // ),
      body: 
      Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          key: ValueKey("${apartentCard.index}-${apartentCard.date}"),
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            apartentCard.imageUrl,
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
                      ],
                    ),
                  ],
                ),
              ),
          ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 10,),
                    Stack(
                      children: [
                        ClipRRect(
                          key: ValueKey("${apartentCard.index}-${apartentCard.date}"),
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            apartentCard.imageUrl,
                            height: 267,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            backgroundColor: !apartentCard.isFavourite ? Colors.white : Colors.white,
                            child: IconButton(
                              icon: Icon(Icons.favorite, color: !apartentCard.isFavourite ? Colors.grey : Colors.red,),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        Positioned(
                          top: 100,
                          bottom: 100,
                          right: 8,
                          child: CircleAvatar(
                            backgroundColor: const Color.fromARGB(150, 23, 23, 23),
                            child: IconButton(
                              icon: Icon(Icons.arrow_forward_outlined, color: Colors.white, ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        Positioned(
                          top: 100,
                          bottom: 100,
                          left: 8,
                          child: CircleAvatar(
                            backgroundColor: const Color.fromARGB(150, 23, 23, 23),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_outlined, color: Colors.white,),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(150, 23, 23, 23),
                            ),
                            child: Text(
                              "1/8",
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
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Informations de l’annonceur", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
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
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 17),
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
          ),
        ],
      ),
    );
  }

}