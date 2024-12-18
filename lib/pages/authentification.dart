import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:optimabatis/pages/change_password.dart';

import '../flutter_helpers/services/user_service.dart';

class AuthentificationPage extends StatefulWidget {
  const AuthentificationPage({super.key});

  @override
  State<AuthentificationPage> createState() => _AuthentificationPageState();
}

class _AuthentificationPageState extends State<AuthentificationPage> {

  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  bool hidePassword = true;
  final userService = UserService();
  Map<String, dynamic>? authUser;

  Future<void> getAuthUser() async {
    try {
      final user = await userService.getUser();
      setState(() {
        authUser = user;
      });
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur : $e');
    }
  }

  Future verifyPassword() async {
    await getAuthUser();
    print(authUser!["password"]);
    if(passwordController.text == authUser!["password"]) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ChangePassword();
          })
      );
    }
    else {
      Fluttertoast.showToast(msg: "Mot de passe incorrect");
    }
  }

  @override
  void initState() {
    super.initState();
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
                    await verifyPassword();
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
    );
  }
}
