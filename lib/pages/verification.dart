import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/flutter_helpers/services/fastermessage.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  int _remainingTime = 60;
  Timer? _timer;
  bool resent = false;
  final formKey = GlobalKey<FormState>();

  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    generateRandomCode();
    sendCode();
    _startTimer();
    _controller4.addListener(() {
      if (_controller4.text.length == 1) {
        if (formKey.currentState!.validate()) {
          checkCode();
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        if (!_isDisposed) {
          setState(() {
            _remainingTime--;
          });
        }
      } else {
        _timer?.cancel();
        if (!_isDisposed) {
          setState(() {
            resent = true;
            _code = "";
            Fluttertoast.showToast(msg: "Code expiré");
          });
        }
      }
    });
  }

  final fastermessage = FasterMessage();
  String? _code;

  /// Fonction pour générer un code aléatoire de 4 chiffres
  void generateRandomCode() {
    Random random = Random();
    int code = random.nextInt(9000) + 1000; // Entre 1000 et 9999
    _code = code.toString();
  }

  sendCode() async {

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? number = await prefs.getString("number");

      // Prépare les données à envoyer
      Map<String, dynamic> data = {
        'from': "OPTIMABATIS",
        'to': number!,
        'text': _code! + " est votre code secret. Ne le partagez pas."
      };

      // Lancer la requête
      await fastermessage.sendCode(data);

    } on DioException catch (e) {
      // Gérer les erreurs de la requête
      if (!_isDisposed) { // Vérifiez si la page est toujours active avant d'utiliser setState ou Fluttertoast
        print(e.response?.statusCode);
        if (e.response != null) {
          if (e.response?.data["status"] == false) {
            Fluttertoast.showToast(msg: "Le code n'a pas pu être envoyer. Recommencez");
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
      }
    } catch (e) {
      // Gérer d'autres types d'erreurs
      if (e is SocketException) {
        Fluttertoast.showToast(msg: "Pas d'accès Internet. Veuillez vérifier votre connexion.");
      } else {
        Fluttertoast.showToast(msg: "Une erreur inattendue est survenue.");
      }
      if (!_isDisposed) {
        Fluttertoast.showToast(msg: "Une erreur inattendue s'est produite.");
      }
    }

  }

  void checkCode() {
    String code = _controller1.text + _controller2.text + _controller3.text + _controller4.text;
    if(code == _code) {
      context.go("/createPassword");
    }
    else {
      Fluttertoast.showToast(msg: "Code invalide");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.pop();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Entrez le code de vérification",
              style: TextStyle(
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.bold,
                  fontSize: 19
              ),
            ),
            SizedBox(height: 16,),
            Text("Un code a été envoyé par SMS au numéro de téléphone que vous avez renseigné. Ce code expire dans 60 secondes pour votre sécurité.",
              style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF4B5563)
              ),
            ),
            SizedBox(height: 16,),
            Form(
                key: formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: TextFormField(
                        controller: _controller1,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF707070)),
                              borderRadius: BorderRadius.circular(10),
                            )
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: TextFormField(
                        controller: _controller2,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF707070)),
                              borderRadius: BorderRadius.circular(10),
                            )
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: TextFormField(
                        controller: _controller3,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF707070)),
                              borderRadius: BorderRadius.circular(10),
                            )
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: TextFormField(
                        controller: _controller4,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF707070)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
            SizedBox(height: 20),
              Center(
                child: !resent ?
                Text(
                  "Renvoyer le code dans 00:$_remainingTime",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4B5563)
                  ),
                ):
                ElevatedButton(
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
                    generateRandomCode();
                    await sendCode();
                    setState(() {
                      _remainingTime = 60;
                      resent = false;
                    });
                    _startTimer();
                  },
                  child: Text("Renvoyer le code",
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                )
              )
          ],
        ),
      ),
    );
  }
}
