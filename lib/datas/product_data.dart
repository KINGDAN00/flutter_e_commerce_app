import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_e_commerce/util/firebase_database.dart';

class ProductData {
  String id;

  String title;

  String description;

  double price;

  List images;

  List sizes;

  String category;

  ProductData.fromDocument(DocumentSnapshot snapshotData, {String category}) {
    id = snapshotData.documentID;
    title = snapshotData[productTitleField];
    description = snapshotData[productDescriptionField];
    price = snapshotData[productPriceField];
    images = snapshotData[productImagesField];
    sizes = snapshotData[productSizesField];

    this.category = category;
  }

  Map<String, dynamic> toResumeMap() {
    return {
      productTitleField: title,
      productDescriptionField: description,
      productPriceField: price,
    };
  }
}
