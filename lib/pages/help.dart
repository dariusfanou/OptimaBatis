import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/auth_provider.dart';
import 'package:optimabatis/flutter_helpers/services/notification_service.dart';
import 'package:optimabatis/flutter_helpers/services/user_service.dart';
import 'package:optimabatis/pages/custom_navbar.dart';
import 'package:provider/provider.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String,String>> _clients = [
    {
      "title":'Questions Générales',
      "content":'1-	Qu’est-ce qu’OptimaBâtis ?\n'+

          'OptimaBâtis est une application mobile qui met en relation des clients avec des prestataires professionnels pour résoudre des problèmes de réparation, de réfection de bâtiment (maçonnerie, plomberie, électricité, menuiserie etc), rénovation partielle ou total de bâtiment, et de construction de BTP, et enfin des problèmes informatiques et réseaux .\n'
          +
          '2-	Qui peut utiliser OptimaBâtis ?\n'+

          'L’application est destinée aux clients ayant besoin de services ainsi qu’aux entreprises ou professionnels offrant des services de réparation et de maintenance.\n'
          +
          '3-	OptimaBâtis est-elle disponible dans mon pays ?\n'
          +
          'OptimaBâtis est actuellement disponible au Bénin, au Togo, au Niger, au Mali, au Burkina Faso, au Sénégal, en Côte d\'Ivoire et en Guinée. Vérifiez dans l’application pour connaître les zones supportées.\n'

    },
    {
      "title":'Compte et Inscription',
      "content":'4-	Comment créer un compte ?\n'+

      'Vous pouvez vous inscrire en utilisant votre numéro de téléphone, Google, Facebook ou Apple. N’oubliez pas de compléter votre profil en ajoutant votre prénom et votre genre.'+

          '5-	J’ai oublié mon mot de passe. Que dois-je faire ?'+

          'Utilisez l’option « Mot de passe oublié » sur la page de connexion pour le réinitialiser via SMS ou email.'+

          '6-	Puis-je mettre à jour mes informations de profil ?'+

          'Oui, vous pouvez modifier vos informations dans la section "Profil" de l’application.'
    },
    {
          "title":'Soumettre une Demande de Service',
          "content":'7-	Comment soumettre une demande de service ?'+

    'Accédez aux catégories de services (ex. : Plomberie, Menuiserie), sélectionnez votre problème, remplissez le formulaire en plusieurs étapes et ajoutez des photos si nécessaires.'+

    '8-	Puis-je joindre des photos à ma demande ?'+

    'Oui, vous pouvez ajouter des photos pour mieux illustrer le problème.'+


    '9-	Combien de temps faut-il pour qu’un professionnel réponde à ma demande ?'+

    'Les délais de réponse est instantanée ;'
    },
    {"title":"Paiements et Portefeuille",
      "content":'10-	Comment effectuer un paiement ?\n'+

          'Vous pouvez alimenter votre portefeuille avec de l’argent mobile, un virement bancaire ou une carte de crédit Visa. Les paiements sont sécurisés.'+

          '11-	Que se passe-t-il si mon portefeuille est insuffisant ?'+

          'Vous pouvez recharger votre portefeuille à tout moment avec les méthodes de paiement disponibles.'+

          '12-	Mes informations de paiement sont-elles sécurisées ?'+

          'Oui, OptimaBâtis utilise des standards de sécurité élevés pour protéger vos données personnelles et bancaires.'+

          '13-	Puis-je obtenir un remboursement si le service n’est pas satisfaisant ?'+

          'Les remboursements sont soumis à une revue selon les termes et conditions. Contactez le support pour obtenir de l’aide.'
    },
    {
      "title":'Messagerie et Notifications',
      "content":'14-	Puis-je communiquer directement avec un prestataire ?\n'+

      'Oui, une fois votre demande assignée, vous pouvez discuter avec le prestataire via la messagerie intégrée.'+

      '15-	Pourquoi je ne reçois pas les notifications ?'+

      'Vérifiez les paramètres de notification de l’application et de votre appareil pour vous assurer qu’elles sont activées.'+

      '16-	Questions pour les Administrateurs'+

      '17-	Comment signaler un problème avec un prestataire ou un service ?'+

      'Rendez-vous dans la section "Support" pour soumettre un rapport en détaillant le problème.'+

      '18-	Comment les prestataires sont-ils vérifiés ?'+

      'OptimaBâtis vérifie les prestataires grâce à des contrôles d’identité et de qualifications.'+

      '19-	Que faire si ma demande est retardée ou non résolue ?'+

      'Contactez notre support via l’application pour obtenir de l’aide et résoudre le problème.'},
    {
      "title":'Problèmes Techniques',
      "content":'20-	L’application ne fonctionne pas correctement. Que dois-je faire ?\n'+

          'Assurez-vous que l’application est mise à jour. Si le problème persiste, contactez le support.'+

          '21-	Puis-je utiliser OptimaBâtis hors ligne ?'+

          'Non, vous avez besoin d’une connexion Internet pour parcourir les services, soumettre des demandes et communiquer avec les prestataires.'
    },
    {
      "title":'Sécurité et Confidentialité',
      "content":'22-	Mes données personnelles sont-elles en sécurité sur OptimaBâtis ?\n'+

          'Oui, nous donnons la priorité à la confidentialité des utilisateurs et respectons les réglementations en matière de protection des données.'+

          '23-	Comment supprimer mon compte ?'+

          'Si vous souhaitez supprimer votre compte, accédez à "Paramètres" et sélectionnez "Supprimer mon compte". Cette action est irréversible.'

    },
    {
      "title":'Fonctionnalités Supplémentaires',
      "content":'24-	Puis-je planifier une demande de service ?\n'+

          'Oui, vous pouvez spécifier une date et une heure préférées lors de la soumission de votre demande.'+

          '25-	Comment suivre ma demande de service ?'+

          'Vous pouvez suivre le statut de votre demande dans la section "Mes Demandes", où les mises à jour sont affichées en temps réel.'+

          '26-	Puis-je consulter mon historique de transactions ?'+

          'Oui, la section "Portefeuille" affiche un historique détaillé de vos transactions, y compris les dépôts et les paiements.'+


          'Cette FAQ pourra être enrichie ou ajustée en fonction des retours des utilisateurs à mesure que l’application évolue.'
    }
  ];

  final userService = UserService();
  Map<String, dynamic>? authUser;
  late AuthProvider authProvider;

  Future<void> getAuthUser() async {
    try {
      final user = await userService.getUser();
      if (user != null) {
        setState(() {
          authUser = user;
        });
      } else {
        print("Aucun utilisateur authentifié trouvé.");
      }
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        Fluttertoast.showToast(msg: "Votre session a expirée. Veuillez vous reconnecter.");
        authProvider.logout();
        context.go("/welcome");
      }
      print("Erreur lors de la récupération de l'utilisateur : $error");
    }
  }

  final notificationService = NotificationService();
  List<Map<String, dynamic>> notifications = [];
  List<Map<String, dynamic>> notificationsNotRead = [];

  Future<void> loadNotifications() async {
    try {
      notifications = await notificationService.getAll();
      for (Map<String, dynamic> notification in notifications) {
        if(!notification["is_read"]) {
          notificationsNotRead.add(notification);
        }
      }
      setState(() {});
    } on DioException catch (e) {
      if (e.response != null) {
        if(e.response?.statusCode == 401) {
          Fluttertoast.showToast(msg: "Votre session a expirée. Veuillez vous reconnecter.");
          authProvider.logout();
          context.go("/welcome");
        }
        print(e.response?.data);
        print(e.response?.statusCode);
      } else {
        print(e.requestOptions);
        print(e.message);
      }

      Fluttertoast.showToast(msg: "Une erreur est survenue");
    }
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    getAuthUser();
    loadNotifications();
  }

  // Fonction pour filtrer les clients en fonction de la recherche
  List<Map<String,String>> _filterClients(String query) {
    return _clients.where((client) {
      return client['content']!.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: authUser?['photo'] != null
                  ? NetworkImage(authUser!['photo'])
                  : const AssetImage('assets/images/profile.png') as ImageProvider,
            ),
            Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/logotype.png",
                    width: 150,
                    height: 200,
                  ),
                )
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: (notificationsNotRead.length > 0) ? Badge(
              child: const Icon(
                Icons.notifications_active_outlined,
                color: Colors.black,
              ),
              label: Text("${notificationsNotRead.length}"),
            ) :
            const Icon(
              Icons.notifications_active_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              context.push('/notifications');
            },
          ),
        ],

      ),
      body:Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Expanded(child: ListView.builder(
            itemCount: _filterClients(_searchController.text).length,
            itemBuilder: (context, index){
              return ListView.builder(
                itemCount: _clients.length,
                itemBuilder: (context, index) {
                  final item = _clients[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: "${item['title']}\n",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: item['content'],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );

            },
          ),),
        ]
      ),
      bottomNavigationBar: CustomNavBar(currentIndex: 3),

    );
  }
}
