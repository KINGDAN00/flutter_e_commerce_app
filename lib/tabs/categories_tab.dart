import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/tiles/category_tile.dart';

class CategoriesTab extends StatelessWidget {
  final _categoriesCollection = 'categories';
  final _priorityField = 'priority';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance
          .collection(_categoriesCollection)
          .orderBy(_priorityField)
          .getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          var dividedTiles = ListTile.divideTiles(
            tiles: snapshot.data.documents.map((doc) {
              return CategoryTile(doc);
            }).toList(), color: Colors.blueGrey[700],).toList();

          return ListView(
            children: dividedTiles,
          );
        }
      },
    );
  }
}
