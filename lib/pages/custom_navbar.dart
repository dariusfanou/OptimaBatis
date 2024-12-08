import 'package:flutter/material.dart';
import 'package:optimabatis/pages//help.dart';
import 'package:optimabatis/pages//profile.dart';
import 'package:optimabatis/pages//publicite.dart';
import 'package:optimabatis/pages/activity_onload.dart';
import 'package:optimabatis/pages/home.dart';

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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()),);
      }
      else if (onTap == 1)
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Activity_onload()),);
      }
      else if(onTap == 2)
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Publicite()),);
      }
      else if(onTap == 3)
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Help()),);
      }
      else if(onTap == 4){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ProfilePage()),);
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