import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optimabatis/pages/custom_navbar.dart';
import 'notification.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _clients = [
    'Lorem ipsum dolor sit amet, consectetur',
    'Lorem ipsum dolor sit amet, consectetur',
    // ... Ajoutez d'autres clients ici
  ];

  // Fonction pour filtrer les clients en fonction de la recherche
  List<String> _filterClients(String query) {
    return _clients.where((client) => client.toLowerCase().contains(query.toLowerCase())).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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

      ),
      body:Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Padding(

            padding: const EdgeInsets.all(10.0),
            child :TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher',
                 iconColor: Color.fromRGBO(114, 113, 112, 1.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35.0),
                  borderSide:BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(child: ListView.builder(
            itemCount: _filterClients(_searchController.text).length,
            itemBuilder: (context, index){
              return ListTile(
                title: Text(_filterClients(_searchController.text)[index]),
              );
            },
          ))
        ]
        
       


      ),
      bottomNavigationBar: CustomNavBar(currentIndex: 3),

    );
  }
}
