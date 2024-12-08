import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:optimabatis/pages/verification.dart';
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
      body: Expanded(
          child: Container(
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
                        await loginUser();
                      }
                    },
                    child: Text("Confirmer",
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
      )
    );
  }
}
