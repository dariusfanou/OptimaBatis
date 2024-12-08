import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:optimabatis/pages/preference.dart';


class DocumentPhotoPage extends StatefulWidget {
  @override
  _DocumentPhotoPageState createState() => _DocumentPhotoPageState();
}

class _DocumentPhotoPageState extends State<DocumentPhotoPage> {
  List<Map<String, dynamic>> images = [];

  Future<void> selectPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        for (var file in result.files) {
          if (images.length < 3) {
            images.add({'name': file.name, 'path': file.path});
          }
        }
      });
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
            Navigator.pop(context);
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
            Text("Ajoutez une ou plusieurs photos pour illustrer le problème (formats acceptés : JPG, PNG)."),
            SizedBox(height: 20),
            GestureDetector(
              onTap: selectPhoto,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Text("Ajoutez une photo de profil"),
                      Icon(Icons.person, color: Colors.blue, size: 40),
                      Text("Photo de profil", style: TextStyle(color: Colors.blue)),
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
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Preference()),
                  );
                },
                child: Text(
                  "Suivant",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
