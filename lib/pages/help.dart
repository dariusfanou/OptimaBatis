import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/flutter_helpers/services/user_service.dart';
import 'package:optimabatis/pages/custom_navbar.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _clients = [
    'Questions Générales',

  '1-	Qu’est-ce qu’OptimaBâtis ?',

  'OptimaBâtis est une application mobile qui met en relation des clients avec des prestataires professionnels pour résoudre des problèmes de réparation, de réfection de bâtiment (maçonnerie, plomberie, électricité, menuiserie etc), rénovation partielle ou total de bâtiment, et de construction de BTP, et enfin des problèmes informatiques et réseaux ;',

  '2-	Qui peut utiliser OptimaBâtis ?',

  'L’application est destinée aux clients ayant besoin de services ainsi qu’aux entreprises ou professionnels offrant des services de réparation et de maintenance.',

  '3-	OptimaBâtis est-elle disponible dans mon pays ?',

  'OptimaBâtis est actuellement disponible dans [liste des pays, par exemple : les pays d’Afrique de l’Ouest]. Vérifiez dans l’application pour connaître les zones supportées.',

  'Compte et Inscription',

  '4-	Comment créer un compte ?',

  'Vous pouvez vous inscrire en utilisant votre numéro de téléphone, Google, Facebook ou Apple. N’oubliez pas de compléter votre profil en ajoutant votre prénom et votre genre.',

  '5-	J’ai oublié mon mot de passe. Que dois-je faire ?',

  'Utilisez l’option « Mot de passe oublié » sur la page de connexion pour le réinitialiser via SMS ou email.',

  '6-	Puis-je mettre à jour mes informations de profil ?',

  'Oui, vous pouvez modifier vos informations dans la section "Profil" de l’application.',

  'Soumettre une Demande de Service',

  '7-	Comment soumettre une demande de service ?',

  'Accédez aux catégories de services (ex. : Plomberie, Menuiserie), sélectionnez votre problème, remplissez le formulaire en plusieurs étapes et ajoutez des photos si nécessaires.',

  '8-	Puis-je joindre des photos à ma demande ?',

  'Oui, vous pouvez ajouter des photos pour mieux illustrer le problème.',


  '9-	Combien de temps faut-il pour qu’un professionnel réponde à ma demande ?',

  'Les délais de réponse est instantanée ;',


  'Paiements et Portefeuille',

  '10-	Comment effectuer un paiement ?',

  'Vous pouvez alimenter votre portefeuille avec de l’argent mobile, un virement bancaire ou une carte de crédit Visa. Les paiements sont sécurisés.',

  '11-	Que se passe-t-il si mon portefeuille est insuffisant ?',

  'Vous pouvez recharger votre portefeuille à tout moment avec les méthodes de paiement disponibles.',

  '12-	Mes informations de paiement sont-elles sécurisées ?',

  'Oui, OptimaBâtis utilise des standards de sécurité élevés pour protéger vos données personnelles et bancaires.',

  '13-	Puis-je obtenir un remboursement si le service n’est pas satisfaisant ?',

  'Les remboursements sont soumis à une revue selon les termes et conditions. Contactez le support pour obtenir de l’aide.',


  'Messagerie et Notifications',

  '14-	Puis-je communiquer directement avec un prestataire ?',

  'Oui, une fois votre demande assignée, vous pouvez discuter avec le prestataire via la messagerie intégrée.',

  '15-	Pourquoi je ne reçois pas les notifications ?',

  'Vérifiez les paramètres de notification de l’application et de votre appareil pour vous assurer qu’elles sont activées.',

  '16-	Questions pour les Administrateurs',

  '17-	Comment signaler un problème avec un prestataire ou un service ?',

  'Rendez-vous dans la section "Support" pour soumettre un rapport en détaillant le problème.',

  '18-	Comment les prestataires sont-ils vérifiés ?',

  'OptimaBâtis vérifie les prestataires grâce à des contrôles d’identité et de qualifications.',

  '19-	Que faire si ma demande est retardée ou non résolue ?',

  'Contactez notre support via l’application pour obtenir de l’aide et résoudre le problème.',


  'Problèmes Techniques',

  '20-	L’application ne fonctionne pas correctement. Que dois-je faire ?',

  'Assurez-vous que l’application est mise à jour. Si le problème persiste, contactez le support.',

  '21-	Puis-je utiliser OptimaBâtis hors ligne ?',

  'Non, vous avez besoin d’une connexion Internet pour parcourir les services, soumettre des demandes et communiquer avec les prestataires.',


  'Sécurité et Confidentialité',

  '22-	Mes données personnelles sont-elles en sécurité sur OptimaBâtis ?',

  'Oui, nous donnons la priorité à la confidentialité des utilisateurs et respectons les réglementations en matière de protection des données.',

  '23-	Comment supprimer mon compte ?',

  'Si vous souhaitez supprimer votre compte, accédez à "Paramètres" et sélectionnez "Supprimer mon compte". Cette action est irréversible.',


  'Fonctionnalités Supplémentaires',

  '24-	Puis-je planifier une demande de service ?',

  'Oui, vous pouvez spécifier une date et une heure préférées lors de la soumission de votre demande.',

  '25-	Comment suivre ma demande de service ?',

  'Vous pouvez suivre le statut de votre demande dans la section "Mes Demandes", où les mises à jour sont affichées en temps réel.',

  '26-	Puis-je consulter mon historique de transactions ?',

  'Oui, la section "Portefeuille" affiche un historique détaillé de vos transactions, y compris les dépôts et les paiements.',


  'Cette FAQ pourra être enrichie ou ajustée en fonction des retours des utilisateurs à mesure que l’application évolue.',
  ];

  final userService = UserService();
  Map<String, dynamic>? authUser;

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
    } catch (error) {
      print("Erreur lors de la récupération de l'utilisateur : $error");
    }
  }

  @override
  void initState() {
    super.initState();
    getAuthUser();
  }

  // Fonction pour filtrer les clients en fonction de la recherche
  List<String> _filterClients(String query) {
    return _clients.where((client) => client.toLowerCase().contains(query.toLowerCase())).toList();
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
            icon: const Icon(Icons.notifications_active_outlined, color: Colors.black),
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
              return ListTile(
                title: Text(_filterClients(_searchController.text)[index]),
              );
            },
          ))
        ]
      ),
      bottomNavigationBar: CustomNavBar(currentIndex: 3),

    );
  }
}
