import 'package:flutter/material.dart';
import 'package:optimabatis/pages/home.dart';

class Felicitation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.indigo,
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Container(
              width: 350,
              height: 400,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                color: Colors.white,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    size: 70,
                    color: Colors.indigo,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Félicitations !',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Merci pour votre demande. Notre équipe vous contactera dans les plus brefs délais pour confirmer l’intervention.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                       Navigator.pushReplacement(
                                           context,
                                           MaterialPageRoute(builder: (context) => HomePage()),
                                         );
                    },
                    child: Text('Retour à l\'accueil',style: TextStyle(fontSize: 16, color: Colors.white),),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
