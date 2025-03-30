import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loka/controllers/apis.controller.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
import 'package:loka/controllers/root.page.controller.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/models/settings.class.dart';
import 'package:intl/intl.dart';
import 'package:loka/views/apartement.view.dart';
import 'package:loka/views/filter.view.dart';
import 'package:loka/views/journals/journal.item.view.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/home';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {

  bool imLoading = false;
  late double evoluatingWidth;
  late bool homePageSee = false;
  late Timer _timer;
  late BaseAuth auth;
  List<String> typesournals = [
    'waiting',
    'accepted',
    'confirmed',
  ];
  List journals = [
    {
      'id': 1,
      'title': 'En attente',
      'type' : 0,
      'selected' : true,
    },
    {
      'id': 2,
      'title': 'Acceptees',
      'type' : 1,
      'selected' : false,
    },
    {
      'id': 3,
      'title': 'Validees',
      'type' : 2,
      'selected' : false,
    }
  ];

  TextEditingController _searchController = TextEditingController();
  late List<TypeApartment> typesApartments =[];

  late TypeApartment _selectedType;
  String _selectedTypeJournal ='';
  late dynamic activJournal;

  late List<ApartmentCard> apartments = [];

late List<JournalCard> journalCards = [];

  late List<ApartmentCard> apartmentsFiltered;
  late List<JournalCard> journalCardFiltered;
  late List<ApartmentCard> apartmentsFoavorite;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    evoluatingWidth = 0.0;
    apartmentsFiltered = [];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _startProgressAnimation();
      typesApartments = auth.typesApartments.isNotEmpty ? auth.typesApartments : SettingsClass().typesApartments;
      _selectedType = SettingsClass().typesApartments[0];
      apartments = auth.apartmentCard.isNotEmpty ? auth.apartmentCard : [];
      if (apartments.isEmpty){
          imLoading = true; 
          await _loadApartments(context);
          imLoading = false; 
          _selectedType = typesApartments[0];
            iJustLoadApartment;
      }
      apartmentsFiltered = apartments;
    });
  }

  iJustLoadApartment () {
    letFilterJournal();
    letFavoriteTheApartments();
  }

  void _startProgressAnimation() {
    final maxSize = MediaQuery.of(context).size.width - 50;
    const increment = 20.0;
    const duration = Duration(milliseconds: 500);

    auth = AuthProviders.of(context).auth;
    homePageSee = !(auth.userAuthentificate.new_user == 1);

    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        evoluatingWidth += increment;
        if (evoluatingWidth >= maxSize) {
          evoluatingWidth = maxSize;
          homePageSee = true;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = AuthProviders.of(context).auth;
    homePageSee = !(auth.userAuthentificate.new_user == 1);
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _startProgressAnimation();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return homePageSee ? homePage() : (MediaQuery.of(context).orientation == Orientation.portrait ? firstConnection() : firstConnectionLandScap());
  }

  Widget firstConnection() {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("images/pound.gif", width: 200),
                  Column(
                    children: [
                      Text(
                        "Félicitations",
                        style: TextStyle(fontFamily: "Figtree",
                            fontSize: 30,
                            color: const Color.fromARGB(255, 11, 11, 11)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "1000 pièces ",
                            style: TextStyle(fontFamily: "Figtree",
                                fontSize: 30, color: SettingsClass().color),
                          ),
                          Text(
                            "offert !",
                            style: TextStyle(fontFamily: "Figtree",
                                fontSize: 30,
                                color: const Color.fromARGB(255, 11, 11, 11)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Bienvenu sur Loka, nous vous offrons 1000 pièces pour vos différents parcours sur Loka.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "Figtree",color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: 5,
                    width: evoluatingWidth,
                    decoration: BoxDecoration(
                      color: SettingsClass().color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        homePageSee = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SettingsClass().bottunColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Aller à l\'accueil'),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget firstConnectionLandScap() {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Image.asset("images/pound.gif", width: 20),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      Text(
                        "Félicitations",
                        style: TextStyle(fontFamily: "Figtree",
                            fontSize: 30,
                            color: const Color.fromARGB(255, 11, 11, 11)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "1000 pièces ",
                            style: TextStyle(fontFamily: "Figtree",
                                fontSize: 30, color: SettingsClass().color),
                          ),
                          Text(
                            "offert !",
                            style: TextStyle(fontFamily: "Figtree",
                                fontSize: 30,
                                color: const Color.fromARGB(255, 11, 11, 11)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Bienvenu sur Loka, nous vous offrons 1000 pièces pour vos différents parcours sur Loka.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "Figtree",color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: 5,
                        width: evoluatingWidth,
                        decoration: BoxDecoration(
                          color: SettingsClass().color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            homePageSee = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SettingsClass().bottunColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Aller à l\'accueil'),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget homePage() {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_sharp), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_rounded), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Journal'),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_outlined),
              label: 'Profil'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: SettingsClass().bottunColor,
        onTap: (index) { setState(() { _currentIndex = index; });},
      ),
      body: _buildCurrentPage(),
    );
  }

  _buildCurrentPage (){
    Widget toReturn = Container();
    switch (_currentIndex) {
      case 0: toReturn = MediaQuery.of(context).orientation == Orientation.portrait ? _buildHomePagePortrait() :_buildHomePageLandScape(); break;
      case 1: toReturn = _buildFavoritePage(); break;
      case 2: toReturn = _buildJournal(); break;
      case 3: toReturn = MediaQuery.of(context).orientation == Orientation.portrait ? _buildProfilPortrait() :  _buildProfilLandScape(); break;

    }
    return toReturn;
  }

  // Wifgets
   Widget _buildHomePagePortrait (){
    return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildHead (),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: typesApartments.length,
                itemBuilder: (context, index) {
                  return _buildFilter(typesApartments[index]);
                },
              ),
            ),
          ),
          Expanded(
            child:  imLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: SettingsClass().bottunColor,
                  ),
                )
              : ( apartments.isEmpty 
                ? Center(
                  child: Container(
                    child: Text("Pas d'apartements disponibles, Rafraichissez la page"),
                  ),
                )
                : _builderLandScapeHome(apartmentsFiltered)),
          ),
        ],
      );
  }

     Widget _buildHomePageLandScape (){
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true, 
              children:[
                _buildHead (),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                  child: SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: typesApartments.length,
                      itemBuilder: (context, index) {
                        return _buildFilter(typesApartments[index]);
                      },
                    ),
                  ),
                ),
                Expanded(
            child:  imLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: SettingsClass().bottunColor,
                  ),
                )
              : ( apartments.isEmpty 
                ? Center(
                  child: Container(
                    child: Text("Pas d'apartements disponibles, Rafraichissez la page"),
                  ),
                )
                : _builderLandScapeHome(apartmentsFiltered)),
          ),
              ],
            ),
          ),
        ],
      );
    }

  Widget _buildFavoritePage (){
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
            child: Row(
              children: [ Text( "Favoris", style: TextStyle(fontFamily: "Figtree", fontSize: 36, fontWeight: FontWeight.bold ),), ],
            ),
          ),
          // Expanded(
          //   child: ListView.builder(
          //     padding: EdgeInsets.zero,
          //     shrinkWrap: true, 
          //     itemCount: apartmentsFoavorite.length,
          //     itemBuilder: (context, index) {
          //       return Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 20.0),
          //         child: InkWell(
          //           onTap: (){
          //             if (auth.userAuthentificate.coins <= apartmentsFiltered[index].crownPoints){
          //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vous n'avez pas assez de pièces pour voir cet appartement. Veuillez recharger votre compte.")));
          //               return;
          //             }
          //             setState(() { auth.userAuthentificate.coins -= apartmentsFiltered[index].crownPoints; });
          //             Navigator.of(context).pushNamed(ApartementView.routeName, arguments: apartmentsFoavorite[index]);
          //           },
          //           child: _buildApartmentItem(apartmentsFoavorite[index]),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

