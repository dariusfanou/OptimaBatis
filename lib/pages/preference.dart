import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/auth_provider.dart';
import 'package:optimabatis/flutter_helpers/services/intervention_service.dart';
import 'package:optimabatis/flutter_helpers/services/notification_service.dart';
import 'package:optimabatis/flutter_helpers/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference extends StatefulWidget {
  @override
  _PreferenceState createState() =>
      _PreferenceState();
}
class _PreferenceState extends State<Preference> {
  int? _value = 1;
  String? preference;
  bool loading = false;
  late AuthProvider authProvider;

  final interventionService = InterventionService();

  createIntervention() async {
    setState(() {
      loading = true;
    });

    try {

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? demande = await prefs.getString('demande');
      final String? description = await prefs.getString('description');
      final String? date = await prefs.getString('date');
      final String? hour = await prefs.getString('hour');
      final String? image0 = await prefs.getString('image0');
      final String? image1 = await prefs.getString('image1');
      final String? image2 = await prefs.getString('image2');
      final String? service = await prefs.getString('service');

      FormData formData = FormData.fromMap({
        'typedemande': demande,
        'description': description,
        'date': date,
        'heure': hour,
        'preferencecontact': preference,
        'service': service,
        'image0': image0 != null ? await MultipartFile.fromFile(image0, filename: 'image0.jpg') : null,
        'image1': image1 != null ? await MultipartFile.fromFile(image1, filename: 'image1.jpg') : null,
        'image2': image2 != null ? await MultipartFile.fromFile(image2, filename: 'image2.jpg') : null,
      });

      Map<String, dynamic> response = await interventionService.create(formData);

      prefs.setInt("interventionId", response["id"]);

      await createNotification();

      context.go('/congratulations');

    } on DioException catch (e) {

      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          Fluttertoast.showToast(msg: "Votre session a expirée. Veuillez vous reconnecter.");
          authProvider.logout();
          context.go("/welcome");
        }
        print(e.response?.data);
        print(e.response?.statusCode);
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

      Fluttertoast.showToast(msg: "Une erreur est survenue");

    } catch (e) {
      if (e is SocketException) {
        Fluttertoast.showToast(msg: "Pas d'accès Internet. Veuillez vérifier votre connexion.");
      } else {
        Fluttertoast.showToast(msg: "Une erreur inattendue est survenue.");
      }
    }


  }

  final notificationService = NotificationService();

  createNotification() async {

    try {

      Map<String, dynamic> data = {
        "title": "Demande créée avec succès",
        "content": "Votre demande a été bien enregistrée.\nElle est actuellement en attente et sera validée après le paiement.\nRendez-vous dans votre historique pour accéder au lien de paiement.",
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
      if (e is SocketException) {
        Fluttertoast.showToast(msg: "Pas d'accès Internet. Veuillez vérifier votre connexion.");
      } else {
        Fluttertoast.showToast(msg: "Une erreur inattendue est survenue.");
      }
      Fluttertoast.showToast(msg: "Une erreur inattendue s'est produite.");
    } finally {
      setState(() {
        loading = false;
      });
    }

  }

  final userService = UserService();
  Map<String, dynamic>? authUser;
  bool isLoading = true;

  Future<void> getAuthUser() async {
    try {
      final user = await userService.getUser();
      setState(() {
        authUser = user;
        isLoading = false;
        print(authUser);
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Fluttertoast.showToast(msg: "Votre session a expirée. Veuillez vous reconnecter.");
        authProvider.logout();
        context.go("/welcome");
      }
      print('Erreur lors de la récupération des données utilisateur : $e');
    } catch (e) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            GoRouter.of(context).pop();
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
        title: Text("Préférences de contact"),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      ) :
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicateur de progression
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 5),
                  CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child:CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white, )
                  ),
                  SizedBox(width: 5),
                  CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child:CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white, )
                  ),
                  SizedBox(width: 5),
                  CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child:CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white, )
                  ),
                  SizedBox(width: 5),
                  CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child:CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.blue, )
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Préférence de contact :",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                _buildRadioOption(1, "Par téléphone"),
                _buildRadioOption(2, "Par email"),
                _buildRadioOption(3, "Aucune, contactez-moi uniquement en cas de besoin"),
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xFF3172B8)),
                    elevation: WidgetStatePropertyAll(0),
                    shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                          side: BorderSide(color: Color(0xFF707070), width: 1),
                        )
                    ),
                    foregroundColor: WidgetStatePropertyAll(Colors.white)
                ),
                onPressed: () async {
                  if (_value == null) {
                    Fluttertoast.showToast(msg: "Veuillez sélectionner une option");
                    return;
                  }
                  switch (_value) {
                    case 1:
                      preference = "telephone";
                      break;
                    case 2:
                      preference = "email";
                      break;
                    case 3:
                      preference = "aucune";
                      break;
                  }
                  await createIntervention();
                },
                child: loading ?
                    SizedBox(
                      height: 19,
                        width: 19,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,)
                    ) :
                Text("Envoyez la demande",
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour construire une option radio
  Widget _buildRadioOption(int value, String label) {
    return Row(
      children: [
        Radio<int>(
          value: value,
          groupValue: _value,
          onChanged: (value) {
            if(value == 2 && (authUser!["email"] == null || authUser!["email"].isEmpty)) {
              setState(() {
                _value = 1;
                Fluttertoast.showToast(msg: "Vous n'avez pas renseigner d'email");
              });
            }
            else {
              setState(() {
                _value = value;
              });
            }
          },
        ),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}