import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loka/models/settings.class.dart';
import 'package:loka/views/authentifications/login.view.dart';
import 'package:loka/controllers/tools.controller.dart';

class WelcomePageView{
  int index;
  List<WelcomeTitle> titles;
  String description;
  String image;
  WelcomePageView ({required this.index, required this.titles, required this.description, required this.image,});
}
class WelcomeTitle {
  String text;
  bool isGreen;
  WelcomeTitle({required this.text, required this.isGreen});
}

class WelcomeView extends StatefulWidget {
  static const routeName = '/welcome';
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => WelcomeViewState();
}

class WelcomeViewState extends State<WelcomeView> {

final List<WelcomePageView> pageViews = [
      WelcomePageView(
        index: 1,
        titles: [
          WelcomeTitle(isGreen: true, text: 'Simplifiez votre recherche '),
          WelcomeTitle(isGreen: false, text: 'de logement avec Loka '),
        ],
        description : "Economiser temps et argent tout en trouvant un logement de qualité qui correspond à vos besoins",
        image : "images/wlc_/welcome1.png",
      ),
      WelcomePageView(
        index: 2,
        titles: [
          WelcomeTitle(isGreen: false, text: 'Trouvez '),
          WelcomeTitle(isGreen: true, text: 'la maison qu\'il vous faut '),
          WelcomeTitle(isGreen: false, text: 'sans trop de dépenses'),
        ],
        description : "Economiser temps et argent tout en trouvant un logement de qualité qui correspond à vos besoins",
        image : "images/wlc_/welcome2.png",
      ),
      WelcomePageView(
        index: 3,
        titles: [
          WelcomeTitle(isGreen: true, text: 'Augmentez votre efficacité '),
          WelcomeTitle(isGreen: false, text: 'en tant qu\'agent immobilier avec Loka'),
        ],
        description : "Renforcez votre professionnalisme, gérez vos annonces et promeut votre réputation",
        image : "images/wlc_/welcome3.png",
      ),
  ];
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox (
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: Flexible(
                          child: PageView(
                            children: [
                              for (int i = 0; i < pageViews.length; i++)
                              _buildPageViewContent(pageDetails: pageViews[i]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginView.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SettingsClass().bottunColor,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10), ), 
                      ),
                      child: const Text('Demarrer'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageViewContent({ required WelcomePageView pageDetails}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        ToolsController().buildProgressIndicator(nbr: pageDetails.index),
        SizedBox(height: 20,),
        Image.asset(pageDetails.image, fit: BoxFit.cover),
        SizedBox(height: 20,),
        Flexible(
          child: ListView(
            children: [
              for (int i = 0; i < pageDetails.titles.length; i++)
                _buildTitleContent(titleDetail: pageDetails.titles[i]),
            ],
          ),
        ),
        SizedBox(height: 20,),
        Text(pageDetails.description, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
      ],
    );
  }

  Widget _buildTitleContent({required WelcomeTitle titleDetail }){
    return titleDetail.isGreen ? Text(titleDetail.text, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: SettingsClass().color),) : Text(titleDetail.text, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),);
  }
}