Widget _buildJournal() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
              child: Row(
                children: [ Text( "Journal", style: TextStyle(fontFamily: "Figtree", fontSize: 36, fontWeight: FontWeight.bold ),), ],
              ),
            ),
            // Expanded(
            //   flex: 1,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
            //     child: ListView(
            //       scrollDirection: Axis.horizontal,
            //       children: journals.map((journal) {
            //         return ElevatedButton(
            //             style: ElevatedButton.styleFrom(
            //             backgroundColor: journal['selected'] ? SettingsClass().bottunColor : Colors.white,
            //             foregroundColor: journal['selected'] ? Colors.white : Colors.black,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(30),
            //               side: BorderSide.none,
            //             ),
            //             padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            //             ),
            //           onPressed: (){
            //             setState(() {
            //               journals.forEach((element) {
            //                 element['selected'] = false;
            //                 if (element['id'] == journal['id']) {element['selected'] = true;}
            //                 _selectedTypeJournal = journal['type'];
            //                 activJournal = journal;
            //                 letFilterJournal();
            //               });
            //             });
            //           },
            //           child: Text( journal['title'], ),
            //         );
            //       }).toList(),
            //     ),
            //   ),
            // ),
            // Expanded(
            //   flex: 8,
            //   child: ListView.builder(
            //     itemCount: journalCardFiltered.length,
            //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
            //     itemBuilder: (context, index) {
            //       var journal = journalCardFiltered[index];
            //       return  InkWell(
            //         onTap: (){
            //           Navigator.of(context).pushNamed(JournalItem.routeName, arguments: {'journal':journal, 'typeJ':activJournal});
            //         },
            //         child: Container(
            //           padding: EdgeInsets.symmetric(vertical: 50),
            //           decoration: BoxDecoration(
            //             border: Border(bottom: BorderSide(color: Colors.grey)),
            //           ),
            //           child: Row(
            //             mainAxisSize: MainAxisSize.max,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Stack(
            //                 children: [
            //                 ClipRRect(
            //                   key: ValueKey("${journal.index}-${journal.date}"),
            //                     borderRadius: BorderRadius.circular(8),
            //                     child: Image.asset(
            //                       journal.apartmentCard.imageUrl[0],
            //                       height: 93,
            //                       width: 93,
            //                       fit: BoxFit.cover,
            //                     ),
            //                   ),
            //                   Positioned(
            //                     bottom: 0,
            //                     child: Container(
            //                       width: 93,
            //                       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
            //                       decoration: BoxDecoration(
            //                         color: _selectedTypeJournal == 0 ? Color.fromARGB (138, 255, 30, 23) : ( _selectedTypeJournal == 1 ? Color.fromARGB(137, 255, 193, 23) : Color.fromARGB(137, 23, 255, 185) ),
            //                         borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
            //                       ),
            //                       child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                         mainAxisSize: MainAxisSize.max,
            //                         children: [
            //                           Text(
            //                             activJournal['title'],
            //                             style: TextStyle(fontFamily: "Figtree",
            //                               fontWeight: FontWeight.w500,
            //                               color: Colors.white,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               SizedBox(width: 20,),
            //               Column(
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(journal.apartmentCard.title, style: TextStyle(fontFamily: "Figtree",fontWeight: FontWeight.w700, fontSize: 20),),
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.start,
            //                     mainAxisSize: MainAxisSize.max,
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       for(int i = 0; i < 1; i++) //journal.apartmentCard.typeApartment.length
            //                       Padding(
            //                         padding: const EdgeInsets.only(right: 8),
            //                         child: Container(
            //                             padding: const EdgeInsets.all(8),
            //                             decoration: BoxDecoration(
            //                               borderRadius: BorderRadius.circular(8),
            //                               border: Border.all( color: Colors.transparent),
            //                               color: Color.fromARGB(255, 245, 245, 245),
            //                             ),
            //                             child: Text(typesApartments[journal.apartmentCard.typeApartment[i]].name, style: TextStyle(fontFamily: "Figtree",fontWeight: FontWeight.w500, fontSize: 14),),
            //                         ),
            //                       ),
            //                     ]
            //                   ),
            //                   Text(journal.apartmentCard.location, style: TextStyle(fontFamily: "Figtree",fontWeight: FontWeight.w500, )),
            //                   Text(journal.date, style: TextStyle(fontFamily: "Figtree",fontWeight: FontWeight.w500, color: Colors.grey)),
            //                 ],
            //               )
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

