import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:optimabatis/pages/home.dart';
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

  loginUser() async {

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? number = await prefs.getString('number');
      final String? password = await prefs.getString('password');

      // Prépare les données à envoyer
      Map<String, dynamic> data = {
        'numtelephone': number,
        'password': password
      };

      // Lancer la requête
      Map<String, dynamic> authUser = await userService.login(data);

      // Sauvegerder le token en mémoire
      prefs.setString("token", authUser['access']!);

      // Afficher un message de succès
      Fluttertoast.showToast(msg: "Utilisateur connecté avec succès");

      // Rediriger vers la page d'accueil
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return HomePage();
          })
      );

    } on DioException catch (e) {

      // Quand erreur de requête, afficher les erreurs et le status code
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.statusCode);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }

      Fluttertoast.showToast(msg: "Une erreur est survenue");

    }

  }

  createUser() async {
    try {

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? last_name = await prefs.getString('name');
      final String? first_name = await prefs.getString('firstname');
      final String? gender = await prefs.getString('gender');
      final String? date = await prefs.getString('date');
      final String? number = await prefs.getString('number');
      final String? password = await prefs.getString('password');

      Map<String, dynamic> data = {
        'email': emailController.text,
        "numtelephone": number,
        "first_name": first_name,
        'last_name': last_name,
        "genre": gender,
        "datenaissance": date,
        "password": password,
      };

      // Vérification si la photo est présente et valide
      if (prefs.containsKey('profile')) {
        final String? profile = await prefs.getString('profile');

        // Si le chemin est non null et le fichier existe
        if (profile != null && profile.isNotEmpty) {
          final File file = File(profile);

          if (await file.exists()) {
            String mimeType = 'image/jpeg'; // Valeur par défaut (JPEG)
            String extension = profile.split('.').last.toLowerCase(); // Récupère l'extension du fichier

            if (extension == 'png') {
              mimeType = 'image/png';
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

      await userService.create(data);

      emailController.text = "";

      Fluttertoast.showToast(msg: "Utilisateur créé avec succès");

      await loginUser();

    } on DioException catch (e) {

      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.statusCode);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }

      Fluttertoast.showToast(msg: "Une erreur est survenue");

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
                      await createUser();
                    }
                  },
                  child: Text("Confirmer",
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
                    await createUser();
                  },
                  child: Text("Plus tard",
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
