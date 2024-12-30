import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/auth_provider.dart';
import 'package:optimabatis/flutter_helpers/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../flutter_helpers/services/user_service.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final userService = UserService();
  bool isLoading = false;
  bool loading = false;
  late AuthProvider authProvider;
  late String? firstname;
  late String? lastname;
  late String? number;
  late String? password;
  late SharedPreferences? prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  loginUser(String goal) async {

    try {
      prefs = await SharedPreferences.getInstance();

      // Prépare les données à envoyer
      Map<String, dynamic> data = {
        'numtelephone': number,
        'password': password
      };

      // Lancer la requête
      Map<String, dynamic> authUser = await userService.login(data);

      // Sauvegerder le token en mémoire
      prefs?.setString("token", authUser['access']!);

      authProvider.login();

      await createNotification(goal);

      // Rediriger vers la page d'accueil
      context.go("/home");

    } on DioException catch (e) {
      // Gérer les erreurs de la requête
      print(e.response?.statusCode);
      if (e.response != null) {
        if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
          Fluttertoast.showToast(msg: "Identifiants invalides.");
        } else {
          Fluttertoast.showToast(msg: "Erreur du serveur : ${e.response?.statusCode}");
        }
      } else {
        // Gérer les erreurs réseau
        if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
          Fluttertoast.showToast(msg: "Temps de connexion écoulé. Vérifiez votre connexion Internet.");
        } else if (e.type == DioExceptionType.unknown) {
          Fluttertoast.showToast(msg: "Impossible de se connecter au serveur. Vérifiez votre réseau.");
        } else {
          Fluttertoast.showToast(msg: "Une erreur est survenue $e");
          print(e);
        }
      }
    } catch (e) {
      // Gérer d'autres types d'erreurs
      if (e is SocketException) {
        Fluttertoast.showToast(msg: "Pas d'accès Internet. Veuillez vérifier votre connexion.");
      } else {
        Fluttertoast.showToast(msg: "Une erreur inattendue est survenue.");
      }
      Fluttertoast.showToast(msg: "Une erreur inattendue s'est produite $e");
      print(e);
    }

  }

  createUser(String goal) async {

    if(goal == "email") {
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        loading = true;
      });
    }

    try {

      prefs = await SharedPreferences.getInstance();
      lastname = await prefs?.getString('name');
      firstname = await prefs?.getString('firstname');
      final String? gender = await prefs?.getString('gender');
      final String? date = await prefs?.getString('date');
      number = await prefs?.getString('number');
      password = await prefs?.getString('password');

      Map<String, dynamic> data = {
        'email': emailController.text,
        "numtelephone": number,
        "first_name": firstname,
        'last_name': lastname,
        "genre": gender,
        "datenaissance": date,
        "password": password,
      };

      // Vérification si la photo est présente et valide
      if (prefs!.containsKey('profile')) {
        final String? profile = await prefs?.getString('profile');

        // Si le chemin est non null et le fichier existe
        if (profile != null && profile.isNotEmpty) {
          final File file = File(profile);

          if (await file.exists()) {
            String mimeType = 'image/jpeg'; // Valeur par défaut (JPEG)
            String extension = profile.split('.').last.toLowerCase(); // Récupère l'extension du fichier

            if (extension == 'png') {
              mimeType = 'image/png';
            }
            if (extension == 'jpg') {
              mimeType = 'image/jpg';
            }

            // Ajouter la photo dans les données
            data['photo'] = await MultipartFile.fromFile(profile, contentType: DioMediaType.parse(mimeType));
          } else {
            print('Le fichier photo n\'existe pas.');
          }
        } else {
          print('Aucun fichier photo trouvé.');
        }
      }

      // Construire le FormData pour l'envoi multipart
      final formData = FormData.fromMap(data);

      await userService.create(formData);

      emailController.text = "";

      await loginUser(goal);

      await prefs?.remove("name");
      await prefs?.remove("firstname");
      await prefs?.remove("gender");
      await prefs?.remove("number");
      await prefs?.remove("password");
      await prefs?.remove("profile");
      await prefs?.remove("date");

    } on DioException catch (e) {
      // Gérer les erreurs de la requête
      print(e.response?.statusCode);
      if (e.response != null) {
        if (e.response?.statusCode == 400) {
          if (e.response?.data["numtelephone"] != null) {
            Fluttertoast.showToast(msg: "Un compte existe déjà avec ce numéro.");
          }
          else if(e.response?.data["email"] != null) {
            Fluttertoast.showToast(msg: "Un compte existe déjà avec cet email.");
          }
        }
        else if(e.response?.statusCode == 401) {
          Fluttertoast.showToast(msg: "Données invalides.");
        }
        else {
          Fluttertoast.showToast(msg: "Erreur du serveur : ${e.response?.statusCode}");
        }
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
    }

  }

  final notificationService = NotificationService();

  createNotification(String goal) async {

    try {

      Map<String, dynamic> data = {
        "title": "Bienvenue sur OptimaBâtis",
        "content": "Bonjour $lastname $firstname 👋,\nBienvenue sur OptimaBâtis ! " +

      "Nous sommes ravis de vous compter parmi nos utilisateurs. "+

      "OptimaBâtis vous offre désormais une solution rapide et fiable pour gérer vos problèmes de dépannage immobilier en maçonnerie, plomberie, menuiserie, électricité, etc, de rénovation partielle ou totale, et de construction des bâtiments, et bien plus encore ! \n"+

      "🚀 Voici comment démarrer :\n"+

      "Explorez nos catégories de services. \n"+
      "Soumettez votre première demande en quelques clics. \n"+

      "Consultez vos notifications pour rester informé en temps réel. \n"+

      "Si vous avez des questions, notre support est là pour vous accompagner. \n"+

      "Ensemble, transformons notre quotidien en matière de réparation immobilière et bâtissons autrement l'avenir de rénovation et de construction. \n"+

      "Encore une fois, bienvenue dans la communauté OptimaBâtis !\n",
        "receiver": 1
      };

      await notificationService.create(data);

    } on DioException catch (e) {
      // Gérer les erreurs de la requête
      print(e.response?.statusCode);
      if (e.response != null) {
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
      if(goal == "email") {
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }

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
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
          child: Column(
            children: [
              Image.asset("assets/images/Mail.png"),
              SizedBox(height: 32,),
              Text("Sécurisez davantage votre compte avec votre adresse email",
                style: TextStyle(
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.bold,
                    fontSize: 19
                ),
              ),
              SizedBox(height: 16,),
              Text("Enregistrez puis vérifiez votre boîte mail pour pouvoir avoir accès aux options de récupération de votre compte :\n1. Réinitialisation du mot de passe\n2.Changement de numéro de téléphone.",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4B5563)
                ),
              ),
              SizedBox(height: 16,),
              Form(
                  key: formKey,
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF4B5563), size: 29,),
                      hintText: "monmail@monmail.com",
                      hintStyle: TextStyle(
                          color: Color(0xFF4B5563),
                          fontSize: 13
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF707070)),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF707070)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer votre adresse email";
                      }
                      final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                      if (!emailRegex.hasMatch(value)) {
                        return "Veuillez entrer un email valide";
                      }
                      return null;
                    },
                  )
              ),
              SizedBox(height: 100,),
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
                    if(formKey.currentState!.validate()) {
                      await createUser("email");
                    }
                  },
                  child: isLoading ?
                  SizedBox(
                      height: 19,
                      width: 19,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,)
                  ) :
                  Text("Confirmer",
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
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
                    await createUser("plustard");
                  },
                  child: loading ?
                  SizedBox(
                      height: 19,
                      width: 19,
                      child: CircularProgressIndicator(color: Color(0xFF3172B8), strokeWidth: 2,)
                  ) :
                  Text("Plus tard",
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3172B8)
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