Widget _buildItemList (ProfilMenu profil) {
  return profil.routeName != null ?
  InkWell(
    onTap: () { 
      if (profil.routeName != null) { Navigator.of(context).pushNamed(profil.routeName!); }
    },
    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              if (profil.icon != null)
              Icon(profil.icon, size: 24,),
              if (profil.icon != null)
              SizedBox(width: 10),
              Text(profil.title, style: TextStyle(fontFamily: "Figtree",fontWeight: FontWeight.w500, fontSize: 16),),
            ],
          ),
          if (profil.icon != null)
          Icon(Icons.arrow_forward_ios_sharp)
        ],
      ),
  ) :
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (profil.icon != null)
        Row(
          children: [
            Icon(profil.icon, size: 24,),
            SizedBox(width: 10),
            Text(profil.title, style: TextStyle(fontFamily: "Figtree",fontWeight: FontWeight.w500, fontSize: 16),),
          ],
        ),
        if (profil.isLogout !=null)
        InkWell(
          onTap: () {
             auth.signOut();
             Navigator.of(context).pushReplacementNamed(RoutePage.routeName);
           },
          child: Text(profil.title, style: TextStyle(fontFamily: "Figtree",fontWeight: FontWeight.w500, fontSize: 16, decoration: TextDecoration.underline, color: Color.fromARGB(255, 116, 116, 116)),),
        ),
        if (profil.icon != null)
        Icon(Icons.arrow_forward_ios_sharp)
      ],
    );

}

  Widget _buildProfilPortrait() {
     return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildHeadProfile (),
          SizedBox(height: 30,),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true, 
              itemCount: SettingsClass().profilsMenu.length,
              itemBuilder: (context, index) {
                var item = SettingsClass().profilsMenu[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: _buildItemList (item),
                );
              },
            ),
          ),
        ],
      );
  }
    Widget _buildProfilLandScape (){
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true, 
              children:[
                _buildHeadProfile (),
                SizedBox(height: 30,),
                for (var item in SettingsClass().profilsMenu)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: _buildItemList (item),
                ),
                ],
            ),
          ),
        ],
      );
    }

  Stack _buildHeadProfile(){
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.width*2/3 > 280 ? 280 : MediaQuery.of(context).size.width*2/3) +50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 91, 168, 151),
                Color.fromARGB(255, 8, 131, 120),
                // Color.fromARGB(85, 8, 131, 120),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(36)),
          ),
        ),
        Positioned(
          top: 70,
          right: 10,
          child: Container(
            width: MediaQuery.of(context).size.width*2/3 + 100,
            height: (MediaQuery.of(context).size.width*2/3 > 277 ? 277 : MediaQuery.of(context).size.width*2/3) + 100,
            decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(0, 8, 131, 120),
                Color.fromARGB(255, 8, 131, 120),
                // Color.fromARGB(85, 8, 131, 120),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
              shape: BoxShape.circle,
              ),
          ),
        ),
        Positioned(
          top: 50,
          left: -100,
          child: Container(
            width: MediaQuery.of(context).size.width*2/3 + 100,
            height: (MediaQuery.of(context).size.width*2/3 > 277 ? 277 : MediaQuery.of(context).size.width*2/3) + 100,
            decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(0, 8, 131, 120),
                Color.fromARGB(255, 8, 131, 120),
                // Color.fromARGB(85, 8, 131, 120),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
              shape: BoxShape.circle,
          ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
          ),
          child: Padding(
            padding: const EdgeInsets.only( top: 66.0, left: 20, right: 20, bottom: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profile',
                      style: TextStyle(fontFamily: "Figtree",
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                        children: [
                        Container(
                            width: MediaQuery.of(context).size.width / 3 > 140 ? 140 : MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.width / 3 > 140 ? 140 : MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 255, 255, 255),
                                  Color.fromARGB(255, 153, 193, 121500),
                                  // Color.fromARGB(85, 8, 131, 120),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                width: 5,
                                color: Colors.transparent,
                              ),
                            ),
                            child: ClipOval(
                              child: auth.userAuthentificate.imgPath != null ? Image.network(
                                auth.userAuthentificate.imgPath ?? '',
                                width: MediaQuery.of(context).size.width / 3 > 140 ? 140 : MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.width / 3 > 140 ? 140 : MediaQuery.of(context).size.width / 3,
                                fit: BoxFit.cover,
                              ) : Image.asset(
                                "images/damien.jpeg",
                                width: MediaQuery.of(context).size.width / 3 > 140 ? 140 : MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.width / 3 > 140 ? 140 : MediaQuery.of(context).size.width / 3,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ),
                        Text(
                          auth.userAuthentificate.name ?? '',
                          style: TextStyle(fontFamily: "Figtree",
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          auth.userAuthentificate.typeUser.title ?? '',
                          style: TextStyle(fontFamily: "Figtree",
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    ],
    );
  }
  Stack _buildHead (){
    return  Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: SettingsClass().bottunColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset("images/icon_loka_white.png",
                            width: 20),
                        const SizedBox(width: 5),
                        const Text(
                          'Loka',
                          style: TextStyle(fontFamily: "Figtree",
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                const Color.fromARGB(39, 255, 255, 255),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications_none_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0),
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 255, 246, 204),
                                Color(0xFFF6CCA3)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            children: [
                              Image.asset("images/coin.png", width: 20),
                              const SizedBox(width: 10),
                              Text(
                                '${auth.userAuthentificate.coins}',
                                style: TextStyle(fontFamily: "Figtree",
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(48, 255, 255, 255),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextFormField(
                          controller: _searchController,
                          style: const TextStyle(fontFamily: "Figtree",
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.pin_drop_outlined,
                              color: Colors.white,
                              size: 25,
                            ),
                            hintText: 'Chercher dans une ville',
                            hintStyle: TextStyle(fontFamily: "Figtree",color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          // color: const Color.fromARGB(48, 255, 255, 255),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(FilterView.routeName);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.filter_list_alt,
                                color: Colors.white,
                                size: 25,
                              ),
                              const Text("Filtrer",
                                  style: TextStyle(fontFamily: "Figtree",color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    ],
    );
  }
  Widget _buildApartmentItem (ApartmentCard itemApartment){ 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                itemApartment.imageUrl[0],
                height: 267,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                height: 33,
                width: 57,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 244, 247, 226),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset("images/coin.png", width: 15),
                    Text(
                      itemApartment.crownPoints.toString(),
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
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: !itemApartment.isFavourite ? Colors.black : Colors.white,
                child: IconButton(
                  icon: Icon(Icons.favorite, color: !itemApartment.isFavourite ? Colors.white : Colors.red,),
                  onPressed: () {
                    setState(() { 
                      for (int i=0; i < apartments.length; i++){
                        if ( apartments[i].index == itemApartment.index){
                          apartments[i].isFavourite  =  !itemApartment.isFavourite;
                          letFavoriteTheApartments();
                          break;
                        }
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemApartment.title,
                style: const TextStyle(fontFamily: "Figtree",
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                itemApartment.description,
                style: TextStyle(fontFamily: "Figtree",
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: SettingsClass().bottunColor, size:12),
                      const SizedBox(width: 4),
                      Text(
                        itemApartment.location,
                        style: TextStyle(fontFamily: "Figtree",
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_month_outlined, color: SettingsClass().bottunColor, size:12),
                      const SizedBox(width: 4),
                      Text(
                        "Jusqu'au ${_formatDate(itemApartment.date)}",
                        style: TextStyle(fontFamily: "Figtree",
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(   NumberFormat.currency(locale: 'fr_FR', symbol: itemApartment.devise, decimalDigits: 0).format(itemApartment.price),
                        style: const TextStyle(fontFamily: "Figtree",
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Text( itemApartment.perPeriod,
                      //   style: const TextStyle(fontFamily: "Figtree",
                      //     fontSize: 10,
                      //   ),
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        itemApartment.rating.toStringAsFixed(1),
                        style: const TextStyle(fontFamily: "Figtree",fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        ' (${itemApartment.reviews.toString()} avis)',
                        style: TextStyle(fontFamily: "Figtree",
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.star_outline, color: SettingsClass().color, size: 14),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),
      ],
    );
  }
  
  Widget _buildFilter (TypeApartment typeArp){
    return Row(
      children: [
        Container(
          height: 40,
          padding:
              const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all( color: _selectedType.id == typeArp.id ?  Colors.transparent : Colors.grey,),
            color: _selectedType.id == typeArp.id ?  SettingsClass().bottunColor : Colors.transparent,
          ),
          child: TextButton(
            onPressed: (){
              setState(() { _selectedType = typeArp;letFilterTheApartments();});
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  typeArp.icone,
                  color: _selectedType.id == typeArp.id ?  Colors.white : Colors.grey,
                  size: 25,
                ),
                const SizedBox(width: 5),
                Text(typeArp.name,style: TextStyle(fontFamily: "Figtree",color: _selectedType.id == typeArp.id ?  Colors.white : Colors.grey)),
              ],
            ),
          ),
        ),
        SizedBox(width: 10,),
      ],
    );
  }

  letFilterTheApartments () {
    setState(() {
      apartmentsFiltered = apartments;
      apartmentsFiltered = _selectedType.id == 0 ? apartments 
      : apartments.where((element) => element.typeApartment!.any((type) => type.id == _selectedType.id)).toList();
    });
  }
  letFavoriteTheApartments () {
    setState(() {
      apartmentsFoavorite = apartments.where((element) => element.isFavourite).toList();
    });
  }
  letFilterJournal () {
    setState(() {
      journalCardFiltered = journalCards.where( (journal) => journal.status == _selectedTypeJournal).toList();
    });
  }

    Future<void> _loadApartments (BuildContext context) async {
      try {
        ApiController api = ApiController();
        final user = FirebaseAuth.instance.currentUser;
        var datas = {
          'uid': user?.uid ?? '',
            if (apartments.isNotEmpty) 'without': apartments.map((element) => element.index).toList(),
        };

        dynamic response = await api.post('apartments/get-apartments', datas.cast<String, dynamic>());

        if (response == null) {
          _handleAuthError(context);
        }

        if (response['error'] != null && response['error'] != 0) {
          SnackBar(content: Text(response['message'] ?? 'Une erreur est survenue. Veuillez reesayer !'));
        }

        if (response['user'] == null) { _handleAuthError(context); }
        setState(() { auth.userAuthentificate = UserAuthentificate.fromJson(response['user']); });
        if (response['posts'] != null) {
          if (response['posts'] != null && response['posts'] is List) {
            List<ApartmentCard> apartmentsGot = []; 
            for (var elmt in response['posts']){ apartmentsGot.add(ApartmentCard.fromJson(elmt)); } 
            setState(() {
              apartments = apartmentsGot + apartments;
              auth.apartmentCard = apartments;
              apartmentsFiltered = apartments;
            });
            iJustLoadApartment();
            letFilterTheApartments(); 
          }
        }
        // if (response['typesApartments'] != null && response['typesApartments'] is List) {
        //   List<TypeApartment> types = []; 
        //   for (var elmt in response['typesApartments']){ types.add(TypeApartment.fromJson(elmt)); } 
        //   setState(() {
        //     typesApartments = types;
        //     auth.typesApartments = typesApartments;
        //   });
        // }
      SnackBar(content: Text('Réponse inattendue du serveur.'));
    } catch (e) { 
      // _handleAuthError(context);
      print("Erreur lors du chargement des appartements : $e");
    } 
    finally {}
  }

  void _handleAuthError(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Une erreur est survenue. Veuillez vous reconnecter.')),
    );
    final auth = AuthProviders.of(context).auth;
    await auth.signOut(); // Déconnexion de Firebase
    Navigator.of(context).pushReplacementNamed(RoutePage.routeName);
  }
  
Widget _builderLandScapeHome(List<ApartmentCard> filteredApartment) {
  return RefreshIndicator(
    onRefresh: () async {
      await _loadApartments(context);
    },
    color: SettingsClass().bottunColor,
    child: ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(), // Permet le tirage même si la liste est petite
      itemCount: filteredApartment.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: InkWell(
            onTap: () {
              if (auth.userAuthentificate.coins <= filteredApartment[index].crownPoints) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Vous n'avez pas assez de pièces pour voir cet appartement. Veuillez recharger votre compte.")),
                );
                return;
              }
              setState(() {
                auth.userAuthentificate.coins -= filteredApartment[index].crownPoints;
              });
              Navigator.of(context).pushNamed(ApartementView.routeName, arguments: filteredApartment[index]);
            },
            child: _buildApartmentItem(filteredApartment[index]),
          ),
        );
      },
    ),
  );
}

  String _formatDate(String dateStr) {
    try {
      List<String> parts = dateStr.split(' ');
      if (parts.length < 5) return dateStr;
      String formattedDateStr = "${parts[1]} ${parts[2]} ${parts[3]}";
      DateTime parsedDate = DateFormat("MMM d y", "en_US").parse(formattedDateStr);
      return DateFormat("d MMMM y", "fr_FR").format(parsedDate);
    } catch (e) {
      print("Erreur lors du parsing de la date : $e");
      return dateStr;
    }
}

}
