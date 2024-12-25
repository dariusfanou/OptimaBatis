import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHelper extends StatelessWidget {
  const ChatHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Text("Bonjour 👋, bienvenue sur OptimaBâtis !\nDiscutez avec notre support à travers notre système de messagerie intégrée. Nous mettons tout en oeuvre pour vous répondre dans les plus brefs délais.",
              style: TextStyle(
                fontSize: 16
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Color(0xFF3172B8)),
                    elevation: WidgetStateProperty.all(0),
                    shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                          side: BorderSide(color: Color(0xFF707070), width: 1),
                        )
                    ),
                    foregroundColor: WidgetStateProperty.all(Colors.white)
                ),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool("chatHelper", true);
                  context.pushReplacement("/chat");
                },
                child: Text("Démarrer",
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
