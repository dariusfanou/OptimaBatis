import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:optimabatis/pages/email.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class PersonalDatas extends StatefulWidget {
  const PersonalDatas({super.key});

  @override
  State<PersonalDatas> createState() => _PersonalDatasState();
}

class _PersonalDatasState extends State<PersonalDatas> {

  final formKey = GlobalKey<FormState>();
  final lastnameController = TextEditingController();
  final firstnameController = TextEditingController();
  String? gender;
  TextEditingController dateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final DateFormat _dateFormatStocked = DateFormat('yyyy-MM-dd');
  String? dateStocked;
  bool? termsOfUse = false;

  String? _fileName;
  String? _filePath;

  Future<void> pickImage() async {
    // Ouvrir la fenêtre de sélection de fichiers pour les images
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Limite à l'image
    );

    if (result != null) {
      // Obtenir le chemin de l'image sélectionnée
      _filePath = result.files.single.path;
      _fileName = result.files.single.name;
      setState(() {});
    } else {
      // L'utilisateur a annulé la sélection
      print("Aucune image sélectionnée");
    }
  }

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        locale: const Locale("fr")
    );

    if (picked != null) {
      dateController.text = _dateFormat.format(picked);
      dateStocked = _dateFormatStocked.format(picked);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Dites nous-en un peu plus sur vous",
                  style: TextStyle(
                      color: Color(0xFF1F2937),
                      fontWeight: FontWeight.bold,
                      fontSize: 19
                  ),
                ),
                SizedBox(height: 16,),
                Text("Renseignez les champs suivants pour nous permettre de vous connaître et de créer votre compte.",
                  style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4B5563)
                  ),
                ),
                SizedBox(height: 16,),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: lastnameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Entrez votre nom *",
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
                              prefixIcon: Image.asset("assets/images/person.png"),
                          ),
                          validator: (value) {
                            return (value == null || value.isEmpty) ? "Veuillez entrer votre nom" : null;
                          },
                        ),
                        SizedBox(height: 16,),
                        TextFormField(
                          controller: firstnameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Entrez votre(vos) prénom(s) *",
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
                              prefixIcon: Image.asset("assets/images/person.png"),
                          ),
                          validator: (value) {
                            return (value == null || value.isEmpty) ? "Veuillez entrer votre(vos) prénom(s)" : null;
                          },
                        ),
                        SizedBox(height: 16,),
                        DropdownButtonFormField(
                          value: gender,
                          items: const [
                            DropdownMenuItem(
                              value: "homme",
                              child: Text("Masculin"),
                            ),
                            DropdownMenuItem(
                              value: "femme",
                              child: Text("Féminin"),
                            ),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              gender = value;
                            });
                          },
                          validator: (String? value) {
                            return (value == null || value == "") ? "Veuillez choisir un genre" : null;
                          },
                          hint: Center(
                            child: Text('Choisissez un genre *',
                              style: TextStyle(
                                color: Color(0xFF4B5563),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Image.asset("assets/images/gender.png"),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF707070)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF707070)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 16,),
                        TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(
                            hintText: "Entrez votre date de naissance",
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
                            prefixIcon: Image.asset("assets/images/calendar.png"),
                          ),
                          readOnly: true,
                          onTap: () {
                            selectDate();
                          },
                        ),
                        SizedBox(height: 16,),
                        DottedBorder(
                            strokeWidth: 2,
                            borderType: BorderType.RRect,
                            color: Color(0xFF707070),
                            dashPattern: [5, 2],
                            radius: Radius.circular(16),
                            child: SizedBox(
                              width: double.infinity,
                              height: 64,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(16))
                                      ),
                                      backgroundColor: Color(0x3A3172B8)
                                  ),
                                  onPressed: () {
                                    pickImage();
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      (_filePath != null) ?
                                      Image.file(File(_filePath!)) :
                                      Icon(Icons.person_outline, color: Color(0xFF4B5563), size: 28,),
                                      SizedBox(width: 10,),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Ajoutez une photo de profil",
                                              style: TextStyle(
                                                color: Color(0xFF4B5563),
                                                fontSize: 13
                                              ),
                                            ),
                                            Text("Photo de profil",
                                              style: TextStyle(
                                                color: Color(0xFF3172B8),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              ),
                            )
                        ),
                        SizedBox(height: 32,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                                value: termsOfUse,
                                activeColor: Color(0xFF3172B8),
                                side: BorderSide(
                                  color: Color(0xFF4B5563)
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    termsOfUse = value;
                                  });
                                }
                            ),
                            Expanded(
                                child: Text("Je suis d'accord avec les conditions générales d'utilisation",
                                  style: TextStyle(
                                      color: Color(0xFF4B5563),
                                      fontSize: 13
                                  ),
                                ),
                            )
                          ],
                        ),
                        SizedBox(height: 16,),
                        ElevatedButton(
                            onPressed: () {
                              
                            }, 
                            style: ButtonStyle(
                              elevation: WidgetStatePropertyAll(0),
                              backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                              side: WidgetStatePropertyAll(BorderSide(
                                color: Color(0xFF3172B8)
                              ))
                            ),
                            child: Text("A lire",
                              style: TextStyle(
                                  color: Color(0xFF3172B8),
                                fontSize: 13
                              ),
                            )
                        ),
                        SizedBox(height: 32,),
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
                              if(formKey.currentState!.validate() && termsOfUse!) {
                                final SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('name', lastnameController.text);
                                prefs.setString('firstname', firstnameController.text);
                                prefs.setString('gender', gender!);
                                if(dateStocked != null) {
                                  prefs.setString('date', dateStocked!);
                                }
                                if(_filePath != null) {
                                  prefs.setString('profile', _filePath!);
                                }
                                lastnameController.text = "";
                                firstnameController.text = "";
                                dateController.text = "";
                                context.go('/email');
                              }
                              if(!termsOfUse!) {
                                Fluttertoast.showToast(msg: "Veuillez accepter les conditions générales d'utilisation.");
                              }
                            },
                            child: Text("Suivant",
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                ),
                      ],
                    )
                )
            ),
    );
  }
}
