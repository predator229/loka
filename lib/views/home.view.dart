import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/models/settings.class.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/home';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late double evoluatingWidth;
  late bool homePageSee = true;
  late Timer _timer;
  late BaseAuth auth;

  TextEditingController _searchController = TextEditingController();
  List<ApartmentCard> apartments = List<ApartmentCard>.generate(20, (index) {
    return ApartmentCard(
      crownPoints: (1 + (5 - 1) * (index / 20)).toInt(),
      reviews: 50,
      rating: (1 + (5 - 1) * (index / 20)).toDouble(),
      price: "${(30000 + (2000 - 3456) * (index / 20)).toInt()} 30 000 FCFA",
      date: DateTimeRange(start: DateTime.now().add(Duration(days: -2000)), end: DateTime.now().add(Duration(days: 2000))).toString(),
      location: "Cotonou, Benin",
      title: 'Apartment $index',
      description: 'Description for Apartment $index',
      imageUrl: 'https://example.com/image_$index.jpg',
    );
  });
  @override
  void initState() {
    super.initState();
    evoluatingWidth = 0.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startProgressAnimation();
    });
  }

  void _startProgressAnimation() {
    final maxSize = MediaQuery.of(context).size.width - 50;
    const increment = 20.0;
    const duration = Duration(milliseconds: 500);

    auth = AuthProviders.of(context).auth;
    homePageSee = auth.isNewUser;

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
    auth = AuthProviders.of(context).auth;
    homePageSee = auth.isNewUser;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return homePageSee ? homePage() : firstConnection();
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
                        style: TextStyle(
                            fontSize: 30,
                            color: const Color.fromARGB(255, 11, 11, 11)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "1000 pièces ",
                            style: TextStyle(
                                fontSize: 30, color: SettingsClass().color),
                          ),
                          Text(
                            "offert !",
                            style: TextStyle(
                                fontSize: 30,
                                color: const Color.fromARGB(255, 11, 11, 11)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Bienvenu sur Loka, nous vous offrons 1000 pièces pour vos différents parcours sur Loka.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
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
        currentIndex: 0,
        selectedItemColor: SettingsClass().bottunColor,
        onTap: (index) {
          // Handle navigation logic here
        },
      ),
      body: Column(
        children: [
          _buildHead (),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Expanded(
              child: ListView.builder(
                itemCount: apartments.length,
                itemBuilder: (context, index) {
                  return Container(); //_buildApartmentItem(apartments[index]);
                },
                ),
            ),
          ),
          // Center(
          //   child: ElevatedButton(
          //     onPressed: () => Auth().signOut(),
          //     child: const Text("Se déconnecter"),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Wifgets

  Stack _buildHead (){
    return Stack(
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
                          style: TextStyle(
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
                                const Color.fromARGB(39, 222, 222, 222),
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
                                Color(0xFFF6CC),
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
                              const Text(
                                '1000',
                                style: TextStyle(
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
                          style: const TextStyle(
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
                            hintStyle: TextStyle(color: Colors.white),
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
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          // color: const Color.fromARGB(48, 255, 255, 255),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.filter_list_alt,
                                color: Colors.white,
                                size: 25,
                              ),
                              SizedBox(width: 5),
                              Text("Filter",
                                  style: TextStyle(color: Colors.white)),
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('voyins voir'),
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  itemApartment.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$itemApartment.crownPoints',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
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
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemApartment.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  itemApartment.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      itemApartment.location,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      itemApartment.date,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      itemApartment.price,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '$itemApartment.rating',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          ' ($itemApartment.reviews avis)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
