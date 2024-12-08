import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optimabatis/pages/description_date.dart';

class DetailsInterventionPage extends StatefulWidget {
  @override
  _DetailsInterventionPageState createState() =>
      _DetailsInterventionPageState();
}

class _DetailsInterventionPageState extends State<DetailsInterventionPage> {
  bool panneDevis = false;
  bool renovationTotale = false;
  bool renovationPartielle = false;
  bool construction = false;
  bool informatique = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
                children: [
                  SizedBox(width: 5),
                  CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.blue,
                      )),
                  SizedBox(width: 5),
                  CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white,
                      )),
                  SizedBox(width: 5),
                  CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white,
                      )),
                  SizedBox(width: 5),
                  CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white,
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Type de demande :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: panneDevis,
                        onChanged: (value) {
                          setState(() {
                            panneDevis = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                        "Signalement de panne et de devis",
                        style: TextStyle(fontSize: 13),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: renovationTotale,
                        onChanged: (value) {
                          setState(() {
                            renovationTotale = value!;
                          });
                        },
                      ),
                      Expanded(child: Text(
                        "Demande de rénovation totale de bâtiment",
                        style: TextStyle(fontSize: 13),
                      ),)
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: renovationPartielle,
                        onChanged: (value) {
                          setState(() {
                            renovationPartielle = value!;
                          });
                        },
                      ),
                      Expanded(child: Text(
                        "Demande de rénovation partielle de bâtiment",
                        style: TextStyle(fontSize: 13),
                      ),)
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: construction,
                        onChanged: (value) {
                          setState(() {
                            construction = value!;
                          });
                        },
                      ),
                      Expanded(child: Text(
                        "Construction",
                        style: TextStyle(fontSize: 13),
                      ),)
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: informatique,
                        onChanged: (value) {
                          setState(() {
                            informatique = value!;
                          });
                        },
                      ),
                      Expanded(child: Text(
                        "Informatique et réseaux",
                        style: TextStyle(fontSize: 13),
                      ),)
                    ],
                  ),
                ],
              ),
            ),

            // Liste des cases à cocher

            Spacer(),
            // Bouton suivant
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Description()),
                  );
                },
                child: Text(
                  "Suivant",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
