import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/auth_provider.dart';
import 'package:optimabatis/flutter_helpers/services/notification_service.dart';
import 'package:optimabatis/pages/custom_navbar.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  bool isLoading = false;
  late AuthProvider authProvider;
  final notificationService = NotificationService();
  List<Map<String, dynamic>> notifications = [];

  Future<void> loadNotifications() async {
    setState(() {
      isLoading = true;
    });
    try {
      notifications = await notificationService.getAll();
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    loadNotifications();
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
      body: isLoading ?
      const Center(
        child: CircularProgressIndicator(), // Indicateur de chargement
      ) : (notifications.length > 0) ?
      Container(
        margin: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return Card(
                color: Colors.transparent,
                elevation: 0,
                child: ListTile(
                  leading: (notifications[index]["is_read"] != null && !notifications[index]["is_read"]) ?
                  Icon(Icons.circle, color: Color(0xFF3172B8), size: 12,) :
                  SizedBox(),
                  title: Text(
                    notifications[index]["title"] ?? "Titre non disponible", // Texte du titre
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Style du titre
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    notifications[index]["content"] ?? "Contenue indisponible", // Texte du sous-titre
                    style: TextStyle(fontSize: 14), // Style du sous-titre
                    maxLines: 2,
                  ),
                  onTap: (){
                    context.pushReplacement("/notifications/${notifications[index]["id"]}");
                  },
                )
            );
          },
        ),
      ):
      Container(
        margin: EdgeInsets.all(10),
        child: Center(
          child: Text("Aucune notification disponible"),
        ),
      ),
      bottomNavigationBar: CustomNavBar( currentIndex: 0,isNotifPage: true, ),
    );
  }
}