import 'package:flutter/material.dart';
import 'package:optimabatis/pages/custom_navbar.dart';
import 'package:optimabatis/pages/notification.dart';

class Activity_onload extends StatefulWidget {
  const Activity_onload({super.key});

  @override
  _Activity_onloadState createState() => _Activity_onloadState();
}

class _Activity_onloadState extends State<Activity_onload> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Nombre d'onglets : "En cours" et "Historique"
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          toolbarHeight: 120,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(
                    'assets/images/african-american-woman-black-long-sleeve-tee-portrait.jpg'),
              ),
              SizedBox(width: 70),
              Image.asset("assets/images/logotype.png",width: 150,height: 150,),
              Spacer(),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_active_outlined, color: Colors.black),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NotificationPage()),);
              },
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: "En cours"),
              Tab(text: "Historique"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contenu pour l'onglet "En cours"
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.hourglass_empty, size: 60, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "Aucune activité en cours",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Toutes vos activités en cours apparaîtront ici, vous pourrez les suivre.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              )
            ),
            // Contenu pour l'onglet "Historique"
            Center(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sync, size: 60, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "Aucune demande enregistrée",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Toutes vos demandes enregistrées apparaîtront ici, vous pourrez les consulter.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
        bottomNavigationBar: CustomNavBar(currentIndex: 1),
      ),
    );
  }
}
