import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/models/settings.class.dart';
import 'package:intl/intl.dart';
import 'package:loka/views/apartement.view.dart';
import 'package:loka/views/journals/journal.item.view.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/home';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late double evoluatingWidth;
  late bool homePageSee = true;
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
  List<TypeApartment> typesApartments = SettingsClass().typesApartments;

  TypeApartment _selectedType = SettingsClass().typesApartments[0];
  int _selectedTypeJournal = 0;
  late dynamic activJournal;

  late List<ApartmentCard> apartments = List<ApartmentCard>.generate(
    20,
    (index) => ApartmentCard( index:index,
      isFavourite: index % 2 == 0,
      crownPoints: (60 + (5 - 1) * (index / 20)).toInt(),
      reviews: 50,
      rating: (1 + (5 - 1) * (index / 20)).toDouble(),
      price: (30000 + (2000 - 3456) * (index / 20)).toDouble(),
      devise: "FCFA",
      perPeriod: "mois",
      date: DateFormat('dd MMM yyyy', 'fr_FR').format(DateTime.now().add(Duration(days: (1 + (200 - 11) * (index / 20)).toInt()))),
      location: "Cotonou, Benin",
      title: 'Appartement meublé $index',
      description: """Bienvenue dans ce charmant appartement idéalement situé à Cotonou, où le confort moderne rencontre l'authenticité africaine. Aménagées, cet espace offre une retraite paisible au cœur de la ville dynamique. Dès que vous franchirez la porte, vous serez accueilli par une atmosphère chaleureuse et une décoration soignée, mêlant harmonieusement des éléments contemporains à des touches locales. La cuisine entièrement équipée vous invite à préparer des repas délicieux, tandis que le salon spacieux offre un espace dédié à la détente et aux moments conviviaux. La vue depuis le balcon donne sur [mentionnez les points d'intérêt locaux ou le paysage environnant], créant ainsi une ambiance apaisante et pittoresque. L'emplacement central de l'appartement permet un accès facile aux marchés animés, aux restaurants locaux et aux attractions culturelles..""",
      descriptionLocation: "Situé dans le quartier animé de Gbegamey Boa, à Cotonou, en venant de l'aéroport international de Cotonou, notre emplacement stratégique permet un trajet rapide d'environ 20 minutes. De plus, la proximité avec les principales artères routières facilite les déplacements vers d'autres quartiers de la ville.",
      nrColoc: ((60 + (5 - 1) * (index / 20)).toInt())%20,
      imageUrl: index %2 ==0 ? [
        'https://s3-alpha-sig.figma.com/img/d8b2/19a0/f3ea601deefee2be41c6c1c37fd681d3?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=f-~xJqt7EfbLYmoGLmSuNUB-S4l6MBREKYFKFvPiyiijoq5ufyXQuA7rxNHuY4ZOYrW6X9S3D67UjE-4KZsotL23wDi96XHYELb1FMlEIen7JxLA-GZCZQuP8PO~aSgooWzFEIH64rJ2t4Bf8lnk24HXD6Ee9WHEZ25nxHeFE9EJtjkFzJlV9TWsZbj9~0OxwZU96AWdilYPPttC-5V2q01kApUvWkXx6AczarE3ciGYwIkYGc-aoyasYiJ8UoDv3dLh3XSVXlXmSgRY0i8eC9~r27ebC92miA8u3RakddDw95sdi4rv8ruILCS15f-Jt6Px4pPyirn8rPVIvfQPcw__',
        'https://s3-alpha-sig.figma.com/img/e2fd/1235/8d6b32664382b6457007c370ec10114c?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=ms87qVETG2mpitAlZ6pV7l3H5gnz~YQzVyINt161wd3NuH1R5J1ScnU4jIJIsJ9Ew6GT6jIrbU2UFS36RAEGOJZZQ2hX3Q55kPK7MGahMf60N0wEXZmRD2SJxHEvtTYUvcOGRfRnYrhu2lTzz7nbZ5DyJ7wbt0doI91eokKYyOQv~qsRaPRvzQzNPMDMVeAUQKBcnTznh21tL1p7tdcP6APIb3qreLQCqutRdWyKOf-12aUDRyPbHFOYdyQRKry1TmKugtHoZw-C~tDd-cKj~hZwXz1M3o-rA6avL105LgwHhJsPim7yrqENG5CqGikDUIHAZ6jIZuMh4QQsieUGqA__',
        'https://s3-alpha-sig.figma.com/img/d8b2/19a0/f3ea601deefee2be41c6c1c37fd681d3?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=f-~xJqt7EfbLYmoGLmSuNUB-S4l6MBREKYFKFvPiyiijoq5ufyXQuA7rxNHuY4ZOYrW6X9S3D67UjE-4KZsotL23wDi96XHYELb1FMlEIen7JxLA-GZCZQuP8PO~aSgooWzFEIH64rJ2t4Bf8lnk24HXD6Ee9WHEZ25nxHeFE9EJtjkFzJlV9TWsZbj9~0OxwZU96AWdilYPPttC-5V2q01kApUvWkXx6AczarE3ciGYwIkYGc-aoyasYiJ8UoDv3dLh3XSVXlXmSgRY0i8eC9~r27ebC92miA8u3RakddDw95sdi4rv8ruILCS15f-Jt6Px4pPyirn8rPVIvfQPcw__',
        'https://s3-alpha-sig.figma.com/img/e2fd/1235/8d6b32664382b6457007c370ec10114c?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=ms87qVETG2mpitAlZ6pV7l3H5gnz~YQzVyINt161wd3NuH1R5J1ScnU4jIJIsJ9Ew6GT6jIrbU2UFS36RAEGOJZZQ2hX3Q55kPK7MGahMf60N0wEXZmRD2SJxHEvtTYUvcOGRfRnYrhu2lTzz7nbZ5DyJ7wbt0doI91eokKYyOQv~qsRaPRvzQzNPMDMVeAUQKBcnTznh21tL1p7tdcP6APIb3qreLQCqutRdWyKOf-12aUDRyPbHFOYdyQRKry1TmKugtHoZw-C~tDd-cKj~hZwXz1M3o-rA6avL105LgwHhJsPim7yrqENG5CqGikDUIHAZ6jIZuMh4QQsieUGqA__',
        'https://s3-alpha-sig.figma.com/img/d8b2/19a0/f3ea601deefee2be41c6c1c37fd681d3?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=f-~xJqt7EfbLYmoGLmSuNUB-S4l6MBREKYFKFvPiyiijoq5ufyXQuA7rxNHuY4ZOYrW6X9S3D67UjE-4KZsotL23wDi96XHYELb1FMlEIen7JxLA-GZCZQuP8PO~aSgooWzFEIH64rJ2t4Bf8lnk24HXD6Ee9WHEZ25nxHeFE9EJtjkFzJlV9TWsZbj9~0OxwZU96AWdilYPPttC-5V2q01kApUvWkXx6AczarE3ciGYwIkYGc-aoyasYiJ8UoDv3dLh3XSVXlXmSgRY0i8eC9~r27ebC92miA8u3RakddDw95sdi4rv8ruILCS15f-Jt6Px4pPyirn8rPVIvfQPcw__',
        'https://s3-alpha-sig.figma.com/img/d8b2/19a0/f3ea601deefee2be41c6c1c37fd681d3?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=f-~xJqt7EfbLYmoGLmSuNUB-S4l6MBREKYFKFvPiyiijoq5ufyXQuA7rxNHuY4ZOYrW6X9S3D67UjE-4KZsotL23wDi96XHYELb1FMlEIen7JxLA-GZCZQuP8PO~aSgooWzFEIH64rJ2t4Bf8lnk24HXD6Ee9WHEZ25nxHeFE9EJtjkFzJlV9TWsZbj9~0OxwZU96AWdilYPPttC-5V2q01kApUvWkXx6AczarE3ciGYwIkYGc-aoyasYiJ8UoDv3dLh3XSVXlXmSgRY0i8eC9~r27ebC92miA8u3RakddDw95sdi4rv8ruILCS15f-Jt6Px4pPyirn8rPVIvfQPcw__',
        'https://s3-alpha-sig.figma.com/img/e2fd/1235/8d6b32664382b6457007c370ec10114c?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=ms87qVETG2mpitAlZ6pV7l3H5gnz~YQzVyINt161wd3NuH1R5J1ScnU4jIJIsJ9Ew6GT6jIrbU2UFS36RAEGOJZZQ2hX3Q55kPK7MGahMf60N0wEXZmRD2SJxHEvtTYUvcOGRfRnYrhu2lTzz7nbZ5DyJ7wbt0doI91eokKYyOQv~qsRaPRvzQzNPMDMVeAUQKBcnTznh21tL1p7tdcP6APIb3qreLQCqutRdWyKOf-12aUDRyPbHFOYdyQRKry1TmKugtHoZw-C~tDd-cKj~hZwXz1M3o-rA6avL105LgwHhJsPim7yrqENG5CqGikDUIHAZ6jIZuMh4QQsieUGqA__',
        ] : [
        'https://s3-alpha-sig.figma.com/img/e2fd/1235/8d6b32664382b6457007c370ec10114c?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=ms87qVETG2mpitAlZ6pV7l3H5gnz~YQzVyINt161wd3NuH1R5J1ScnU4jIJIsJ9Ew6GT6jIrbU2UFS36RAEGOJZZQ2hX3Q55kPK7MGahMf60N0wEXZmRD2SJxHEvtTYUvcOGRfRnYrhu2lTzz7nbZ5DyJ7wbt0doI91eokKYyOQv~qsRaPRvzQzNPMDMVeAUQKBcnTznh21tL1p7tdcP6APIb3qreLQCqutRdWyKOf-12aUDRyPbHFOYdyQRKry1TmKugtHoZw-C~tDd-cKj~hZwXz1M3o-rA6avL105LgwHhJsPim7yrqENG5CqGikDUIHAZ6jIZuMh4QQsieUGqA__',
        'https://s3-alpha-sig.figma.com/img/d8b2/19a0/f3ea601deefee2be41c6c1c37fd681d3?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=f-~xJqt7EfbLYmoGLmSuNUB-S4l6MBREKYFKFvPiyiijoq5ufyXQuA7rxNHuY4ZOYrW6X9S3D67UjE-4KZsotL23wDi96XHYELb1FMlEIen7JxLA-GZCZQuP8PO~aSgooWzFEIH64rJ2t4Bf8lnk24HXD6Ee9WHEZ25nxHeFE9EJtjkFzJlV9TWsZbj9~0OxwZU96AWdilYPPttC-5V2q01kApUvWkXx6AczarE3ciGYwIkYGc-aoyasYiJ8UoDv3dLh3XSVXlXmSgRY0i8eC9~r27ebC92miA8u3RakddDw95sdi4rv8ruILCS15f-Jt6Px4pPyirn8rPVIvfQPcw__',
        'https://s3-alpha-sig.figma.com/img/e2fd/1235/8d6b32664382b6457007c370ec10114c?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=ms87qVETG2mpitAlZ6pV7l3H5gnz~YQzVyINt161wd3NuH1R5J1ScnU4jIJIsJ9Ew6GT6jIrbU2UFS36RAEGOJZZQ2hX3Q55kPK7MGahMf60N0wEXZmRD2SJxHEvtTYUvcOGRfRnYrhu2lTzz7nbZ5DyJ7wbt0doI91eokKYyOQv~qsRaPRvzQzNPMDMVeAUQKBcnTznh21tL1p7tdcP6APIb3qreLQCqutRdWyKOf-12aUDRyPbHFOYdyQRKry1TmKugtHoZw-C~tDd-cKj~hZwXz1M3o-rA6avL105LgwHhJsPim7yrqENG5CqGikDUIHAZ6jIZuMh4QQsieUGqA__',
        'https://s3-alpha-sig.figma.com/img/d8b2/19a0/f3ea601deefee2be41c6c1c37fd681d3?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=f-~xJqt7EfbLYmoGLmSuNUB-S4l6MBREKYFKFvPiyiijoq5ufyXQuA7rxNHuY4ZOYrW6X9S3D67UjE-4KZsotL23wDi96XHYELb1FMlEIen7JxLA-GZCZQuP8PO~aSgooWzFEIH64rJ2t4Bf8lnk24HXD6Ee9WHEZ25nxHeFE9EJtjkFzJlV9TWsZbj9~0OxwZU96AWdilYPPttC-5V2q01kApUvWkXx6AczarE3ciGYwIkYGc-aoyasYiJ8UoDv3dLh3XSVXlXmSgRY0i8eC9~r27ebC92miA8u3RakddDw95sdi4rv8ruILCS15f-Jt6Px4pPyirn8rPVIvfQPcw__',
        'https://s3-alpha-sig.figma.com/img/d8b2/19a0/f3ea601deefee2be41c6c1c37fd681d3?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=f-~xJqt7EfbLYmoGLmSuNUB-S4l6MBREKYFKFvPiyiijoq5ufyXQuA7rxNHuY4ZOYrW6X9S3D67UjE-4KZsotL23wDi96XHYELb1FMlEIen7JxLA-GZCZQuP8PO~aSgooWzFEIH64rJ2t4Bf8lnk24HXD6Ee9WHEZ25nxHeFE9EJtjkFzJlV9TWsZbj9~0OxwZU96AWdilYPPttC-5V2q01kApUvWkXx6AczarE3ciGYwIkYGc-aoyasYiJ8UoDv3dLh3XSVXlXmSgRY0i8eC9~r27ebC92miA8u3RakddDw95sdi4rv8ruILCS15f-Jt6Px4pPyirn8rPVIvfQPcw__',
        'https://s3-alpha-sig.figma.com/img/e2fd/1235/8d6b32664382b6457007c370ec10114c?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=ms87qVETG2mpitAlZ6pV7l3H5gnz~YQzVyINt161wd3NuH1R5J1ScnU4jIJIsJ9Ew6GT6jIrbU2UFS36RAEGOJZZQ2hX3Q55kPK7MGahMf60N0wEXZmRD2SJxHEvtTYUvcOGRfRnYrhu2lTzz7nbZ5DyJ7wbt0doI91eokKYyOQv~qsRaPRvzQzNPMDMVeAUQKBcnTznh21tL1p7tdcP6APIb3qreLQCqutRdWyKOf-12aUDRyPbHFOYdyQRKry1TmKugtHoZw-C~tDd-cKj~hZwXz1M3o-rA6avL105LgwHhJsPim7yrqENG5CqGikDUIHAZ6jIZuMh4QQsieUGqA__',
        'https://s3-alpha-sig.figma.com/img/d8b2/19a0/f3ea601deefee2be41c6c1c37fd681d3?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=f-~xJqt7EfbLYmoGLmSuNUB-S4l6MBREKYFKFvPiyiijoq5ufyXQuA7rxNHuY4ZOYrW6X9S3D67UjE-4KZsotL23wDi96XHYELb1FMlEIen7JxLA-GZCZQuP8PO~aSgooWzFEIH64rJ2t4Bf8lnk24HXD6Ee9WHEZ25nxHeFE9EJtjkFzJlV9TWsZbj9~0OxwZU96AWdilYPPttC-5V2q01kApUvWkXx6AczarE3ciGYwIkYGc-aoyasYiJ8UoDv3dLh3XSVXlXmSgRY0i8eC9~r27ebC92miA8u3RakddDw95sdi4rv8ruILCS15f-Jt6Px4pPyirn8rPVIvfQPcw__',],
      // typeApartment: List<int>.generate(5, (index) => index + 1),
      typeApartment: List<int>.generate(
        (index % 5) + 1,
        (i) => (i - 1 + index) % SettingsClass().typesApartments.length,
      ),
      nbrNeightbord: (index*123)%10,
      caracteristiques:ApartmentCaracteristique(
        id: index, 
        superficieTotale: "${(60 + (5 - 1)/(40-index) * (index / 20)).toDouble()} cm2", 
        equipements: List<ApartementEquipement>.generate(
          20,
          (i) => ApartementEquipement(
            id: i,
            type: SettingsClass().equipementsType[(index*i+1) % 10],
          ),
        ),
        services: List<ServiceClosest>.generate(
          10,
          (i) =>  i%2 == 0 ? ServiceClosest(id:i, name: 'Marchés Locaux', description: """Explorez les marchés animés à quelques pas de votre porte, où vous pourrez découvrir des produits frais, de l'artisanat local et l'effervescence quotidienne de la vie marchande."""
            ) : ServiceClosest(id: i, name: "Restaurants Authentiques", description: """Profitez d'une variété de restaurants locaux proposant une délicieuse cuisine béninoise, offrant une expérience culinaire authentique. """),
        ),
        rooms: [
        Room(id: index, superficie: "${(60 + (5 - 1) * (index / 20)).toDouble()} cm2", type: SettingsClass().roomTypes[1]),
        // Room(id: index+1, superficie: "${(60 + (5)/20 * (index / 20)).toDouble()} cm2", type: SettingsClass().roomTypes[0]),
        // Room(id: index+2, superficie: "${(60 + (5 - 1)/(40-index) * (index / 20)).toDouble()} cm2", type: SettingsClass().roomTypes[0]),
        ...List<Room>.generate(
          (index + 20) % 5 == 0 ? 1 : (index + 20) % 5,
          (indextype) => Room(id: indextype, superficie: "${(60 + (5 - 1) * (index / 20)).toDouble()} cm2", type: SettingsClass().roomTypes[0])
        )
      ],
      ),
    )
  );

  late List<JournalCard> journalCards;

  late List<ApartmentCard> apartmentsFiltered;
  late List<JournalCard> journalCardFiltered;
  late List<ApartmentCard> apartmentsFoavorite;
  late TabController _tabController = TabController(length: 3, vsync: this);

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    evoluatingWidth = 0.0;
    apartmentsFiltered = apartments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      journalCards =List<JournalCard>.generate(
      40,
      (index) => JournalCard(
        index: index + 1,
        status: (index % 4),
        date: DateFormat('dd MMM yyyy', 'fr_FR').format(DateTime.now().add(Duration(days: (1 + (200 - 11) * (index / 20)).toInt()))),
        apartmentCard: apartments[(19-index)%20],
      ));
      activJournal = journals[0];
      letFilterJournal();
      letFavoriteTheApartments();
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
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = AuthProviders.of(context).auth;
    homePageSee = auth.isNewUser;
    _tabController = TabController(length: 3, vsync: this);
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
      case 0: toReturn = _buildHomePage(); break;
      case 1: toReturn = _buildFavoritePage(); break;
      case 2: toReturn = _buildJournal(); break;
      case 3: toReturn = _buildProfile(); break;
    }
    return toReturn;
  }

  // Wifgets
   Widget _buildHomePage (){
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
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true, 
              itemCount: apartmentsFiltered.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed(ApartementView.routeName, arguments: apartmentsFiltered[index]);
                    },
                    child:_buildApartmentItem(apartmentsFiltered[index]),
                  ),
                );
              },
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
              children: [ Text( "Favoris", style: TextStyle( fontSize: 36, fontWeight: FontWeight.bold ),), ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true, 
              itemCount: apartmentsFoavorite.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: InkWell(
                    onTap: (){Navigator.of(context).pushNamed(ApartementView.routeName, arguments: apartmentsFoavorite[index]);},
                    child: _buildApartmentItem(apartmentsFoavorite[index]),
                  ),
                );
              },
            ),
          ),
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
                children: [ Text( "Journal", style: TextStyle( fontSize: 36, fontWeight: FontWeight.bold ),), ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: journals.map((journal) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      backgroundColor: journal['selected'] ? SettingsClass().bottunColor : Colors.white,
                      foregroundColor: journal['selected'] ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide.none,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      ),
                    onPressed: (){
                      setState(() {
                        journals.forEach((element) {
                          element['selected'] = false;
                          if (element['id'] == journal['id']) {element['selected'] = true;}
                          _selectedTypeJournal = journal['type'];
                          activJournal = journal;
                          letFilterJournal();
                        });
                      });
                    },
                    child: Text( journal['title'], ),
                  );
                }).toList(),
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: journalCardFiltered.length,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
                itemBuilder: (context, index) {
                  var journal = journalCardFiltered[index];
                  return  InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed(JournalItem.routeName, arguments: {'journal':journal, 'typeJ':activJournal});
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                            ClipRRect(
                              key: ValueKey("${journal.index}-${journal.date}"),
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  journal.apartmentCard.imageUrl[0],
                                  height: 93,
                                  width: 93,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: 93,
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: _selectedTypeJournal == 0 ? Color.fromARGB (138, 255, 30, 23) : ( _selectedTypeJournal == 1 ? Color.fromARGB(137, 255, 193, 23) : Color.fromARGB(137, 23, 255, 185) ),
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        activJournal['title'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 20,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(journal.apartmentCard.title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for(int i = 0; i < 1; i++) //journal.apartmentCard.typeApartment.length
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all( color: Colors.transparent),
                                          color: Color.fromARGB(255, 245, 245, 245),
                                        ),
                                        child: Text(typesApartments[journal.apartmentCard.typeApartment[i]].name, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),),
                                    ),
                                  ),
                                ]
                              ),
                              Text(journal.apartmentCard.location, style: TextStyle(fontWeight: FontWeight.w500, )),
                              Text(journal.date, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildProfile() {
    return SafeArea(
      child: Center(
        child: ElevatedButton(
          onPressed: (){ auth.signOut(); }, child: 
          Text('Se deconnecter', style: TextStyle(color: Colors.white),)),));
  }

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
                              Text("Filtrer",
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
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: !itemApartment.isFavourite ? Colors.black : Colors.white,
                child: IconButton(
                  icon: Icon(Icons.favorite, color: !itemApartment.isFavourite ? Colors.white : Colors.red,),
                  onPressed: () {
                    setState(() { apartments[itemApartment.index].isFavourite = !itemApartment.isFavourite; letFavoriteTheApartments(); });
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
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
                    "Jusqu'au ${itemApartment.date}",
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
                    "${itemApartment.price.toString()} ${itemApartment.devise} / ${itemApartment.perPeriod}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: SettingsClass().color, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        itemApartment.rating.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        ' (${itemApartment.reviews.toString()} avis)',
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
                Text(typeArp.name,style: TextStyle(color: _selectedType.id == typeArp.id ?  Colors.white : Colors.grey)),
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
      apartmentsFiltered = _selectedType.id == 0 ? apartments 
      : apartments.where((element) => element.typeApartment.contains(_selectedType.id)).toList();
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
}
