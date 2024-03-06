import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Add this dependency
import 'db_helper.dart';

void main() {
  runApp(MyApp());
}

class ImageModel {
  final int id;
  final String imageUrl;

  ImageModel({required this.id, required this.imageUrl});

  Map<String, dynamic> toMap() {
    return {'id': id, 'imageUrl': imageUrl};
  }

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(id: map['id'], imageUrl: map['imageUrl']);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Image Database Example'),
        ),
        body: ImageList(),
      ),
    );
  }
}

class ImageList extends StatefulWidget {
  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  List<ImageModel> images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    List<Map<String, dynamic>> imageMaps = await DBHelper.instance.getImages();

    setState(() {
      images = imageMaps.map((map) => ImageModel.fromMap(map)).toList();
    });
  }

  Future<void> _saveImage() async {
    String imageUrl = 'https://t.ly/oFVa2';
    Map<String, dynamic> image = {'imageUrl': imageUrl};

    await DBHelper.instance.insertImage(image);

    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _saveImage,
          child: Text('Save Image to Database'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(images[index].imageUrl+ " hello"),
                leading: CachedNetworkImage(
                  imageUrl: images[index].imageUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                // Add more UI elements or customize as needed
              );
            },
          ),
        ),
      ],
    );
  }
}
