import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:optimabatis/flutter_helpers/services/intervention_service.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

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
    count();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              "Requête #${lastIntervention["id"]!}",
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              "Client: ${lastIntervention["createur_info"]!["username"]! ?? "John Doe"}",
                              style: TextStyle(fontSize: 11),
                            ),
                            Text(
                              "Catégorie: ${lastIntervention["service"]!}",
                              style: TextStyle(fontSize: 11),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 8,),
                      CircleAvatar(
                        //backgroundImage: AssetImage("assetName"),
                        backgroundImage: lastIntervention['createur_info']!["photo"]! != null
                            ? NetworkImage(lastIntervention['createur_info']!["photo"]!)
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
                                color: interventionTag(lastIntervention["actif"]!)[1],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  interventionTag(lastIntervention["actif"]!)[0],
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
                              lastIntervention["created_at"]!,
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
    );
  }
}
