import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:optimabatis/pages/password.dart';
import 'package:optimabatis/pages/password_creation.dart';
import 'package:optimabatis/pages/verification.dart';
import 'package:optimabatis/pages/password_creation.dart';
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
  bool isPhoneFieldEmpty = true;

  void checkPhoneField() {
    if(phoneNumber == null || phoneNumber!.isEmpty) {
      setState(() {
        isPhoneFieldEmpty = true;
      });
    }
    else {
      setState(() {
        isPhoneFieldEmpty = false;
      });
    }
  }

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
    return Scaffold(
      body: Stack(
        children: [
          // Contenu principal (par exemple, le carousel)
          Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 32),
                  decoration: BoxDecoration(
                      color: Color(0xFFD4E9FF)
                  ),
                  child:
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imgList.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => carouselController.animateToPage(entry.key),
                            child: Container(
                              width: 10, // Largeur du cercle
                              height: 10, // Hauteur du cercle
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: (currentIndex == entry.key)
                                      ? Color(0xFF3172B8)
                                      : Color(0xFFBDCDDE),
                                  width: 2, // Largeur de la bordure
                                ),
                                color: (currentIndex == entry.key)
                                    ? Color(0xFF3172B8) // Cercle plein pour l'actif
                                    : Colors.transparent, // Transparent pour les inactifs
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),
                      CarouselSlider(
                        carouselController: carouselController,
                        options: CarouselOptions(
                          height: 533,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                        items: imgList
                            .map((item) => Container(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                                children: [
                                  Image.asset(
                                    item,
                                    fit: BoxFit.cover,
                                    height: 340,
                                  ),
                                  Text(titleMap[item]!,
                                    style: TextStyle(
                                        color: Color(0xFF3172B8),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18
                                    ),
                                  ),
                                  Text(subtitleMap[item]!,
                                    style: TextStyle(
                                        color: Color(0xFF4B5563),
                                        fontSize: 13
                                    ),
                                  )
                                ])
                        )
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
            initialChildSize: 0.3, // Hauteur initiale (30% de l'écran)
            minChildSize: 0.3, // Hauteur minimale
            maxChildSize: 1.0, // Hauteur maximale (plein écran)
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
                  controller: scrollController, // Attache le défilement
                  padding: EdgeInsets.all(32),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                  onVerticalDragEnd: (details) {
                                    // Ajuste la position du `DraggableScrollableSheet`
                                    if (details.primaryVelocity! > 0) {
                                      // Glissement vers le bas -> réduire à 0.3
                                      _draggableController.animateTo(
                                        0.3,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    } else {
                                      // Glissement vers le haut -> agrandir à 1.0
                                      _draggableController.animateTo(
                                        1.0,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  child: Center(
                                child: Container(
                                  width: 55,
                                  height: 3,
                                  margin: EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Color(0x3B707070),
                                  ),
                                ),
                              ),
                              ),
                              Text("Entrez votre numéro de téléphone",
                                style: TextStyle(
                                    color: Color(0xFF1F2937),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text("Entrez votre numéro de téléphone pour vous connecter ou pour créer un nouveau compte.",
                                style: TextStyle(
                                    color: Color(0xFF4B5563),
                                    fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      IntlPhoneField(
                                        decoration: InputDecoration(
                                            hintText: "Numéro de téléphone",
                                            hintStyle: TextStyle(
                                              color: Color(0xFF4F4F4F),
                                              fontSize: 13,
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(32),
                                                borderSide: BorderSide(color: Color(0xFF707070))
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xFF707070)),
                                              borderRadius: BorderRadius.circular(32),
                                            )
                                        ),
                                        keyboardType: TextInputType.phone,
                                        initialCountryCode: 'BJ',
                                        onChanged: (phone) {
                                          phoneNumber = phone.completeNumber;
                                          checkPhoneField();
                                        },
                                        showDropdownIcon: false,
                                        flagsButtonMargin: EdgeInsets.only(left: 32),
                                        dropdownTextStyle: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1F2937),
                                        ),
                                      ),
                                      isPhoneFieldEmpty ?
                                      Container(
                                        padding: EdgeInsets.only(top: 3, left: 12),
                                        child: Text("Veuillez entrez un numéro de téléphone",
                                          style: TextStyle(
                                            color: Colors.red[700],
                                            fontSize: 12.3,
                                          ),
                                        ),
                                      ) :
                                      SizedBox()
                                    ],
                                  )
                              ),
                            ],
                          ),
                          Center(
                            child: TextButton(
                                onPressed: () async {
                                  if(formKey.currentState!.validate() && !isPhoneFieldEmpty) {
                                    await saveNumber();
                                    phoneNumber = "";
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return CreatePassword();
                                        })
                                    );
                                  }
                                },
                                child: Text("Je suis nouveau sur OptimaBâtis",
                                  style: TextStyle(
                                    color: Color(0xFF3172B8),
                                    fontSize: 13
                                  ),
                                )
                            ),
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
                                if(formKey.currentState!.validate() && !isPhoneFieldEmpty) {
                                  await saveNumber();
                                  phoneNumber = "";
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return PasswordPage();
                                      })
                                  );
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
                    ),
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
