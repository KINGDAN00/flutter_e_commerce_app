import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/tiles/place_tile.dart';
import 'package:flutter_e_commerce/util/firebase_database.dart';

class PlacesTab extends StatelessWidget {
  final Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: firestore
          .collection(placesCollections)
          .orderBy(placePriorityField)
          .getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else
          return ListView(
            children:
                snapshot.data.documents.map((doc) => PlaceTile(doc)).toList(),
          );
      },
    );
  }
}
