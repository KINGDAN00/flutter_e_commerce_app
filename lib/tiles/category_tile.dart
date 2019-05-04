import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/screens/categories_screen.dart';

class CategoryTile extends StatelessWidget {
  final _titleField = 'title';
  final _iconField = 'icon';

  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data[_iconField]),
      ),
      title: Text(snapshot.data[_titleField]),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CategoriesScreen(snapshot)));
      },
    );
  }
}
