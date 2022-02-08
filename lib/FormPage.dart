import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({ Key? key }) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {

  String? _currentRegion;
  final List<String> _regions = [
    "ABRUZZO",
    "BASILICATA",
    "CALABRIA",
    "CAMPANIA",
    "EMILIA_ROMAGNA",
    "FRIULI_VENEZIA_GIULIA",
    "LAZIO",
    "LIGURIA",
    "LOMBARDIA",
    "MARCHE",
    "MOLISE",
    "PIEMONTE",
    "PUGLIA",
    "SARDEGNA",
    "SICILIA",
    "TOSCANA",
    "TRENTINO_ALTO_ADIGE",
    "UMBRIA",
    "VALLE_DAOSTA",
    "VENETO"
  ];

  String? _currentActivity;
  final List<String> _activities = [
    "MEZZI_PUBBLICI",
    "LAVORO",
    "NEGOZI_E_UFFICI",
    "SCUOLE_E_UNIVERSITA",
    "STRUTTURE_SANITARIE",
    "BAR_E_RISTORANTI",
    "ATTIVITA_SPORTIVE",
    "EVENTI_SPORTIVI",
    "EVENTI_CULTURALI",
    "CERIMONIE",
    "FESTE",
    "CONVENGI_CONGRESSI_FIERE",
    "ATTIVITA_LUDICHE_CREATIVE"
  ];

  bool _isLoading = false;

  void _onLoading() {
    setState(() {
      _isLoading = true;
      canDo().then((response) {
        
        bool cando = jsonDecode(response.body)['data']['canDo'];
        print(cando);
        
        setState((){
          _isLoading = false;
        });

        ScaffoldMessenger.of(const GlobalObjectKey("FORM").currentContext!).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                cando
                ? const Icon(Icons.done, color: Colors.green)
                : const Icon(Icons.error_outline, color: Colors.red),
                cando
                ? const Text("Sei autorizzato", style: TextStyle(color: Colors.green))
                : const Text("Non sei autorizzato", style: TextStyle(color: Colors.red))
              ],
            ),
            behavior: SnackBarBehavior.floating,
          )
        );
        
      });
      //Future.delayed(const Duration(seconds: 3), _response);
    });
  }

  Future<http.Response> canDo() {
    return http.post(
      //Uri.parse("http://localhost:30303/api/v1/certification/canDo"),
      Uri.parse("http://95.179.136.254:30303/api/v1/certification/canDo"),
      headers: <String, String> {
        "content-type": "application/json"
      },
      body: jsonEncode(<String, String>{
        // "greenpass": '{"tipo_certificazione":"4"}',
        // "activity": "MEZZI_PUBBLICI",
        // "region": "BASILICATA"
        "greenpass": _qrcode!,
        "activity": _currentActivity!,
        "region": _currentRegion!
      })
    );
  }


  Future _response() async{
    setState((){
      _isLoading = false;
    });
  }

  String? _qrcode;

  @override
  Widget build(BuildContext context) {

    _qrcode = ModalRoute.of(context)!.settings.arguments as String?;
    print("Data scanned: $_qrcode");

    var body = Container(
      margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
      child: Column(

        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [

          DropdownButtonFormField(
            value: _currentRegion,

            onChanged: (newValue) { _currentRegion = newValue.toString(); },

            items: List.generate(_regions.length, (index) {
              return DropdownMenuItem(
                value: _regions[index],
                child: Text(_regions[index].replaceAll("_", " ")),
              );
            }).toList(),

            hint: const Text("Seleziona Regione"),
          ),

          DropdownButtonFormField(
            value: _currentActivity,

            onChanged: (newValue) { _currentActivity = newValue.toString(); },

            items: List.generate(_activities.length, (index) {
              return DropdownMenuItem(
                value: _activities[index],
                child: Text(_activities[index].replaceAll("_", " ")),
              );
            }).toList(),

            hint: const Text("Seleziona Attività"),
          ),

        ],
      )
    );

    var bodyProgress = Container(
      decoration: const BoxDecoration(
        color: Colors.black54,
      ),

      child: Stack(
        children: [
          body,
          Center(child: FractionallySizedBox(
            
            widthFactor: 2/3,
            heightFactor: 1/4,
            alignment: Alignment.center,

            child: Container(

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.green[300],
                borderRadius: BorderRadius.circular(10)
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const[
                  Center(
                    child:SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text("Aspetta...", style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ))
                ],
              ),
            ),
          )),
        ],
      ),
    );

    return Scaffold(
      key: GlobalObjectKey("FORM"),
      appBar: AppBar(
        title: const Text("Completa la richiesta"),
      ),

      body: _isLoading ? bodyProgress : body,

      floatingActionButton: FloatingActionButton(
        onPressed: _onLoading,
        tooltip: "Manda richiesta",
        child: const Icon(Icons.send),
      ),

    );
  }
}