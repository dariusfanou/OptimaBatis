import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:optimabatis/pages/document_photos.dart';

class Description extends StatefulWidget {
  const Description({super.key});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
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
        title: Text("Description et Date de l'intervention",style: TextStyle(fontSize: 14),),
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
                        backgroundColor: Colors.white,
                      )),
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
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Description de la panne/Service demandé*",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              maxLines: 12,
              decoration: InputDecoration(
                  hintText:
                      "Décrivez en quelques mots le probleme ou le services souhaité",
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 8),
            Text(
              "Date et heure souhaitées pour l'intervention",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 0,
              width: 0,
            ),
            Text("Choisissez une date"),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Sélection du jour
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(4),
                                  ),
                                ),
                              ),
                              Text(
                                "JJ",
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                          Text(" - "),
                          Column(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(4),
                                  ),
                                ),
                              ),
                              Text(
                                "MM",
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                          Text(" - "),
                          Column(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(4),
                                  ),
                                ),
                              ),
                              Text(
                                "AA",
                                style: TextStyle(fontSize: 11),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],

            ),
            SizedBox(height: 25,),
            Text("Choisissez une plage horaire préféreée si vous avez une préférence."),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Sélection du jour
                Expanded(
                  child: Column(
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(4),
                                  ),
                                ),
                              ),
                              Text(
                                "H",
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                          Text(" - "),
                          Column(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(4),
                                  ),
                                ),
                              ),
                              Text(
                                "M",
                                style: TextStyle(fontSize: 11),
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
                    MaterialPageRoute(builder: (context) => DocumentPhotoPage()),
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
