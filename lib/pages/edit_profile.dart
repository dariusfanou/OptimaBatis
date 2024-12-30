import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:optimabatis/auth_provider.dart';
import 'package:optimabatis/flutter_helpers/services/user_service.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final formKey = GlobalKey<FormState>();
  final lastnameController = TextEditingController();
  final firstnameController = TextEditingController();
  String? gender;
  TextEditingController dateController = TextEditingController();
  final emailController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final DateFormat _dateFormatStocked = DateFormat('yyyy-MM-dd');
  String? dateStocked;
  bool loading = false;
  late AuthProvider authProvider;

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

  final userService = UserService();
  Map<String, dynamic>? authUser;
  bool isLoading = true;

  bool isUrl(String path) {
    final regex = RegExp(r"^https?:\/\/");
    return regex.hasMatch(path);
  }

  Future<void> getAuthUser() async {
    try {
      final user = await userService.getUser();
      setState(() {
        authUser = user;
        gender = authUser!["genre"];
        lastnameController.text = authUser!["last_name"];
        firstnameController.text = authUser!["first_name"];
        if (authUser!["datenaissance"] != null) {
          dateController.text = _dateFormat.format(DateTime.parse(authUser!["datenaissance"]));
        }
        if (authUser!["email"] != null) {
          emailController.text = authUser!["email"];
        }
        if(authUser!["photo"] != null) {
          _filePath = authUser!["photo"];
        }
        isLoading = false;
        print(authUser);
      });
    } on DioException catch (e) {
      if(e.response?.statusCode == 401) {
        Fluttertoast.showToast(msg: "Votre session a expirée. Veuillez vous reconnecter.");
        authProvider.logout();
        context.go("/welcome");
      }
      print('Erreur lors de la récupération des données utilisateur : $e');
    } catch(e) {
      if (e is SocketException) {
        Fluttertoast.showToast(msg: "Pas d'accès Internet. Veuillez vérifier votre connexion.");
      } else {
        Fluttertoast.showToast(msg: "Une erreur inattendue est survenue.");
      }
    }
  }

  Future<void> updateUser() async {
    setState(() {
      loading = true;
    });

    try {
      // Préparer les données du formulaire
      Map<String, dynamic> data = {
        'email': emailController.text,
        'numtelephone': authUser?["numtelephone"],
        'first_name': firstnameController.text,
        'last_name': lastnameController.text,
        'genre': gender,
        'datenaissance': dateStocked,
      };

      // Si un fichier image a été sélectionné, le préparer
      if (_filePath != null && _filePath!.isNotEmpty) {
        final File file = File(_filePath!);

        if (await file.exists()) {
          String mimeType = lookupMimeType(_filePath!) ?? 'image/jpeg'; // Récupère le type MIME
          data['photo'] = await MultipartFile.fromFile(
            _filePath!,
            contentType: DioMediaType.parse(mimeType),
          );
        } else {
          print('Le fichier photo n\'existe pas.');
        }
      }

      // Construire le FormData pour l'envoi multipart
      final formData = FormData.fromMap(data);

      // Appeler le service utilisateur pour mettre à jour le profil
      await userService.updateUser(formData);

      // Réinitialiser les champs après succès
      lastnameController.clear();
      firstnameController.clear();
      dateController.clear();
      emailController.clear();

      Fluttertoast.showToast(msg: "Profil modifié avec succès");
      context.push("/profile");
    } on DioException catch (e) {
      // Gérer les erreurs spécifiques à Dio
      print("Erreur Dio : ${e.response?.statusCode}");
      print("Détails : ${e.response?.data}");
      if (e.response?.statusCode == 401) {
        Fluttertoast.showToast(msg: "Votre session a expirée. Veuillez vous reconnecter.");
        authProvider.logout();
        context.go("/welcome");
      } else if (e.response?.statusCode == 415) {
        Fluttertoast.showToast(msg: "Erreur : Type de données non supporté.");
      } else {
        Fluttertoast.showToast(msg: "Erreur du serveur : ${e.response?.data}");
      }
    } catch (e) {
      // Gérer toute autre erreur
      if (e is SocketException) {
        Fluttertoast.showToast(msg: "Pas d'accès Internet. Veuillez vérifier votre connexion.");
      } else {
        Fluttertoast.showToast(msg: "Une erreur inattendue est survenue.");
      }
      print("Erreur inattendue : $e");
      Fluttertoast.showToast(msg: "Une erreur inattendue s'est produite.");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    getAuthUser();
  }

  @override
  void dispose() {
    lastnameController.dispose();
    firstnameController.dispose();
    dateController.dispose();
    emailController.dispose();
    super.dispose();
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
      body: isLoading ?
      const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Modifier mon profil",
                    style: TextStyle(
                        color: Color(0xFF1F2937),
                        fontWeight: FontWeight.bold,
                        fontSize: 19
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
                          SizedBox(height: 16,),TextFormField(
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
                              final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                              if (value != null && value.isNotEmpty && !emailRegex.hasMatch(value)) {
                                return "Veuillez entrer un email valide";
                              }
                              return null;
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
                                        (isUrl(_filePath!)) ?
                                        Image.network(_filePath!):
                                            Image.file(File(_filePath!)):
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
                                  await updateUser();
                                }
                              },
                              child: loading ?
                                SizedBox(
                                  height: 19,
                                  width: 19,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,)
                                ) :
                                Text("Modifier",
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                            ),
                          ),
                        ]
                      ),
                  ),
                ]
              )
          ),
      )
    );
  }
}
