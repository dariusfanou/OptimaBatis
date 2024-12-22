import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:optimabatis/pages/custom_navbar.dart';

class Informatique extends StatelessWidget {
  const Informatique({super.key});

  @override
  Widget build(BuildContext context) {
    final images = [
      {
        'image': 'assets/images/SYSTEM_ADMINISTRATION.png',
        'text': "Système admin"
      },
      {'image': 'assets/images/Graphisme.png', 'text': "Graphisme"},
      {'image': 'assets/images/SEO.png', 'text': "SEO"},
      {'image': 'assets/images/Appli_&_mobile.png', 'text': "Web/App Dev"},
      {
        'image': 'assets/images/Network_administration.png',
        'text': "NetWork admin"
      },
    ];
    return Scaffold(
      appBar: AppBar(
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
        title: Text('Informatique'),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 3 / 4),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final item = images[index];
                      return Column(
                        children:[
                          Expanded(child:
                          GestureDetector(onTap: (){

                            context.push("/typeDemande?service=${item['text']}");
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
                    })),
          ],
        ),
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
