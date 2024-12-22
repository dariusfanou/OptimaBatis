import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isNotifPage;

  CustomNavBar({required this.currentIndex, this.isNotifPage = false});


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: (currentIndex),
        onTap: (onTap)
    {
      if(onTap ==0){
        context.go("/home");
      }
      else if (onTap == 1)
      {
        context.go("/activities");
      }
      else if(onTap == 2)
      {
        context.go("/pub");
      }
      else if(onTap == 3)
      {
        context.go("/help");
      }
      else if(onTap == 4){
        context.go("/profile");
      }
    },
      selectedItemColor: isNotifPage?Colors.grey:Colors.blue,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Accueil",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: "Activités",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.campaign),
          label: "Publicité",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.help),
          label: "Aide",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profil",
        ),
      ],
    );
  }
}