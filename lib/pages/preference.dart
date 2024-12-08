import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optimabatis/pages/felicitation.dart';

class Preference extends StatefulWidget {
  @override
  _PreferenceState createState() =>
      _PreferenceState();
}
class _PreferenceState extends State<Preference> {
  bool telephone = false;
  bool email = false;
  bool aucun = false;

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
            Container(child:
            Column(children: [
              Row(
                children: [
                  Checkbox(value: telephone, onChanged: (value) {
                    setState(() {
                      telephone = value!;
                    });
                  },),
                  Text("Par Téléphone",style: TextStyle(fontSize: 12),),],),
              Row(
                children: [
                  Checkbox(value: email, onChanged: (value) {
                    setState(() {
                      email = value!;
                    });
                  },),
                  Text("Par E-mail",style: TextStyle(fontSize: 12),),],),
              Row(
                children: [
                  Checkbox(value: aucun, onChanged: (value) {
                    setState(() {
                      aucun = value!;
                    });
                  },),
                  Text("Aucun, contactez-moi uniquement en cas de besoin",style: TextStyle(fontSize: 12),),],),
            ],),
            ),
            Spacer(),
            // Bouton suivant
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Felicitation()),
                  );
                },
                child: Text(
                  "Envoyez la demande",
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}