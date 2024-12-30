import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsInterventionPage extends StatefulWidget {

  const DetailsInterventionPage({super.key, this.service});

  final String? service;

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
        leading: GestureDetector(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: Row(
            children: [
              SizedBox(width: 28,),
              Expanded(
                  child: Image.asset("assets/images/back.png")
              )
            ],
          ),
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
                _buildRadioOption(3, "Demande de rénovation partielle de bâtiment"),
                _buildRadioOption(4, "Construction"),
                _buildRadioOption(5, "Informatique et réseaux"),
              ],
            ),
            Spacer(),
            // Bouton suivant
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Color(0xFF3172B8)),
                  elevation: WidgetStateProperty.all(0),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
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
                      await prefs.setString("demande", "rennovationPartielle");
                      break;
                    case 4:
                      await prefs.setString("demande", "construction");
                      break;
                    case 5:
                      await prefs.setString("demande", "informatique");
                      break;
                  }
                  context.push("/describeIntervention");
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
