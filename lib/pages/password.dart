import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:optimabatis/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../flutter_helpers/services/user_service.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {

  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  bool hidePassword = true;
  final userService = UserService();
  bool isLoading = false;

  loginUser() async {

    setState(() {
      isLoading = true;
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? number = await prefs.getString('number');

      // Prépare les données à envoyer
      Map<String, dynamic> data = {
        'numtelephone': number,
        'password': passwordController.text
      };

      // Lancer la requête
      Map<String, dynamic> authUser = await userService.login(data);

      // Sauvegerder le token en mémoire
      prefs.setString("token", authUser['access']!);

      // Afficher un message de succès
      Fluttertoast.showToast(msg: "Vous êtes connecté(e)");

      await prefs.remove("number");

      // Rediriger vers la page d'accueil
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return HomePage();
          })
      );

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
      body: Container(
            padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Entrez votre mot de passe",
                      style: TextStyle(
                          color: Color(0xFF1F2937),
                          fontWeight: FontWeight.bold,
                          fontSize: 19
                      ),
                    ),
                    SizedBox(height: 16,),
                    Text("Saisissez votre mot de passe afin de vous connecter à votre compte.",
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4B5563)
                      ),
                    ),
                    SizedBox(height: 16,),
                    Form(
                        key: formKey,
                        child: TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                              hintText: "Mot de passe",
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
                              prefixIcon: Image.asset("assets/images/password_key.png"),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidePassword = !hidePassword;
                                    });
                                  },
                                  icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off, color: Color(0xFF4B5563),)
                              )
                          ),
                          validator: (value) {
                            return (value == null || value.isEmpty) ? "Veuillez entrer votre mot de passe" : null;
                          },
                        )
                    ),
                    TextButton(
                        onPressed: () {

                        },
                        child: Text("J'ai oublié mon mot de passe",
                          style: TextStyle(
                              color: Color(0xFF3172B8),
                              fontSize: 13
                          ),
                        )
                    )
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Color(0xFF3172B8)),
                        elevation: WidgetStateProperty.all(0),
                        shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                              side: BorderSide(color: Color(0xFF707070), width: 1),
                            )
                        ),
                        foregroundColor: WidgetStateProperty.all(Colors.white)
                    ),
                    onPressed: () async {
                      if(formKey.currentState!.validate()) {
                        await loginUser();
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
                )
              ],
            ),
          ),
    );
  }
}
