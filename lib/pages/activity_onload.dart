import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';

import 'package:optimabatis/flutter_helpers/services/intervention_service.dart';
import 'package:optimabatis/flutter_helpers/services/user_service.dart';
import 'package:optimabatis/pages/custom_navbar.dart';
import 'package:optimabatis/pages/notification.dart';

class Activity_onload extends StatefulWidget {
  const Activity_onload({super.key});

  @override
  _Activity_onloadState createState() => _Activity_onloadState();
}

class _Activity_onloadState extends State<Activity_onload>
    with SingleTickerProviderStateMixin {
  final userService = UserService();
  final interventionService = InterventionService();
  Map<String, dynamic>? authUser;

  bool loading = true;
  List<Map<String, dynamic>> interventions = [];
  List<Map<String, dynamic>> interventionsEncours = [];

  final Color warningColor = Color(0xFFFFC107);
  final Color successColor = Color(0xFF28A745);
  final Color dangerColor = Color(0xFFdc3545);
  final Color secondaryColor = Color(0xFF007BFF);
  final Color infoColor = Color(0xFF6c757d);

  List<dynamic> interventionTag(String status) {
    switch (status) {
      case "en cour":
        return ["En cours", secondaryColor];
      case "en attente":
        return ["En attente", warningColor];
      case "annuler":
        return ["Annulé", dangerColor];
      case "terminer":
        return ["Terminé", successColor];
      default:
        return ["Inconnu", Colors.grey];
    }
  }

  Future<void> getAuthUser() async {
    try {
      final user = await userService.getUser();
      if (user != null) {
        setState(() {
          authUser = user;
        });
      } else {
        print("Aucun utilisateur authentifié trouvé.");
      }
    } catch (error) {
      print("Erreur lors de la récupération de l'utilisateur : $error");
    }
  }

  Future<void> loadInterventions() async {
    setState(() {
      loading = true;
      interventionsEncours.clear();
    });
    try {
      interventions = await interventionService.getAll();
      for(Map<String, dynamic> intervention in interventions) {
        if(intervention["actif"] == "en cour") {
          interventionsEncours.add(intervention);
        }
      }
      setState(() {});
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.statusCode);
      } else {
        print(e.requestOptions);
        print(e.message);
      }

      Fluttertoast.showToast(msg: "Une erreur est survenue");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Map<String, String> Demandes = {
    "panneDevis": "Signalement de panne et de devis",
    "rennovationTotale": "Demande de rénovation totale de bâtiment",
    "rennovationPartielle": "Demande de rénovation partielle de bâtiment",
    "construction": "Construction",
    "informatique": "Informatique et réseaux"
  };

  @override
  void initState() {
    super.initState();
    loadInterventions();
    getAuthUser(); // Chargez les informations utilisateur
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                backgroundImage: authUser?['photo'] != null
                    ? NetworkImage(authUser!['photo'])
                    : const AssetImage('assets/images/profile.png')
                as ImageProvider,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/logotype.png",
                    width: 150,
                    height: 200,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_active_outlined,
                  color: Colors.black),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              },
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: const [
              Tab(text: "En cours"),
              Tab(text: "Historique"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contenu pour l'onglet "En cours"
            loading
                ? const Center(
              child: CircularProgressIndicator(), // Indicateur de chargement
            )
                : (interventionsEncours.isNotEmpty)
                ? Container(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: interventionsEncours.length,
                itemBuilder: (context, index) {
                  return Card(
                      elevation: 0,
                      child: Column(
                        children: [
                          ListTile(
                            leading: (interventionsEncours[index]["image0"] != null) ? Image.network(interventionsEncours[index]["image0"]) : Icon(Icons.build),
                            title: Text(Demandes["${interventionsEncours[index]["typedemande"]}"]!, style: TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(interventionsEncours[index]["description"] ?? "Contenu non disponible",),
                                Text("Date: ${interventionsEncours[index]["date"]}, ${interventionsEncours[index]["heure"]}"),
                                Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      color: interventionTag(interventionsEncours[index]["actif"])[1],
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Text(
                                    interventionTag(interventionsEncours[index]["actif"])[0],
                                    style: TextStyle(color: Colors.white), // Couleur du texte
                                  ),
                                ),
                              ],
                            ),
                            tileColor: Colors.white,
                          ),

                        ],
                      )
                  );
                },
              ),
            )
                : Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Color(0xFFE6E6E6),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Image(
                          image: AssetImage("assets/images/encours.png"),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Aucune activité en cours",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Toutes vos activités en cours apparaîtront ici, vous pourrez les suivre.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            // Contenu pour l'onglet "Historique"
            loading
                ? const Center(
              child: CircularProgressIndicator(), // Indicateur de chargement
            )
                : (interventions.isNotEmpty)
                ? Container(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: interventions.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                      child: Column(
                        children: [
                          ListTile(
                            leading: (interventions[index]["image0"] != null) ? Image.network(interventions[index]["image0"]) : Icon(Icons.build),
                            title: Text(Demandes["${interventions[index]["typedemande"]}"]!, style: TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(interventions[index]["description"] ?? "Contenu non disponible",),
                                Text("Date: ${interventions[index]["date"]}, ${interventions[index]["heure"]}"),
                                Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: interventionTag(interventions[index]["actif"])[1],
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Text(
                                    interventionTag(interventions[index]["actif"])[0],
                                    style: TextStyle(color: Colors.white), // Couleur du texte
                                  ),
                                ),
                              ],
                            ),
                            tileColor: Colors.white,
                          ),

                        ],
                      )
                  );
                },
              ),
            )
                : Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Color(0xFFE6E6E6),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Image(
                          image: AssetImage(
                              "assets/images/historique.png"),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Aucune demande enregistrée",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Toutes vos demandes enregistrées apparaîtront ici, vous pourrez les consulter.",
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomNavBar(currentIndex: 1),
      ),
    );
  }
}
