import 'package:flutter/material.dart';
import 'package:loka/views/login.view.dart';

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
class WelcomeView extends StatelessWidget {
  static const routeName = '/welcome';
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SingleChildScrollView(
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
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginView.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
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

  Widget _oneProgressContainer ({required Color color}){
    return Expanded(
      child: Container(
        height: 5,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
      )
    );
  }

  Widget _buildProgressIndicator({required int nbr}) {
    List<Widget> toReturn = [];
    for (int i = 0; i < nbr; i++) { toReturn.add(_oneProgressContainer(color : Colors.green)); }
    if (nbr < 3) {
      for (int i=0; i<3-nbr; i++) { toReturn.add(_oneProgressContainer(color : Colors.grey)); }
    }
    return Row( children:  toReturn );
  }

  Widget _buildPageViewContent({ required WelcomePageView pageDetails}){
    return Column(
      children: [
        _buildProgressIndicator(nbr: pageDetails.index),
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
    return titleDetail.isGreen ? Text(titleDetail.text, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green),) : Text(titleDetail.text, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),);
  }

}