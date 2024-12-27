import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/auth_provider.dart';
import 'package:optimabatis/flutter_helpers/services/intervention_service.dart';
import 'package:optimabatis/flutter_helpers/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CongratulationsPage extends StatefulWidget {
  const CongratulationsPage({super.key});

  @override
  State<CongratulationsPage> createState() => _CongratulationsPageState();
}

class _CongratulationsPageState extends State<CongratulationsPage> {

  final notificationService = NotificationService();
  final interventionSerice = InterventionService();
  late AuthProvider authProvider;
  bool isLoading = false;

  updateInterventionStatus() async {
    setState(() {
      isLoading = true;
    });

    try {

      Map<String, dynamic> data = {
        "actif": "en cour"
      };

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int interventionId = prefs.getInt("interventionId") ?? 1;

      await interventionSerice.update(data, interventionId);

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
    }

  }

  createNotification() async {

    try {

      Map<String, dynamic> data = {
        "title": "Demande validée avec succès",
        "content": "Votre demande a été bel et bien validée.",
        "receiver": 1
      };

      await notificationService.create(data);

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
    updateInterventionStatus();
    createNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading ?
        const Center(
          child: CircularProgressIndicator(), // Indicateur de chargement
        ) : Container(
          color: Color(0xFF3172B8),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Container(
              width: 350,
              height: 400,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                color: Colors.white,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    size: 70,
                    color: Color(0xFF3172B8),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Félicitations !',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF3172B8),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Merci d\'avoir valider votre demande. Notre équipe vous contactera dans les plus brefs délais pour confirmer l’intervention.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3172B8),
                      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      context.pushReplacement('/activities');
                    },
                    child: Text('Mes demandes',style: TextStyle(fontSize: 16, color: Colors.white),),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}

