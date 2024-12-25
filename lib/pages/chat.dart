import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/auth_provider.dart';
import 'package:optimabatis/flutter_helpers/services/chat_service.dart';
import 'package:optimabatis/flutter_helpers/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> chats = [];
  late AuthProvider authProvider;
  bool loading = false;
  final chatService = ChatService();
  Map<String, dynamic>? authUser;
  final userService = UserService();

  // Récupération de l'utilisateur authentifié
  Future<void> getAuthUser() async {
    setState(() {
      loading = true;
    });
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
        Fluttertoast.showToast(
            msg: "Votre session a expirée. Veuillez vous reconnecter.");
        authProvider.logout();
        context.go("/welcome");
      }
      print("Erreur lors de la récupération de l'utilisateur : $error");
    }
  }

  // Chargement des messages
  Future<void> loadMessages() async {
    try {
      chats = await chatService.getAll();
      setState(() {});
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          Fluttertoast.showToast(
              msg: "Votre session a expirée. Veuillez vous reconnecter.");
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
        loading = false;
      });
    }
  }

  // Envoi d'un message
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final newMessage = {
      "sender": authUser!["id"] ?? int.parse("1"),
      "receiver": int.parse("29"), // Définir le destinataire
      "content": content,
    };

    try {
      Map<String, dynamic> response = await chatService.create(newMessage);
      setState(() {
        chats.add(newMessage);
      });
      print(chats);
      print(response);
    } on DioException catch (e) {
      if(e.response != null) {
        if (e.response?.statusCode == 401) {
          Fluttertoast.showToast(
              msg: "Votre session a expirée. Veuillez vous reconnecter.");
          authProvider.logout();
          context.go("/welcome");
        }
        Fluttertoast.showToast(msg: "Erreur lors de l'envoi du message.");
        print(e.response?.data ?? e.message);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    getAuthUser();
    loadMessages();
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
              const SizedBox(width: 28),
              Expanded(child: Image.asset("assets/images/back.png"))
            ],
          ),
        ),
        title: const Text("OptimaBâtis"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: loading
                  ? const Center(
                child:
                CircularProgressIndicator(), // Indicateur de chargement
              )
                  : ListView.builder(
                itemCount: chats.length, // Nombre de messages
                itemBuilder: (context, index) {
                  // Alternance des bulles
                  bool isMe = chats[index]["sender"] == authUser!["id"];
                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isMe ? const Color(0xFF3172B8) : Colors.grey[300],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chats[index]["content"],
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            chats[index]["created_at"],
                            style: TextStyle(
                              fontSize: 12,
                              color:
                              isMe ? Colors.white70 : Colors.black54,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "Message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Color(0xFF3172B8),
                    ),
                    onPressed: () {
                      sendMessage(_messageController.text);
                      _messageController.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
