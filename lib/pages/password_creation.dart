import 'package:flutter/material.dart';
import 'package:optimabatis/pages/personal_datas.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {

  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  List<bool> conditions = [false, false, false, false, false];
  bool isSame = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    passwordController.addListener(() {
      checkPassword();
    });

    confirmPasswordController.addListener(() {
      comparePasswords();
    });
  }

  void checkPassword() {
    final text = passwordController.text;
    if (text.isEmpty) {
      // Si le champ est vide, réinitialiser toutes les conditions à false
      setState(() {
        conditions = [false, false, false, false, false];
      });
      return; // Arrêter l'exécution ici
    }

    // Vérifiez chaque condition individuellement
    setState(() {
      conditions[0] = RegExp(r'[0-9]').hasMatch(text); // Chiffres
      conditions[1] = RegExp(r'[a-z]').hasMatch(text); // Minuscules
      conditions[2] = RegExp(r'[A-Z]').hasMatch(text); // Majuscules
      conditions[3] = RegExp(r'[!@#\$%\^&\*\(\)_\+\-=,./?<>;:{}\[\]|~€]').hasMatch(text); // Caractères spéciaux
      conditions[4] = text.length >= 8 && text.length <= 20; // Longueur
    });
  }

  void comparePasswords() {
    setState(() {
      isSame = passwordController.text == confirmPasswordController.text;
    });
  }

  Widget buildConditionRow(String text, bool conditionMet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Icon(Icons.panorama_fish_eye, size: 9, color: Color(0xFF4B5563)),
        SizedBox(width: 8),
        Expanded(
          child: Text(text,
            style: TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 11,
            ),
          ),
        ),
        SizedBox(width: 8),
        passwordController.text.isNotEmpty ?
        Icon(
          conditionMet ? Icons.check_circle : Icons.cancel,
          color: conditionMet ? Colors.green[600] : Colors.red[700],
        ) :
        SizedBox()
      ],
    );
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Définissez votre mot de passe",
                      style: TextStyle(
                          color: Color(0xFF1F2937),
                          fontWeight: FontWeight.bold,
                          fontSize: 19
                      ),
                    ),
                    SizedBox(height: 16,),
                    Text("Créez un mot de passe. Vous aurez besoin de celui-ci pour vous connecter à votre compte.",
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4B5563)
                      ),
                    ),
                    SizedBox(height: 16,),
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
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
                              if (value == null || value.isEmpty) {
                                return "Veuillez entrer votre mot de passe";
                              } else if (!conditions.every((condition) => condition)) {
                                return "Le mot de passe ne respecte pas les critères";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16,),
                          TextFormField(
                            controller: confirmPasswordController,
                            keyboardType: TextInputType.text,
                            obscureText: hideConfirmPassword,
                            onChanged: (value) {
                              comparePasswords();
                            },
                            decoration: InputDecoration(
                                hintText: "Mot de passe à nouveau",
                                hintStyle: TextStyle(
                                    color: Color(0xFF4B5563),
                                    fontSize: 13
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: confirmPasswordController.text.isNotEmpty ?
                                                (isSame ? Color(0xFF707070) : Colors.red[700]!)
                                                : Color(0xFF707070),
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: confirmPasswordController.text.isNotEmpty ?
                                                (isSame ? Color(0xFF707070) : Colors.red[700]!)
                                                : Color(0xFF707070),
                                      width: confirmPasswordController.text.isNotEmpty ?
                                                (isSame ? 1 : 2)
                                                : 1
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: Image.asset("assets/images/password_key.png"),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hideConfirmPassword = !hideConfirmPassword;
                                      });
                                    },
                                    icon: Icon(hideConfirmPassword ? Icons.visibility : Icons.visibility_off, color: Color(0xFF4B5563),)
                                )
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez confirmer votre mot de passe";
                              } else if (value != passwordController.text) {
                                return "";
                              }
                              return null;
                            },
                          ),
                          confirmPasswordController.text.isNotEmpty ?
                              !isSame ?
                                Container(
                                  padding: EdgeInsets.only(top: 3, left: 12),
                                  child: Text("Les mots de passe ne correspondent pas",
                                      style: TextStyle(
                                        color: Colors.red[700],
                                        fontSize: 12.3,
                                      ),
                                    ),
                                ) :
                                  SizedBox()
                              : SizedBox()
                        ],
                      ),
                    ),
                    SizedBox(height: 32,),
                    Text("Votre mot de passe doit contenir :",
                      style: TextStyle(
                          color: Color(0xFF4B5563),
                          fontSize: 13,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    SizedBox(height: 16,),
                    buildConditionRow("au moins un chiffre 0-9", conditions[0]),
                    buildConditionRow("au moins un caractère miniscule a-z", conditions[1]),
                    buildConditionRow("au moins un caractère majuscule A-Z", conditions[2]),
                    buildConditionRow("au moins un caractère spécial comme #@&!", conditions[3]),
                    buildConditionRow("au minimum 8 caractères et au maximum 20 caractères", conditions[4]),
                  ],
                ),
                SizedBox(height: 225,),
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
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString('password', passwordController.text);
                        passwordController.text = "";
                        confirmPasswordController.text = "";
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return PersonalDatas();
                            })
                        );
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
          )
      ),
    );
  }
}
