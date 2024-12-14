import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  var re_tot = 0, re_ter = 0, re_co = 0, num_req = 0, nomclient='John Doe', cat,price=1000;
  var date= "12 decembre2024, 20:20";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
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
                  width: 120,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.indigoAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Icon(
                        Icons.construction,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          "${re_tot}",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Requetes totales",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  width: 120,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Icon(
                        Icons.check_box,
                        color: Colors.greenAccent,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          "${re_ter}",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Requetes terminées",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  width: 120,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Icon(
                        Icons.hourglass_top,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          "${re_co}",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Requetes en cours",
                        style: TextStyle(color: Colors.white, fontSize: 12),
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
                width: 350,
                height: 80,
                decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(15)),
                child: Center(child: Row(
                  children: [
                    Container(height: 70,width: 65,child: Image(image: AssetImage("assetName")),),
                    SizedBox(
                      height: 8,width: 5,
                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Text(
                            "Requetes #${num_req}",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "Client:${nomclient}",
                            style: TextStyle(fontSize: 11),
                          ),
                          Text(
                            "Catégories:${cat}",
                            style: TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 8,),
                    CircleAvatar(
                      backgroundImage: AssetImage("assetName"),
                      radius: 25,
                    ),
                    SizedBox(width:15,),
                    Column(
                      children: [
                        SizedBox(height: 5,),
                        Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                "En attente",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
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
              width: 350,
              height: 70,
              decoration: BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.circular(15)),
              child: Center(child: Row(
                children: [
                  Container(height: 80,width: 65,child: Image(image: AssetImage("assetName")),),
                  SizedBox(
                    height: 8,width: 5,
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Text(
                          "Nouvelles requetes créée",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "${date}",
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30,),
                  TextButton(onPressed: (){}, child:Text("Voir",style: TextStyle(color:Colors.blue,fontSize: 14),))
                ],
              ),)
              ,),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 350,
              height: 80,
              decoration: BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(children: [
                Column(children: [
                  Text("${price} FCFA",style: TextStyle(color:Colors.green)),
                  SizedBox(height: 5,),
                  Text("Transaction par ${nomclient}",)
                ],),
                SizedBox(width: 10,),
                Column(children: [
                  Text("${date} "),
                  SizedBox(height: 25,width: 15,),
                  Container(width:110,height:30,decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(10)),child: Center(child: Text("Réussi",style: TextStyle(color: Colors.white),),),)
                ],),
              ],),
            )
          ],
        ),
      ),
    );
  }
}
