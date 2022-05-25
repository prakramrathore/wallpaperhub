import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaperhubapp/data/data.dart';
import 'package:wallpaperhubapp/models/categories_model.dart';
import 'package:wallpaperhubapp/models/wallpaper_model.dart';
import 'package:wallpaperhubapp/widgets/widget.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategorieModel> categories = [];
  List<WallpaperModel> wallpapers = [];

  getTrendingWallpapers() async{
    var response = await http.get(Uri.parse("https://api.pexels.com/v1/curated?per_page=15&page=1")
    , headers: {
      'Authorization' : apiKEY
        });

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData['photos'].forEach((element) {
      WallpaperModel wallpaperModel = WallpaperModel(photographer_id: null, src: null, photographer: null, photographer_url: null);
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {

    });

  }

  @override
  void initState() {
    categories = getCategories();
    getTrendingWallpapers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(30.0)
                ),
                margin: EdgeInsets.symmetric(horizontal: 24.0),
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: const <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'search wallpaper',
                          border: InputBorder.none
                        ),
                      ),
                    ),
                    Icon(Icons.search)
                  ],
                ),
              ),
              Container(
                height: 80.0,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index){
                    return CategoriesTile(title: categories[index].categorieName, imgUrl: categories[index].imgUrl);
                  },
                ),
              ),
              SizedBox(height: 16.0),
              wallpapersList(wallpapers: wallpapers, context: context),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {

  late final String imgUrl, title;
  CategoriesTile({required this.title, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4.0),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(imgUrl, height: 50, width: 100, fit: BoxFit.cover),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8.0),
            ),
            height: 50,
            width: 100,
            alignment: Alignment.center,
            child: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15.0),)
          ),
        ],
      ),
    );
  }
}




