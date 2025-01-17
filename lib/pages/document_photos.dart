import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentPhotoPage extends StatefulWidget {
  @override
  _DocumentPhotoPageState createState() => _DocumentPhotoPageState();
}

class _DocumentPhotoPageState extends State<DocumentPhotoPage> {
  List<Map<String, dynamic>> images = [];
  int i = 0;

  Future<void> takePhoto() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final picker = ImagePicker();

    // Prendre une photo avec la caméra
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      // Ajouter l'image à la liste et sauvegarder son chemin
      final newImage = {'name': photo.name, 'path': photo.path};

      // Vérifiez si vous n'avez pas déjà 3 images
      if (images.length < 3) {
        // Enregistrez le chemin de l'image dans les SharedPreferences
        await prefs.setString("image$i", photo.path);

        setState(() {
          images.add(newImage);
          i++; // Incrémenter l'indice pour la prochaine image
        });
      }
    }
  }

  void showPreview(String path) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(File(path)),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fermer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/describeIntervention");
          },
        ),
        title: Text("Documents et Photos"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 5),
                  CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white,
                      )),
                  SizedBox(width: 5),
                  CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white,
                      )),
                  SizedBox(width: 5),
                  CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.blue,
                      )),
                  SizedBox(width: 5),
                  CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white,
                      )),
                ],
              ),
            ),
            Text(
              "Photo(s) du Problème",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Ajoutez une ou plusieurs photos pour illustrer le problème (formats acceptés : JPG, PNG).",
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: takePhoto,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Text("Ajoutez une photo"),
                      Icon(Icons.camera_alt, color: Colors.blue, size: 40),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.image),
                      title: Text(images[index]['name']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.visibility),
                            onPressed: () => showPreview(images[index]['path']),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                images.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF3172B8)),
                  elevation: MaterialStateProperty.all(0),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                      side: BorderSide(color: Color(0xFF707070), width: 1),
                    ),
                  ),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () async {
                  context.go("/preference");
                },
                child: Text(
                  "Suivant",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
