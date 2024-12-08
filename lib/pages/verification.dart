import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optimabatis/pages/home.dart';
import 'package:optimabatis/pages/password_creation.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key, required this.goal});

  final String goal;

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

  // Fonction pour démarrer le timer
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          resent = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    _controller4.addListener(() {
      if (_controller4.text.length == 1) {
        if (formKey.currentState!.validate()) {
          if(widget.goal == "connexion") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage()
                )
            );
          }
          else if (widget.goal == "inscription"){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreatePassword()
                )
            );
          }
        }
      }
    });
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
            Text("Un code a été envoyé par SMS au numéro de téléphone que vous avez renseigné. Ce code expire dans 5 minutes pour votre sécurité.",
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
                  onPressed: () {
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
