import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/auth_provider.dart';

import 'package:optimabatis/flutter_helpers/services/intervention_service.dart';
import 'package:optimabatis/flutter_helpers/services/notification_service.dart';
import 'package:optimabatis/flutter_helpers/services/user_service.dart';
import 'package:optimabatis/pages/custom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late AuthProvider authProvider;

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

  final Uri url = Uri.parse('https://me.fedapay.com/paiement-pour-optimabatis'); // Lien à ouvrir

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
    } on DioException catch (error) {
      if(error.response != null && error.response?.statusCode == 401) {
        Fluttertoast.showToast(msg: "Votre session a expirée. Veuillez vous reconnecter.");
        authProvider.logout();
        context.go("/welcome");
      }
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
      interventions = interventions.reversed.toList();
      for(Map<String, dynamic> intervention in interventions) {
        if(intervention["actif"] == "en cour") {
          interventionsEncours.add(intervention);
        }
      }
      setState(() {});
    } on DioException catch (e) {
      if (e.response != null) {
        if(e.response?.statusCode == 401) {
          Fluttertoast.showToast(msg: "Votre session a expirée. Veuillez vous reconnecter.");
          authProvider.logout();
          context.go("/welcome");
        }
        print(e.response?.data);
        print(e.response?.statusCode);
      } else {
        print(e.requestOptions);
        print(e.message);
      }

      Fluttertoast.showToast(msg: "Une erreur est survenue");
    } catch (e) {
      if (e is SocketException) {
        Fluttertoast.showToast(msg: "Pas d'accès Internet. Veuillez vérifier votre connexion.");
      } else {
        Fluttertoast.showToast(msg: "Une erreur inattendue est survenue.");
      }
    }
    finally {
      setState(() {
        loading = false;
      });
    }
  }

  Map<String, String> Demandes = {
    "panneDevis": "Signalement de panne",
    "rennovationTotale": "Demande de rénovation totale de bâtiment",
    "rennovationPartielle": "Demande de rénovation partielle de bâtiment",
    "construction": "Construction",
    "informatique": "Informatique et réseaux"
  };

  final notificationService = NotificationService();
  List<Map<String, dynamic>> notifications = [];
  List<Map<String, dynamic>> notificationsNotRead = [];

  Future<void> loadNotifications() async {
    try {
      notifications = await notificationService.getAll();
      for (Map<String, dynamic> notification in notifications) {
        if(!notification["is_read"]) {
          notificationsNotRead.add(notification);
        }
      }
      setState(() {});
    } on DioException catch (e) {
      if (e.response != null) {
        if(e.response?.statusCode == 401) {
          Fluttertoast.showToast(msg: "Votre session a expirée. Veuillez vous reconnecter.");
          authProvider.logout();
          context.go("/welcome");
        }
        print(e.response?.data);
        print(e.response?.statusCode);
      } else {
        print(e.requestOptions);
        print(e.message);
      }

      Fluttertoast.showToast(msg: "Une erreur est survenue");
    } catch(e) {
      if (e is SocketException) {
        Fluttertoast.showToast(msg: "Pas d'accès Internet. Veuillez vérifier votre connexion.");
      } else {
        Fluttertoast.showToast(msg: "Une erreur inattendue est survenue.");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    loadInterventions();
    getAuthUser(); // Chargez les informations utilisateur
    loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
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
              icon: (notificationsNotRead.length > 0) ? Badge(
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.black,
                ),
                label: Text("${notificationsNotRead.length}"),
              ) :
              const Icon(
                Icons.notifications_active_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                context.push("/notifications");
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
                                Row(
                                  children: [
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
                                    SizedBox(width: 8,),
                                    (interventions[index]["actif"] == "en attente") ?
                                    TextButton(
                                        onPressed: () async {
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          }
                                        },
                                        child: Text("Procéder au paiement"),
                                    ) : SizedBox(),
                                  ],
                                )
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
