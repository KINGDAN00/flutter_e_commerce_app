import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_e_commerce/datas/product_data.dart';
import 'package:flutter_e_commerce/util/firebase_database.dart';

class CartProduct {
  String cartId;

  String productId;

  String category;

  int quantity;

  String size;

  ProductData productData;

  CartProduct(this.size, this.quantity, this.productId, this.category, this.productData);

  CartProduct.fromDocument(DocumentSnapshot snapshot) {
    cartId = snapshot.documentID;
    productId = snapshot.data[cartProductIdField];
    category = snapshot.data[cartCategoryField];
    quantity = snapshot.data[cartQuantityField];
    size = snapshot.data[cartSizeField];
  }

  Map<String, dynamic> toMap() {
    return {
      cartProductIdField: productId,
      cartCategoryField: category,
      cartQuantityField: quantity,
      cartSizeField: size,
      cartProductResumeField: productData.toResumeMap(),
    };
  }

  bool hasLessOne() {
    return quantity > 1;
  }

  void plusOne() {
    quantity++;
  }

  void lessOne() {
    quantity--;
  }
}
