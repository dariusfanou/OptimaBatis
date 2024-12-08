import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'custom_navbar.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Text('Profil',style: TextStyle(color:Colors.white),),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(

        children: [
          Container(
            color: Colors.indigoAccent,
            padding: const EdgeInsets.symmetric(vertical: 60,horizontal: 40),
            child: Row(
              children: [
                 CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/african-american-woman-black-long-sleeve-tee-portrait.jpg'),
                ),
                const SizedBox(width: 10),
                Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  const Text(
                    'Codjo MAHOU',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //const SizedBox(height: 5),
                  const Text(
                    '+1 9998887776',
                    style: TextStyle(color: Colors.white),
                  ),
                  //const SizedBox(height: 5),
                  const Text(
                    'info@tradly.co',
                    style: TextStyle(color: Colors.white),
                  ),

                ],),

              ],
            ),
          ),
          Container(
            width: 300,
            height: 450,
            color: Colors.white60,
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Modifier le profil'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Langue'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.group_add),
                  title: const Text('Parrainez un ami'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Historique de mes activités'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications / Alertes'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Modifier mot de passe'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Supprimer le compte'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Déconnexion'),
                  onTap: () {},
                ),
              ],
            ),),

          Padding(
            padding: const EdgeInsets.all(10),
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Conditions générales d\'utilisation',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(currentIndex: 4),
    );
  }
}