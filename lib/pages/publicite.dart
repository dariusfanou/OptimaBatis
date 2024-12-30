import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/auth_provider.dart';
import 'package:optimabatis/flutter_helpers/services/notification_service.dart';
import 'package:optimabatis/flutter_helpers/services/pub_service.dart';
import 'package:optimabatis/flutter_helpers/services/user_service.dart';
import 'package:optimabatis/pages/custom_navbar.dart';
import 'package:provider/provider.dart';

class Publicite extends StatefulWidget {
  const Publicite({super.key});

  @override
  State<Publicite> createState() => _PubliciteState();
}

class _PubliciteState extends State<Publicite> {

  final userService = UserService();
  Map<String, dynamic>? authUser;
  late AuthProvider authProvider;
  final pubService = PubService();
  bool loading = false;
  List<Map<String, dynamic>> pubs = [];

  Future<void> getAuthUser() async {
    setState(() {
      loading = true;
    });
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
    } catch(e){
      if (e is SocketException) {
        Fluttertoast.showToast(msg: "Pas d'accès Internet. Veuillez vérifier votre connexion.");
      } else {
        Fluttertoast.showToast(msg: "Une erreur inattendue est survenue.");
      }
    }
  }

  Future<void> loadPubs() async {
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
    } catch(e) {
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
    getAuthUser();
    loadPubs();
    loadNotifications();
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
      body:
      loading
          ? const Center(
        child: CircularProgressIndicator(), // Indicateur de chargement
      )
          : (pubs.length > 0) ?
      ListView.builder(
        itemCount: pubs.length, // Nombre de pubs dans la liste
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Coins arrondis pour les photos
              child: Image.network(
                pubs[index]["image"], // Chemin de l'image
                fit: BoxFit.cover, // Ajuste l'image pour remplir l'espace
                height: 200, // Hauteur de l'image
                width: double.infinity, // Largeur qui prend tout l'espace
              ),
            ),
          );
        },
      )
      : const Center(
        child: Text("Aucune publicité en cours"),
      ),
      bottomNavigationBar: CustomNavBar(currentIndex: 2),

    );
  }
}
