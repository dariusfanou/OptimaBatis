import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';

class Felicitation extends StatelessWidget {

  final Uri url = Uri.parse('https://me.fedapay.com/paiement-pour-optimabatis'); // Lien à ouvrir

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Color(0xFF3172B8),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Container(
              width: 350,
              height: 350,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                color: Colors.white,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    size: 70,
                    color: Color(0xFF3172B8),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Félicitations !',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF3172B8),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Merci de nous faire confiance.\nVeuillez procéder au paiement pour valider votre demande.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Link(
                      uri: url,
                      builder: (context, openLink) {
                        return SizedBox(
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
                            onPressed: openLink,
                            child: Text("Procéder au paiement",
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
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
                        context.go("/activities");
                      },
                      child: Text("Plus tard",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3172B8)
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
