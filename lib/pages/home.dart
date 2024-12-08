import 'package:flutter/material.dart';
import 'package:optimabatis/pages/custom_navbar.dart';
import 'package:optimabatis/pages/notification.dart';
import 'package:optimabatis/pages/detail_intervention.dart';
import 'package:optimabatis/pages/informatique.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final images = [
      {'image':'assets/images/Macon.png','text':"Maçon"},
      {'image':'assets/images/Menuisier.png','text':"Menuisier"},
      {'image':'assets/images/Plombier.png','text':"Plombier"},
      {'image':'assets/images/Electricien.png','text':"Electricien"},
      {'image':'assets/images/Peintre.png','text' :"Peintre"},
      {'image':'assets/images/Soudeur.png','text':"Soudeur"},
      {'image':'assets/images/Tech_Solaire.png','text':"Tech.Solaire"},
      {'image':'assets/images/Charpentier.png','text':"Charpenter"},
      {'image':'assets/images/Frigoriste.png','text':"Frigoriste"},
      {'image':'assets/images/Vitrier.png','text':"Vitrier"},
      {'image':'assets/images/Carreleur.png','text':'Carreleur'},
      {'image':'assets/images/Reseau.png','text':"Réseau"},
      {'image':'assets/images/Informatique.png','text':"Informatique"}
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 120,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                  'assets/images/african-american-woman-black-long-sleeve-tee-portrait.jpg'),
            ),
            SizedBox(width: 70
            ),
            Image.asset("assets/images/logotype.png",width: 150,height: 200,),
            Spacer(),

          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NotificationPage()),);
            },
          ),
        ],

      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 200,
            decoration:BoxDecoration(
              color: Colors.limeAccent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.black,
                width: 1
              )
            ),
            //color: Colors.yellow,
            child: const Center(
              child: Text(
                "PUBLICITÉ",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 30,),
          Expanded(
            child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 1,childAspectRatio: 3/4),
            itemCount: images.length,
            itemBuilder: (context,index)
            {
              final item = images[index];
            return Column(
              children:[
                Expanded(child:
                GestureDetector(onTap: (){
                  if(item['text'] != 'Informatique')
                    {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> DetailsInterventionPage()),);
                    }
                  else{
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> informatique()),);
                  }

                },
                  child:Image.asset(item['image']!,
                    width: 200,
                    height: 200,
                  ),),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Text(item['text']!,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,),)
              ],
            );
            })
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(currentIndex: 0),
     );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, size: 30, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
