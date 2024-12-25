import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final List<String> imgList = [
    'assets/images/Icone_perso.png',
    'assets/images/Technicien_batiment.png',
    'assets/images/livraison.png',
    'assets/images/batiment.png',
    'assets/images/entretien.png',
  ];
  final Map<String, String> titleMap = {
    'assets/images/Icone_perso.png': 'FAITES RENOVER VOS BÂTIMENTS ET CONSTRUIRE VOS IMMEUBLES AVEC OPTIMABÂTIS',
    'assets/images/Technicien_batiment.png': 'COMMANDEZ VOS MATERIAUX DE CONSTRUCTION A PRIX REDUITS',
    'assets/images/livraison.png': 'COMMANDEZ LES TRAVAUX DE RENOVATION TOTALE OU PARTIELLE DE VOS BATIMENTS',
    'assets/images/batiment.png': 'RÉALISEZ VOS PROJETS DE CONSTRUCTION DE BÂTIMENTS CLÉ EN MAIN',
    'assets/images/entretien.png': 'DES SERVICES ENTRETIENS A PETIT PRIX'
  };
  final Map<String, String> subtitleMap = {
    'assets/images/Icone_perso.png': 'Ne vous cassez plus la tête. Commander des réparations bâtiment et construction d’immeubles en un seul clic.',
    'assets/images/Technicien_batiment.png': 'Nous vous offrons les bénéfices des partenariats noués avec les sociétés de distribution des matériaux de construction de haute qualité pour une réduction des prix.',
    'assets/images/livraison.png': 'Nous mettons à votre disposition des techniciens rompus à la tâche qui vous accompagnerons de bout en bout dans la réalisation de vos projets de rénovation de bâtiments, de la conception à la finition.',
    'assets/images/batiment.png': 'Nous réalisons, avec nos techniciens, des projets de construction complets : maçonnerie, peinture, plomberie, électricité, charpenterie, menuiserie, carrelage, staff plafond, et plus. Nous livrons des bâtiments conformes aux normes.',
    'assets/images/entretien.png': 'Nous mettons à votre disposition un service entretien avec des matériels et techniques de dernière génération à prix compétitifs.'
  };

  int currentIndex = 0;
  final CarouselSliderController carouselController = CarouselSliderController();
  final formKey = GlobalKey<FormState>();
  final DraggableScrollableController _draggableController = DraggableScrollableController();
  String? phoneNumber;
  final phoneController = TextEditingController();

  @override
  void dispose() {
    _draggableController.dispose();
    super.dispose();
  }

  Future saveNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('number', phoneNumber!);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Contenu principal (par exemple, le carousel)
          Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: screenHeight * 0.05),
                  decoration: BoxDecoration(
                      color: Color(0xFFD4E9FF)
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imgList.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => carouselController.animateToPage(entry.key),
                            child: Container(
                              width: screenWidth * 0.02, // Largeur du cercle (responsive)
                              height: screenWidth * 0.02, // Hauteur du cercle (responsive)
                              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: (currentIndex == entry.key)
                                      ? Color(0xFF3172B8)
                                      : Color(0xFFBDCDDE),
                                  width: 2,
                                ),
                                color: (currentIndex == entry.key)
                                    ? Color(0xFF3172B8)
                                    : Colors.transparent,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CarouselSlider(
                        carouselController: carouselController,
                        options: CarouselOptions(
                          height: screenHeight * 0.7,
                          viewportFraction: 1.0,
                          autoPlay: true, // Active le défilement automatique
                          autoPlayInterval: Duration(seconds: 3), // Intervalle entre les diapositives
                          autoPlayAnimationDuration: Duration(seconds: 1), // Durée de l'animation
                          autoPlayCurve: Curves.easeInOut, // Courbe pour l'animation
                          enlargeCenterPage: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                        items: imgList
                            .map((item) => Container(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                            child: Column(
                                children: [
                                  Image.asset(
                                    item,
                                    fit: BoxFit.cover,
                                    height: screenHeight * 0.35, // Responsive height
                                  ),
                                  Text(titleMap[item]!,
                                    style: TextStyle(
                                        color: Color(0xFF3172B8),
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.04 // Responsive font size
                                    ),
                                  ),
                                  Text(subtitleMap[item]!,
                                    style: TextStyle(
                                        color: Color(0xFF4B5563),
                                        fontSize: screenWidth * 0.03 // Responsive font size
                                    ),
                                  )
                                ])),
                        ).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Bottom Sheet glissable
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.3,
            maxChildSize: 1.0,
            controller: _draggableController,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(screenWidth * 0.08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onVerticalDragEnd: (details) {
                          if (details.primaryVelocity! > 0) {
                            _draggableController.animateTo(
                              0.3,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _draggableController.animateTo(
                              1.0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Center(
                          child: Container(
                            width: screenWidth * 0.12,
                            height: 3,
                            margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                            decoration: BoxDecoration(
                              color: Color(0x3B707070),
                            ),
                          ),
                        ),
                      ),
                      Text("Entrez votre numéro de téléphone",
                        style: TextStyle(
                            color: Color(0xFF1F2937),
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text("Entrez votre numéro de téléphone pour vous connecter ou pour créer un nouveau compte.",
                        style: TextStyle(
                          color: Color(0xFF4B5563),
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Form(
                          key: formKey,
                          child: IntlPhoneField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              hintText: "Numéro de téléphone",
                              hintStyle: TextStyle(
                                color: Color(0xFF4F4F4F),
                                fontSize: screenWidth * 0.035,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32),
                                  borderSide: BorderSide(color: Color(0xFF707070))
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            showDropdownIcon: false,
                            initialCountryCode: 'BJ',
                            flagsButtonMargin: EdgeInsets.only(left: 32),
                            countries: [
                              Country(
                                name: "Bénin",
                                code: "BJ",
                                flag: "bj",
                                dialCode: "229",
                                nameTranslations: {
                                  "en": "Benin",
                                  "fr": "Bénin",
                                },
                                minLength: 10,
                                maxLength: 10,
                              ),
                              Country(
                                name: "Burkina Faso",
                                code: "BF",
                                flag: "bf",
                                dialCode: "226",
                                nameTranslations: {
                                  "en": "Burkina Faso",
                                  "fr": "Burkina Faso",
                                },
                                minLength: 8,
                                maxLength: 8,
                              ),
                              Country(
                                name: "Côte d'Ivoire",
                                code: "CI",
                                flag: "ci",
                                dialCode: "225",
                                nameTranslations: {
                                  "en": "Ivory Coast",
                                  "fr": "Côte d'Ivoire",
                                },
                                minLength: 8,
                                maxLength: 8,
                              ),
                              Country(
                                name: "Sénégal",
                                code: "SN",
                                flag: "sn",
                                dialCode: "221",
                                nameTranslations: {
                                  "en": "Senegal",
                                  "fr": "Sénégal",
                                },
                                minLength: 9,
                                maxLength: 9,
                              ),
                              Country(
                                name: "Togo",
                                code: "TG",
                                flag: "tg",
                                dialCode: "228",
                                nameTranslations: {
                                  "en": "Togo",
                                  "fr": "Togo",
                                },
                                minLength: 8,
                                maxLength: 8,
                              ),
                              Country(
                                name: "Niger",
                                code: "NE",
                                flag: "ne",
                                dialCode: "227",
                                nameTranslations: {
                                  "en": "Niger",
                                  "fr": "Niger",
                                },
                                minLength: 8,
                                maxLength: 8,
                              ),
                              Country(
                                name: "Mali",
                                code: "ML",
                                flag: "ml",
                                dialCode: "223",
                                nameTranslations: {
                                  "en": "Mali",
                                  "fr": "Mali",
                                },
                                minLength: 8,
                                maxLength: 8,
                              ),
                              Country(
                                name: "Guinée",
                                code: "GN",
                                flag: "gn",
                                dialCode: "224",
                                nameTranslations: {
                                  "en": "Guinea",
                                  "fr": "Guinée",
                                },
                                minLength: 8,
                                maxLength: 8,
                              ),
                            ],
                            invalidNumberMessage: "Numéro de téléphone invalide",
                            onChanged: (phone) {
                              phoneNumber = phone.completeNumber;
                            },
                            validator: (value) {
                              if(phoneController.text == null || phoneController.text.isEmpty) {
                                return "Veuillez entrer un numéro de téléphone";
                              }
                              return null;
                            },
                          )
                        /*Column(
                            children: [
                              TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  prefix: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(width: 12),
                                      Image.asset(
                                        "assets/images/benin.png",
                                        width: 24,
                                      ), // Icône
                                      SizedBox(width: 8),
                                      Text(
                                        "+229",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                    ],
                                  ),
                                  hintText: "Numéro de téléphone",
                                  hintStyle: TextStyle(
                                    color: Color(0xFF4F4F4F),
                                    fontSize: screenWidth * 0.035,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      borderSide: BorderSide(color: Color(0xFF707070))
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF707070)),
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Ce champ est obligatoire";
                                  }
                                  /*else if (value.length != 10) {
                                    return "Le numéro doit comporter 10 chiffres";
                                  }*/
                                  return null;
                                },
                              )
                            ],
                          )*/
                      ),
                      Center(
                        child: TextButton(
                            onPressed: () async {
                              if(formKey.currentState!.validate()) {
                                await saveNumber();
                                context.push("/numberVerification");
                              }
                            },
                            child: Text("Je suis nouveau sur OptimaBâtis",
                              style: TextStyle(
                                color: Color(0xFF3172B8),
                                fontSize: screenWidth * 0.035,
                              ),
                            )
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Color(0xFF3172B8)),
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                                side: BorderSide(color: Color(0xFF707070), width: 1),
                              )),
                              foregroundColor: MaterialStateProperty.all(Colors.white)
                          ),
                          onPressed: () async {
                            if(formKey.currentState!.validate()) {
                              await saveNumber();
                              context.push('/authentication');
                            }
                          },
                          child: Text("Suivant",
                            style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
