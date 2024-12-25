import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/auth_provider.dart';
import 'package:optimabatis/flutter_helpers/services/user_service.dart';
import 'package:optimabatis/pages/custom_navbar.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  final userService = UserService();
  Map<String, dynamic>? authUser;
  bool isLoading = true;
  late AuthProvider authProvider;

  Future<void> getAuthUser() async {
    try {
      final user = await userService.getUser();
      setState(() {
        authUser = user;
        isLoading = false;
        print(authUser);
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Fluttertoast.showToast(msg: "Votre session a expirée. Veuillez vous reconnecter.");
        authProvider.logout();
        context.go("/welcome");
      }
      print('Erreur lors de la récupération des données utilisateur : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    getAuthUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      ) : Card(
        margin: EdgeInsets.only(bottom: 16.0),
        child: ListTile(
          subtitle: Text("Bonjour ${authUser!["first_name"]} 👋, bienvenue sur OptimaBâtis ! " +

              "Nous sommes ravis de vous compter parmi nos utilisateurs. "+

              "OptimaBâtis vous offre désormais une solution rapide et fiable pour gérer vos problèmes de dépannage immobilier en maçonnerie, plomberie, menuiserie, électricité, etc, de rénovation partielle ou totale, et de construction des bâtiments, et bien plus encore ! "+

              "🚀 Voici comment démarrer :\n"+

              "Explorez nos catégories de services. "+
              "Soumettez votre première demande en quelques clics. "+

              "Consultez vos notifications pour rester informé en temps réel. "+

              "Si vous avez des questions, notre support est là pour vous accompagner. "+

              "Ensemble, transformons notre quotidien en matière de réparation immobilière et bâtissons autrement l'avenir de rénovation et de construction. "+

              "Encore une fois, bienvenue dans la communauté OptimaBâtis !"),
        ),
      ),
      bottomNavigationBar: CustomNavBar( currentIndex: 0,isNotifPage: true, ),
    );
  }
}