import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/pages/description_date.dart';
import 'package:optimabatis/pages/home.dart';
import 'package:optimabatis/pages/informatique.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsInterventionPage extends StatefulWidget {

  const DetailsInterventionPage({super.key, this.service, this.provenance});

  final String? service;
  final String? provenance;

  @override
  _DetailsInterventionPageState createState() =>
      _DetailsInterventionPageState();
}

class _DetailsInterventionPageState extends State<DetailsInterventionPage> {
  int? _value = 1; // Valeur par défaut sélectionnée (option 1)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if(widget.provenance == "informatique") {
              context.go("/informatique");
            }
            else {
              context.go("/home");
            }
          },
        ),
        title: Text("Détails de l'intervention"),
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
                children: List.generate(
                  4,
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: index == 0 ? Colors.blue : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Type de demande :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                _buildRadioOption(1, "Signalement de panne"),
                _buildRadioOption(2, "Demande de rénovation totale de bâtiment"),
                _buildRadioOption(3, "Construction"),
                _buildRadioOption(4, "Informatique et réseaux"),
              ],
            ),
            Spacer(),
            // Bouton suivant
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF3172B8)),
                  elevation: MaterialStateProperty.all(0),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                    side: BorderSide(color: Color(0xFF707070), width: 1),
                  )),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () async {
                  if (_value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Veuillez sélectionner une option")),
                    );
                    return;
                  }
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString("service", widget.service!);
                  switch (_value) {
                    case 1:
                      await prefs.setString("demande", "panneDevis");
                      break;
                    case 2:
                      await prefs.setString("demande", "rennovationTotale");
                      break;
                    case 3:
                      await prefs.setString("demande", "construction");
                      break;
                    case 4:
                      await prefs.setString("demande", "informatique");
                      break;
                  }
                  context.go("/describeIntervention");
                },
                child: Text(
                  "Suivant",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
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
