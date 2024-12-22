import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Description extends StatefulWidget {
  const Description({super.key});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {

  final formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final dayController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();
  final minuteController = TextEditingController();
  final hourController = TextEditingController();

  bool checkDateTime() {
    int year = int.parse(yearController.text);
    int month = int.parse(monthController.text);
    int day = int.parse(dayController.text);
    int hour = int.parse(hourController.text);
    int minute = int.parse(minuteController.text);
    DateTime currentDate = DateTime.now();
    DateTime userDate = DateTime(year, month, day, hour, minute, 0);
    return userDate.isAfter(currentDate);
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
        title: Text("Description et date de l'intervention",style: TextStyle(fontSize: 14),),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.white,
                        )),
                    SizedBox(width: 5),
                    CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.grey,
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.blue,
                        )),
                    SizedBox(width: 5),
                    CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.grey,
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.white,
                        )),
                    SizedBox(width: 5),
                    CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.grey,
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.white,
                        )),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Description de la panne/Service demandé*",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 12,
                        decoration: InputDecoration(
                            hintText:
                            "Décrivez en quelques mots le problème ou le service souhaité",
                            border: OutlineInputBorder()),
                        validator: (String? value) {
                          return (value == null || value == "") ? "Ce champ est obligatoire" : null;
                        },
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Date et heure souhaitées pour l'intervention",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 0,
                        width: 0,
                      ),
                      Text("Choisissez une date"),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          // Sélection du jour
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.black),
                                          ),
                                          child: TextFormField(
                                            onChanged: (value) {
                                              if (value.length == 2) {
                                                FocusScope.of(context).nextFocus();
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            textAlignVertical: TextAlignVertical.center,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(2),
                                              FilteringTextInputFormatter.digitsOnly
                                            ],
                                            controller: dayController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.all(4),
                                            ),
                                            validator: (String? value) {
                                              if(value == null || value.isEmpty) {
                                                return "";
                                              }
                                              else if(int.parse(value) < 1 || int.parse(value) > 31) {
                                                return "";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Text(
                                          "JJ",
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    Text(" - "),
                                    Column(
                                      children: [
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.black),
                                          ),
                                          child: TextFormField(
                                            onChanged: (value) {
                                              if (value.length == 2) {
                                                FocusScope.of(context).nextFocus();
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            textAlignVertical: TextAlignVertical.center,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(2),
                                              FilteringTextInputFormatter.digitsOnly
                                            ],
                                            controller: monthController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.all(4),
                                            ),
                                            validator: (String? value) {
                                              if(value == null || value.isEmpty) {
                                                return "";
                                              }
                                              else if(int.parse(value) < 1 || int.parse(value) > 12) {
                                                return "";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Text(
                                          "MM",
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    Text(" - "),
                                    Column(
                                      children: [
                                        Container(
                                          width: 72,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.black),
                                          ),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            textAlignVertical: TextAlignVertical.center,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(4),
                                              FilteringTextInputFormatter.digitsOnly
                                            ],
                                            controller: yearController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.all(4),
                                            ),
                                            validator: (String? value) {
                                              return (value == null || value == "") ? "" : null;
                                            },
                                          ),
                                        ),
                                        Text(
                                          "AA",
                                          style: TextStyle(fontSize: 11),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],

                      ),
                      SizedBox(height: 25,),
                      Text("Choisissez une plage horaire préférée si vous avez une préférence."),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          // Sélection du jour
                          Expanded(
                            child: Column(
                              children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.black),
                                          ),
                                          child: TextFormField(
                                            onChanged: (value) {
                                              if (value.length == 2) {
                                                FocusScope.of(context).nextFocus();
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            textAlignVertical: TextAlignVertical.center,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(2),
                                              FilteringTextInputFormatter.digitsOnly
                                            ],
                                            controller: hourController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.all(4),
                                            ),
                                            validator: (String? value) {
                                              if(value == null || value.isEmpty) {
                                                return "";
                                              }
                                              else if(int.parse(value) < 0 || int.parse(value) > 23) {
                                                return "";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Text(
                                          "H",
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    Text(" - "),
                                    Column(
                                      children: [
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.black),
                                          ),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            textAlignVertical: TextAlignVertical.center,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(2),
                                              FilteringTextInputFormatter.digitsOnly
                                            ],
                                            controller: minuteController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.all(4),
                                            ),
                                            validator: (String? value) {
                                              if(value == null || value.isEmpty) {
                                                return "";
                                              }
                                              else if(int.parse(value) < 0 || int.parse(value) > 59) {
                                                return "";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Text(
                                          "M",
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
              ),
              SizedBox(height: 16,),
              // Bouton suivant
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
                      await prefs.setString("description", descriptionController.text);
                      await prefs.setString("date", yearController.text + "-" + monthController.text + "-" + dayController.text);
                      await prefs.setString("hour", hourController.text + ":" + minuteController.text);
                      if(checkDateTime()) {
                        context.push("/takePictures");
                      }
                      else {
                        Fluttertoast.showToast(msg: "La date est invalide");
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Entrez des valeurs valides dans chaque champ");
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
