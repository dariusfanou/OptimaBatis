import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/flutter_helpers/services/user_service.dart';
import 'package:optimabatis/pages/custom_navbar.dart';

class Publicite extends StatefulWidget {
  const Publicite({super.key});

  @override
  State<Publicite> createState() => _PubliciteState();
}

class _PubliciteState extends State<Publicite> {

  // Liste des chemins ou URLs des images
  final List<String> images = [
    'assets/images/ing-co.png',
    'assets/images/sat-bat.png',
    'assets/images/sicat-btp.jpg',
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
      body: ListView.builder(
        itemCount: images.length, // Nombre d'images dans la liste
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Coins arrondis pour les photos
              child: Image.asset(
                images[index], // Chemin de l'image
                fit: BoxFit.cover, // Ajuste l'image pour remplir l'espace
                height: 200, // Hauteur de l'image
                width: double.infinity, // Largeur qui prend tout l'espace
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomNavBar(currentIndex: 2),

    );
  }
}
