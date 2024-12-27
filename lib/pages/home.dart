import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/auth_provider.dart';
import 'package:optimabatis/flutter_helpers/services/notification_service.dart';
import 'package:optimabatis/flutter_helpers/services/pub_service.dart';
import 'package:optimabatis/pages/custom_navbar.dart';
import 'package:provider/provider.dart';
import '../flutter_helpers/services/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userService = UserService();
  Map<String, dynamic>? authUser;
  late AuthProvider authProvider;

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
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        Fluttertoast.showToast(msg: "Votre session a expirée. Veuillez vous reconnecter.");
        authProvider.logout();
        context.go("/welcome");
      }
      print("Erreur lors de la récupération de l'utilisateur : $error");
    }
  }

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
    }
  }

  final pubService = PubService();
  bool loading = false;
  List<Map<String, dynamic>> pubs = [];
  int currentIndex = 0;
  final CarouselSliderController carouselController = CarouselSliderController();

  Future<void> loadPubs() async {
    setState(() {
      loading = true;
    });
    try {
      pubs = await pubService.getAll();
      pubs = pubs.reversed.toList();
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
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    getAuthUser();
    loadPubs();
    loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            loading
                ? Container(
              padding: EdgeInsets.symmetric(vertical: 8),
                child: const Center(
                  child: CircularProgressIndicator(), // Indicateur de chargement
                )
            )
                : (pubs.length > 0) ?
            CarouselSlider(
              carouselController: carouselController,
              options: CarouselOptions(
                height: 225,
                viewportFraction: 1.0,
                autoPlay: (pubs.length > 1) ? true : false, // Active le défilement automatique
                autoPlayInterval: Duration(seconds: 5), // Intervalle entre les diapositives
                autoPlayAnimationDuration: Duration(seconds: 1), // Durée de l'animation
                autoPlayCurve: Curves.easeInOut, // Courbe pour l'animation
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              items: pubs
                  .map((item) =>
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10), // Coins arrondis pour les photos
                          child: Image.network(
                            item["image"], // Chemin de l'image
                            fit: BoxFit.cover, // Ajuste l'image pour remplir l'espace
                            height: 200, // Hauteur de l'image
                            width: double.infinity, // Largeur qui prend tout l'espace
                          ),
                        ),
                      )
                  )
              ).toList(),
            ) :
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: EdgeInsets.all(16),
              height: 225,
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
                  "AUCUNE PUBLICITÉ DISPONIBLE",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
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
                            context.push("/typeDemande?service=${item['text']}&provenance=accueil");
                          } else {
                            context.push("/informatique");
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
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(currentIndex: 0),
      /*floatingActionButton: IconButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Color(0xFF3172B8)),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            padding: WidgetStatePropertyAll(EdgeInsets.all(16))
          ),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if(prefs.containsKey("chatHelper")) {
              context.push("/chat");
            }
            else {
              context.push("/chatHelper");
            }
          }, 
          icon: Icon(Icons.chat)
      ),*/
    );
  }
}
