import 'package:flutter/material.dart';
import 'package:optimabatis/pages/custom_navbar.dart';

class NotificationPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {"date": "20 novembre 2024 - 15:00", "title": "Fête de l'habitat"},
    {"date": "20 novembre 2024 - 15:00", "title": "Fête de l'habitat"},
    {"date": "20 novembre 2024 - 15:00", "title": "Fête de l'habitat"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon:Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Notification',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 16.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 5,
              ),
              title: Text(
                notifications[index]["title"]!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(notifications[index]["date"]!),
              trailing: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/habitat.png', // Remplacez par votre image
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomNavBar( currentIndex: 0,isNotifPage: true, ),
    );
  }
}