
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loka/models/settings.class.dart';

class FilterView extends StatefulWidget {
  static const String routeName = '/filter-view';
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  final inMinPrice = 0.0;
  final inMaxPrice = 2000000.0;

  final inMinArea = 0.0;
  final inMaxArea = 300.0;

  final inMinZone = 0.0;
  final inMaxZone = 300.0;


  List<int> _currentCouverture = [];
  List<bool> _currentEquipemts = List<bool>.filled(SettingsClass().equipementsType.length, false);

  final TextEditingController _minBudgetController = TextEditingController();
  final TextEditingController _maxBudgetController = TextEditingController();

  final TextEditingController _minAreaController = TextEditingController();
  final TextEditingController _maxAreaController = TextEditingController();

  final TextEditingController _currentZoneController = TextEditingController();


  bool showSomeOnly = true;

  final TextEditingController _nbrChambreController = TextEditingController();
  final TextEditingController _nbrSalonControler = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RangeValues _currentRangeBudgetValues = RangeValues(0.0, 200000.0);
  RangeValues _currentRangeAreaValues = RangeValues(0.0, 3000.0);

   double _currentZone = 100;


  @override
  void initState() {
    _minBudgetController.text = inMinPrice.toString();
    _maxBudgetController.text = inMaxPrice.toString();

    _minAreaController.text = inMinArea.toString();
    _maxAreaController.text = inMaxArea.toString();

    _currentZoneController.text = "100";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, size: 30,),
        ),
        title: Text('Filter', style: TextStyle(fontFamily: "Figtree",fontSize: 20),),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: InkWell(
              onTap: () {},
              child: Text("Reinitialiser tout", style :TextStyle(fontFamily: "Figtree",fontSize: 17, decoration: TextDecoration.underline),),
            ),
          )
        ],
        centerTitle: false,
      ),
      body: 
      Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true, 
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: const Color.fromARGB(255, 221, 221, 221)),
                          ),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Budget", style: TextStyle(fontFamily: "Figtree",fontSize: 21, fontWeight: FontWeight.w600),),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Minimum", style: TextStyle(fontFamily: "Figtree",fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),),
                                          SizedBox(height: 4,),
                                          TextFormField(
                                            controller: _minBudgetController,
                                            onChanged: (value) {
                                              if (_isNumeric(value) && double.parse(value) > inMinPrice && double.parse(value) < inMaxPrice ) {
                                                setState(() {
                                                  _currentRangeBudgetValues = RangeValues(
                                                    double.parse(value),
                                                    _currentRangeBudgetValues.end,
                                                  );
                                                });
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [ FilteringTextInputFormatter.digitsOnly, ],
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.all(10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(8)
                                              ),
                                              suffixText: "Fcfa",
                                            ),
                                            style: TextStyle(fontFamily: "Figtree",
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(),
                                      ),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Maximum", style: TextStyle(fontFamily: "Figtree",fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),),
                                          SizedBox(height: 4,),
                                          TextFormField(
                                            controller: _maxBudgetController,
                                            onChanged: (value) {
                                              if (_isNumeric(value) && double.parse(value) > inMinPrice && double.parse(value) < inMaxPrice ) {
                                                setState(() {
                                                  _currentRangeBudgetValues = RangeValues(
                                                    _currentRangeBudgetValues.start,
                                                    double.parse(value),
                                                  );
                                                });
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [ FilteringTextInputFormatter.digitsOnly, ],
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.all(10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(8)
                                              ),
                                              suffixText: "Fcfa",
                                            ),
                                            style: TextStyle(fontFamily: "Figtree",
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                  
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children:[ 
                                  Expanded(
                                    child: RangeSlider(
                                      values: _currentRangeBudgetValues,
                                      min: 0,
                                      max: 200000,
                                      divisions: 50000, 
                                      activeColor: SettingsClass().bottunColor,
                                      inactiveColor: Colors.grey[300],
                                      labels: RangeLabels(
                                        _currentRangeBudgetValues.start.round().toString(),
                                        _currentRangeBudgetValues.end.round().toString(),
                                      ),
                                      onChanged: (RangeValues values) {
                                        setState(() {
                                          _currentRangeBudgetValues = values;
                                          _minBudgetController.text = values.start.round().toString();
                                          _maxBudgetController.text = values.end.round().toString();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                      padding: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        border: Border(
                        bottom: BorderSide(color: const Color.fromARGB(255, 221, 221, 221)),
                        ),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Nombres de chambres / salons",
                            style: TextStyle(fontFamily: "Figtree",
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Nombres de chambres",
                            style: TextStyle(
                              fontFamily: "Figtree",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255,113, 113, 113),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center, 
                            children: [
                              Container(
                                height: 48,
                                width: 61,
                                decoration: BoxDecoration(
                                  border: Border.all(style: BorderStyle.none),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color.fromARGB(255, 237, 237, 237),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() { 
                                      var val = _isNumeric(_nbrChambreController.text) ? double.parse(_nbrChambreController.text) - 1 : 1;
                                     _nbrChambreController.text =  (val < 0 ? 0 : val).toString(); 
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      "-",
                                      style: TextStyle(
                                        fontFamily: "Figtree",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                height: 48,
                                width: 69,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: _nbrChambreController,
                                  keyboardType: TextInputType.number,
 
inputFormatters: [ FilteringTextInputFormatter.digitsOnly, ],

                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "2",
                                  ),
                                  style: TextStyle(
                                    fontFamily: "Figtree",
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                height: 48,
                                width: 61,
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(style: BorderStyle.none),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color.fromARGB(255, 237, 237, 237),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() { _nbrChambreController.text = (_isNumeric(_nbrChambreController.text) ? double.parse(_nbrChambreController.text) + 1 : 1).toString(); });
                                  },
                                  child: Center(
                                    child: Text(
                                      "+",
                                      style: TextStyle(
                                        fontFamily: "Figtree",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Text(
                            "Nombres de salons",
                            style: TextStyle(
                              fontFamily: "Figtree",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255,113, 113, 113),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center, 
                            children: [
                              Container(
                                height: 48,
                                width: 61,
                                decoration: BoxDecoration(
                                  border: Border.all(style: BorderStyle.none),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color.fromARGB(255, 237, 237, 237),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() { 
                                      var val = _isNumeric(_nbrSalonControler.text) ? double.parse(_nbrSalonControler.text) - 1 : 1;
                                     _nbrSalonControler.text =  (val < 0 ? 0 : val).toString(); 
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      "-",
                                      style: TextStyle(
                                        fontFamily: "Figtree",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                height: 48,
                                width: 69,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: _nbrSalonControler,
                                  keyboardType: TextInputType.number,
 
inputFormatters: [ FilteringTextInputFormatter.digitsOnly, ],

                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "2",
                                  ),
                                  style: TextStyle(
                                    fontFamily: "Figtree",
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                height: 48,
                                width: 61,
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(style: BorderStyle.none),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color.fromARGB(255, 237, 237, 237),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() { _nbrSalonControler.text = (_isNumeric(_nbrSalonControler.text) ? double.parse(_nbrSalonControler.text) + 1 : 1).toString(); });
                                  },
                                  child: Center(
                                    child: Text(
                                      "+",
                                      style: TextStyle(
                                        fontFamily: "Figtree",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                        ),
                      ),
                      ),
                    ), 
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: const Color.fromARGB(255, 221, 221, 221)),
                          ),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Couverture de chambre", style: TextStyle(fontFamily: "Figtree",fontSize: 21, fontWeight: FontWeight.w600),),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:8.0),
                                child: Wrap(
                                  spacing: 10.0,
                                  runSpacing: 20.0,
                                  alignment: WrapAlignment.start,
                                  children: [
                                    for (int i = 0; i < SettingsClass().couvertureChambres.length; i++)
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: _currentCouverture.contains(i) ? SettingsClass().bottunColor : Colors.black,
                                        ),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            if (_currentCouverture.contains(i)) { _currentCouverture.remove(i); }
                                            else { _currentCouverture.add(i); }
                                          });
                                        },
                                        child: Wrap(
                                          alignment: WrapAlignment.start,
                                          spacing: 10.0,
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          children: [
                                            Image.asset(SettingsClass().couvertureChambres[i].icon, width: 40, color: _currentCouverture.contains(i) ? SettingsClass().bottunColor : Colors.black ,),
                                            Text(SettingsClass().couvertureChambres[i].name, style: TextStyle(fontFamily: "Figtree", color: _currentCouverture.contains(i) ? SettingsClass().bottunColor : Colors.black),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children:[ 
                                  Expanded(
                                    child: Container(
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: const Color.fromARGB(255, 221, 221, 221)),
                          ),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Surfaces du logement", style: TextStyle(fontFamily: "Figtree",fontSize: 21, fontWeight: FontWeight.w600),),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Minimum", style: TextStyle(fontFamily: "Figtree",fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),),
                                          SizedBox(height: 4,),
                                          TextFormField(
                                            controller: _minAreaController,
                                            onChanged: (value) {
                                              if (_isNumeric(value) && double.parse(value) > inMinPrice && double.parse(value) < inMaxPrice ) {
                                                setState(() {
                                                  _currentRangeAreaValues = RangeValues(
                                                    double.parse(value),
                                                    _currentRangeAreaValues.end,
                                                  );
                                                });
                                              }
                                            },
                                            keyboardType: TextInputType.number,
 
inputFormatters: [ FilteringTextInputFormatter.digitsOnly, ],

                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.all(10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(8)
                                              ),
                                              suffixText: "m2",
                                            ),
                                            style: TextStyle(fontFamily: "Figtree",
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(),
                                      ),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Maximum", style: TextStyle(fontFamily: "Figtree",fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),),
                                          SizedBox(height: 4,),
                                          TextFormField(
                                            controller: _maxAreaController,
                                            onChanged: (value) {
                                              if (_isNumeric(value) && double.parse(value) > inMinPrice && double.parse(value) < inMaxPrice ) {
                                                setState(() {
                                                  _currentRangeAreaValues = RangeValues(
                                                    _currentRangeAreaValues.start,
                                                    double.parse(value),
                                                  );
                                                });
                                              }
                                            },
                                            keyboardType: TextInputType.number,
 
inputFormatters: [ FilteringTextInputFormatter.digitsOnly, ],

                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.all(10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(8)
                                              ),
                                              suffixText: "m2",
                                            ),
                                            style: TextStyle(fontFamily: "Figtree",
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children:[ 
                                  Expanded(
                                    child: RangeSlider(
                                      values: _currentRangeAreaValues,
                                      min: 0,
                                      max: 3000,
                                      divisions: 10, 
                                      activeColor: SettingsClass().bottunColor,
                                      inactiveColor: Colors.grey[300],
                                      labels: RangeLabels(
                                        _currentRangeAreaValues.start.round().toString(),
                                        _currentRangeAreaValues.end.round().toString(),
                                      ),
                                      onChanged: (RangeValues values) {
                                        setState(() {
                                          _currentRangeAreaValues = values;
                                          _minAreaController.text = values.start.round().toString();
                                          _maxAreaController.text = values.end.round().toString();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: const Color.fromARGB(255, 221, 221, 221)),
                          ),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Aménagement", style: TextStyle(fontFamily: "Figtree",fontSize: 21, fontWeight: FontWeight.w600),),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    for (int i = 0; i < (SettingsClass().equipementsType.length> 4 && showSomeOnly ? 4 : SettingsClass().equipementsType.length); i++)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(SettingsClass().equipementsType[i].name, style: TextStyle(fontFamily: "Figtree", color: _currentCouverture.contains(i) ? SettingsClass().bottunColor : Colors.black, fontSize: 16, fontWeight: FontWeight.w500),),
                                        Checkbox(
                                          value: _currentEquipemts[i],
                                          onChanged: (bool? value) {
                                            setState(() { _currentEquipemts[i] = value ?? false; });
                                          },
                                          activeColor: SettingsClass().bottunColor,
                                          side: BorderSide(width: 2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (showSomeOnly)
                                    InkWell(
                                      onTap: () { setState(() { showSomeOnly = ! showSomeOnly;}); },
                                      child: Row(
                                        children: [
                                          Text("Plus d'amenagement", style: TextStyle(color: SettingsClass().bottunColor,decoration: TextDecoration.underline),),
                                        ],
                                      ),
                                    ),
                                    if (!showSomeOnly)
                                    InkWell(
                                      onTap: () { setState(() { showSomeOnly = ! showSomeOnly;}); },
                                      child: Row(
                                        children: [
                                          Text("Moins d'amenagement", style: TextStyle(color: SettingsClass().bottunColor,decoration: TextDecoration.underline),),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children:[ 
                                  Expanded(
                                    child: Container(
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: const Color.fromARGB(255, 221, 221, 221)),
                          ),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Proximité par rapport à ", style: TextStyle(fontFamily: "Figtree",fontSize: 21, fontWeight: FontWeight.w600),),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Vous voulez que la maison soit proche d’un emplacement?", style: TextStyle(fontFamily: "Figtree",fontSize: 16, color: Color.fromARGB(255, 113, 113, 113), fontWeight: FontWeight.w500),),
                                    SizedBox(height: 20,),
                                    Text("Veuillez rechercher l’emplacement", style: TextStyle(fontFamily: "Figtree",fontSize: 14, color: Color.fromARGB(255, 113, 113, 113), fontWeight: FontWeight.w500),),
                                    SizedBox(height: 10),
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: SettingsClass().bottunColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Ministere des affaire etrangeres", style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "Figtree", fontWeight: FontWeight.w500),),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(255, 253, 198, 9,),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(Icons.location_on, size: 20, color: Colors.white,),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text("Rechercher le logement par rapport à l’emplacement dans un rayon de :", style: TextStyle(fontFamily: "Figtree",fontSize: 14, color: Color.fromARGB(255, 113, 113, 113), fontWeight: FontWeight.w500),),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 4,),
                                              TextFormField(
                                                controller: _currentZoneController,
                                                onChanged: (value) {
                                                  if (!_isNumeric(value) ) { _currentZoneController.text = "0"; return; }
                                                  if (double.parse(value) < inMinZone) { _currentZoneController.text = inMinZone.toString(); }
                                                  if (double.parse(value) > inMaxZone) { _currentZoneController.text = inMaxZone.toString(); }

                                                  if (_isNumeric(value) && double.parse(value) > inMinZone && double.parse(value) < inMaxZone ) {
                                                    setState(() {
                                                      _currentZone = double.parse(value);
                                                    });
                                                  }
                                                },
                                                keyboardType: TextInputType.number,
 
inputFormatters: [ FilteringTextInputFormatter.digitsOnly, ],

                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(10),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.grey),
                                                    borderRadius: BorderRadius.circular(8)
                                                  ),
                                                  suffixText: "km",
                                                ),
                                                style: TextStyle(fontFamily: "Figtree",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children:[ 
                                                Expanded(
                                                  child: Slider(
                                                    value: _currentZone,
                                                    min: 0,
                                                    max: 300,
                                                    // divisions: 10, 
                                                    activeColor: SettingsClass().bottunColor,
                                                    inactiveColor: Colors.grey[300],
                                                    onChanged: (double value) {
                                                      setState(() {
                                                        _currentZone = value;
                                                        _currentZoneController.text = value.toString();
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ],
                                          ),
                                        ),
                                      ],
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
            ),
            Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: InkWell(
                          onTap: () {},
                          child: Text("Reinitialiser tout", style :TextStyle(fontFamily: "Figtree",fontSize: 17, decoration: TextDecoration.underline),),
                        ),
                      )
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: letFilter,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: SettingsClass().bottunColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10), ), 
                        ),
                        child: const Text("Voir tous les logements", style: TextStyle(fontFamily: "Figtree",fontSize: 14, fontWeight: FontWeight.w600),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ],
          ),
      ),
    );
  }

    bool _isNumeric(String str) {
    if (str.isEmpty) {
      return false;
    }
    final number = num.tryParse(str);
    return number != null;
  }

  letFilter (){

  }

}