import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/flutter_helpers/services/user_service.dart';
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

  final userService = UserService();
  Map<String, dynamic>? authUser;

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

  @override
  void initState() {
    super.initState();
    getAuthUser();
  }

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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: authUser?['photo'] != null
                  ? NetworkImage(authUser!['photo'])
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
                )
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined, color: Colors.black),
            onPressed: () {
              context.go("/notifications");
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
        ]
      ),
      bottomNavigationBar: CustomNavBar(currentIndex: 3),

    );
  }
}
