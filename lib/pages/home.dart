import 'package:flutter/material.dart';
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
    return
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
