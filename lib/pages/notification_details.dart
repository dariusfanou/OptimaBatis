import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/auth_provider.dart';
import 'package:optimabatis/flutter_helpers/services/notification_service.dart';
import 'package:provider/provider.dart';

class NotificationDetails extends StatefulWidget {
  const NotificationDetails({super.key, required this.id});

  final String? id;

  @override
  State<NotificationDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {

  bool isLoading = false;
  late AuthProvider authProvider;
  final notificationService = NotificationService();
  Map<String, dynamic>? notification;

  Future<void> loadNotification() async {
    setState(() {
      isLoading = true;
    });
    try {
      notification = await notificationService.get(widget.id!);
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

  updateNotificationVisibility() async {

    try {

      Map<String, dynamic> data = {
        "is_read": true
      };

      await notificationService.update(data, widget.id!);

    } on DioException catch (e) {
      // Gérer les erreurs de la requête
      print(e.response?.statusCode);
      if (e.response != null) {
        if(e.response?.statusCode == 401) {
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }

  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    loadNotification();
    updateNotificationVisibility();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(notification?["title"] ?? "Titre indisponible",),
        leading: GestureDetector(
          onTap: () {
            GoRouter.of(context).pushReplacement("/notifications");
          },
          child: Row(
            children: [
              SizedBox(width: 28,),
              Expanded(
                  child: Image.asset("assets/images/back.png")
              )
            ],
          ),
        ),
      ),
      body: isLoading ?
      const Center(
        child: CircularProgressIndicator(), // Indicateur de chargement
      ) : Container(
        margin: EdgeInsets.all(10),
        child: Text(notification?["content"] ?? "Contenu indisponible", style: TextStyle(fontSize: 16,)),
      )
    );
  }
}
