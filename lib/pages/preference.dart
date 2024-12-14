import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:optimabatis/flutter_helpers/services/intervention_service.dart';
import 'package:optimabatis/pages/document_photos.dart';
import 'package:optimabatis/pages/felicitation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference extends StatefulWidget {
  @override
  _PreferenceState createState() =>
      _PreferenceState();
}
class _PreferenceState extends State<Preference> {
  int? _value = 1;
  String? preference;

  final interventionService = InterventionService();

  createIntervention() async {
    try {

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? demande = await prefs.getString('demande');
      final String? description = await prefs.getString('description');
      final String? date = await prefs.getString('date');
      final String? hour = await prefs.getString('hour');
      final String? image0 = await prefs.getString('image0');
      final String? image1 = await prefs.getString('image1');
      final String? image2 = await prefs.getString('image2');
      final String? service = await prefs.getString('service');

      Map<String, dynamic> data = {
        'typedemande': demande,
        "description": description,
        "date": date,
        'heure': hour,
        'image0': image0,
        'image1': image1,
        'image2': image2,
        "preferencecontact": preference,
        "service" : service
      };

      await interventionService.create(data);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Felicitation()),
      );

    } on DioException catch (e) {

      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.statusCode);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }

      Fluttertoast.showToast(msg: "Une erreur est survenue");

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return DocumentPhotoPage();
                })
            );
          },
        ),
        title: Text("Preferences de Contact"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicateur de progression
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 5),
                  CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child:CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white, )
                  ),
                  SizedBox(width: 5),
                  CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child:CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white, )
                  ),
                  SizedBox(width: 5),
                  CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child:CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white, )
                  ),
                  SizedBox(width: 5),
                  CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child:CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.blue, )
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Type de demande :",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                _buildRadioOption(1, "Par téléphone"),
                _buildRadioOption(2, "Par email"),
                _buildRadioOption(3, "Aucune, contactez-moi uniquement en cas de besoin"),
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xFF3172B8)),
                    elevation: WidgetStatePropertyAll(0),
                    shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                          side: BorderSide(color: Color(0xFF707070), width: 1),
                        )
                    ),
                    foregroundColor: WidgetStatePropertyAll(Colors.white)
                ),
                onPressed: () async {
                  if (_value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Veuillez sélectionner une option")),
                    );
                    return;
                  }
                  switch (_value) {
                    case 1:
                      preference = "telephone";
                      break;
                    case 2:
                      preference = "email";
                      break;
                    case 3:
                      preference = "aucune";
                      break;
                  }
                  await createIntervention();
                },
                child: Text("Envoyez la demande",
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour construire une option radio
  Widget _buildRadioOption(int value, String label) {
    return Row(
      children: [
        Radio<int>(
          value: value,
          groupValue: _value,
          onChanged: (value) {
            setState(() {
              _value = value;
            });
          },
        ),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}