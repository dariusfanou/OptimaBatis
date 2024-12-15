import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:optimabatis/flutter_helpers/services/intervention_service.dart';
import 'package:optimabatis/pages/custom_navbar.dart';
import 'package:optimabatis/pages/notification.dart';
import 'package:optimabatis/pages/detail_intervention.dart';
import 'package:optimabatis/pages/informatique.dart';
import '../flutter_helpers/services/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userService = UserService();
  Map<String, dynamic>? authUser;

  final images = [
    {'image': 'assets/images/Macon.png', 'text': "Maçon"},
    {'image': 'assets/images/Menuisier.png', 'text': "Menuisier"},
    {'image': 'assets/images/Plombier.png', 'text': "Plombier"},
    {'image': 'assets/images/Electricien.png', 'text': "Electricien"},
    {'image': 'assets/images/Peintre.png', 'text': "Peintre"},
    {'image': 'assets/images/Soudeur.png', 'text': "Soudeur"},
    {'image': 'assets/images/Tech_Solaire.png', 'text': "Tech.Solaire"},
    {'image': 'assets/images/Charpentier.png', 'text': "Charpentier"},
    {'image': 'assets/images/Frigoriste.png', 'text': "Frigoriste"},
    {'image': 'assets/images/Vitrier.png', 'text': "Vitrier"},
    {'image': 'assets/images/Carreleur.png', 'text': 'Carreleur'},
    {'image': 'assets/images/Reseau.png', 'text': "Réseau"},
    {'image': 'assets/images/Informatique.png', 'text': "Informatique"}
  ];

  final Color warningColor = Color(0xFFFFC107);
  final Color successColor = Color(0xFF28A745);
  final Color dangerColor = Color(0xFFdc3545);
  final Color secondaryColor = Color(0xFF007BFF);

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

  final interventionService = InterventionService();
  List<Map<String, dynamic>> interventions = [];
  List<Map<String, dynamic>> interventionsTerminer = [];
  List<Map<String, dynamic>> interventionsEncours = [];
  Map<String, dynamic> lastIntervention = {};

  loadInterventions() async {
    try {
      interventions = await interventionService.getAll();
      print(interventions);
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
    }

  }

  Future count() async {

    await loadInterventions();

    lastIntervention = await interventionService.get(interventions.length);

    for (Map<String, dynamic> intervention in interventions) {
      if(intervention["actif"] == "terminer") {
        interventionsTerminer.add(intervention);
      }
      if(intervention["actif"] == "en cour") {
        interventionsEncours.add(intervention);
      }
    }

  }

  @override
  void initState() {
    super.initState();
    getAuthUser();
    count();
  }

  var re_tot = 0, re_ter = 0, re_co = 0, num_req = 0, nomclient='John Doe', cat,price=1000;
  var date= "12 decembre2024, 20:20";

  @override
  Widget build(BuildContext context) {
    return (authUser != null && authUser!["is_staff"]) ?
    Scaffold(
      backgroundColor: Color(0xFFB0ACAC),
      appBar: AppBar(
        backgroundColor: Color(0xFFB0ACAC),
        automaticallyImplyLeading: false,
        title: Text(
          "Tableau de Bord",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.settings, size: 30.0))
        ],
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(
                    height: 80,
                    width: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width / 3.5,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Image.asset("assets/images/outils.png"),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            "${interventions.length}",
                            style: TextStyle(color: Colors.white, fontSize: 35),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Requêtes totales",
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width / 3.5,
                    decoration: BoxDecoration(
                        color: successColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Image.asset("assets/images/check.png"),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            "${interventionsTerminer.length}",
                            style: TextStyle(color: Colors.white, fontSize: 35),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Requêtes terminées",
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width / 3.5,
                    decoration: BoxDecoration(
                        color: warningColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Image.asset("assets/images/time.png"),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            "${interventionsEncours.length}",
                            style: TextStyle(color: Colors.white, fontSize: 35),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Requêtes en cours",
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Center(child: Row(
                  children: [
                    Container(height: 70,width: 65,child: Image(image: AssetImage("assets/images/plomberie.png")),),
                    SizedBox(
                      height: 8,width: 5,
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Text(
                            "Requête #${lastIntervention["id"]}",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "Client: ${lastIntervention["createur_info"]["username"] ?? "John Doe"}",
                            style: TextStyle(fontSize: 11),
                          ),
                          Text(
                            "Catégorie: ${lastIntervention["service"]}",
                            style: TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 8,),
                    CircleAvatar(
                      //backgroundImage: AssetImage("assetName"),
                      backgroundImage: lastIntervention['createur_info']["photo"] != null
                          ? NetworkImage(lastIntervention['createur_info']["photo"])
                          : const AssetImage('assets/images/profile.png') as ImageProvider,
                      radius: 25,
                    ),
                    SizedBox(width:15,),
                    Column(
                      children: [
                        SizedBox(height: 5,),
                        Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: interventionTag(lastIntervention["actif"])[1],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                interventionTag(lastIntervention["actif"])[0],
                                style: TextStyle(
                                    color: Colors.white),
                              ),
                            )),
                        SizedBox(height: 10,),
                        Icon(Icons.search,size: 30,)
                      ],
                    ),
                  ],
                ),)
                ,),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Row(
                  children: [
                    Container(height: 80,width: 65,child: Image(image: AssetImage("assets/images/cloche.png")),),
                    SizedBox(
                      height: 8,width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Text(
                            "Nouvelle requête créée",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            lastIntervention["created_at"],
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                    ),
                    SizedBox(width: 30,),
                    TextButton(onPressed: (){}, child:Text("Voir",style: TextStyle(color:Colors.blue),))
                  ],
                ),)
                ,),
              /*SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Row(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("${price} FCFA",style: TextStyle(color: successColor, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5,),
                    Text("Transaction par ${nomclient}",)
                  ],),
                  SizedBox(width: 10,),
                  Column(children: [
                    Text("${date} ", style: TextStyle(fontSize: 12),),
                    SizedBox(height: 25,width: 15,),
                    Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: successColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text("Réussi",style: TextStyle(color: Colors.white),),
                      ),
                    )
                  ],),
                ],),
              )*/
            ],
          ),
        )
      ),
    )
        :
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 120,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: authUser?['profilePicture'] != null
                  ? NetworkImage(authUser!['profilePicture'])
                  : const AssetImage('assets/images/profile.png') as ImageProvider,
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
            icon: const Icon(
              Icons.notifications_active_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: 150,
              decoration: BoxDecoration(
                color: Colors.limeAccent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: const Center(
                child: Text(
                  "PUBLICITÉ",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true, // Pour limiter la hauteur à son contenu
              physics: const NeverScrollableScrollPhysics(), // Désactiver le défilement interne
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3 / 4,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final item = images[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (item['text'] != 'Informatique') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsInterventionPage(
                                service: item['text'],
                                provenance: "accueil",
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Informatique()),
                          );
                        }
                      },
                      child: Image.asset(
                        item['image']!,
                        width: 60,
                        height: 60,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.error,
                            size: 60,
                            color: Colors.red,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['text']!,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(currentIndex: 0),
    );
  }
}
