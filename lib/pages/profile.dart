import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/auth_provider.dart';
import 'package:optimabatis/flutter_helpers/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userService = UserService();
  Map<String, dynamic>? authUser;
  bool isLoading = true;
  late AuthProvider authProvider;

  Future<void> getAuthUser() async {
    try {
      final user = await userService.getUser();
      setState(() {
        authUser = user;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erreur lors de la récupération des données utilisateur : $e');
    }
  }

  logoutUser() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

    authProvider.logout();

    // Rediriger vers la page de connexion
    context.go("/welcome");

  }

  deleteUser() async {

    try {

      await userService.deleteUser();

      Fluttertoast.showToast(msg: "Compte supprimé avec succès");

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove("token");

      authProvider.logout();

      // Rediriger vers la page de connexion
      context.go("/welcome");

    } on DioException catch (e) {
      // Gérer les erreurs de la requête
      print(e.response?.statusCode);
      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          Fluttertoast.showToast(msg: "Votre session a expirée. Veuillez vous reconnecter.");
          authProvider.logout();
          context.go("/welcome");
        }
        Fluttertoast.showToast(msg: "Erreur du serveur : ${e.response?.statusCode}");
      } else {
        // Gérer les erreurs réseau
        if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
          Fluttertoast.showToast(msg: "Temps de connexion écoulé. Vérifiez votre connexion Internet.");
        } else if (e.type == DioExceptionType.unknown) {
          Fluttertoast.showToast(msg: "Impossible de se connecter au serveur. Vérifiez votre réseau.");
        } else {
          Fluttertoast.showToast(msg: "Une erreur est survenue.");
        }
      }
    } catch (e) {
      // Gérer d'autres types d'erreurs
      Fluttertoast.showToast(msg: "Une erreur inattendue s'est produite.");
    }

  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    getAuthUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF3172B8),
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: const Center(
                      child: Text(
                        "Profil",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          authUser?["photo"] ?? 'assets/images/profile.png',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                authUser?["last_name"] ?? 'Nom inconnu',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                authUser?["first_name"] ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            authUser?["numtelephone"] ?? 'Téléphone inconnu',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            authUser?["email"] ?? 'Email inconnu',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 300,
              height: 450,
              color: Colors.white60,
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Modifier le profil'),
                    onTap: () {
                      context.push("/editProfile");
                    },
                  ),
                  /*ListTile(
                    leading: const Icon(Icons.translate),
                    title: const Text('Langue'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.group_add),
                    title: const Text('Parrainez un ami'),
                    onTap: () {},
                  ),*/
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Historique de mes activités'),
                    onTap: () {
                      context.push("/activities");
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notifications / Alertes'),
                    onTap: () {
                      context.push("/notifications");
                    },
                  ),
                  /*ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Modifier mot de passe'),
                    onTap: () {
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return AuthentificationPage();
                          })
                      );*/
                    },
                  ),*/
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Supprimer le compte'),
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Suppression du compte"),
                              content: const Text("Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible."),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      context.pop("Non");
                                    },
                                    child: const Text("Non")
                                ),
                                TextButton(
                                    onPressed: () async {
                                      await deleteUser();
                                    },
                                    child: const Text("Oui", style: TextStyle(color: Colors.red),)
                                ),
                              ],
                            );
                          }
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Déconnexion'),
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Déconnexion"),
                              content: const Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      context.pop("Non");
                                    },
                                    child: const Text("Non")
                                ),
                                TextButton(
                                    onPressed: () async {
                                      await logoutUser();
                                    },
                                    child: const Text("Oui", style: TextStyle(color: Colors.red),)
                                ),
                              ],
                            );
                          }
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Conditions générales d\'utilisation',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(currentIndex: 4),
    );
  }
}
