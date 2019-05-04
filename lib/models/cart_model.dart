import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/datas/cart_product.dart';
import 'package:flutter_e_commerce/models/user_model.dart';
import 'package:flutter_e_commerce/util/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  Firestore firestore = Firestore.instance;

  UserModel user;

  List<CartProduct> products = [];

  String couponCode;

  int discountPercent = 0;

  CartModel(this.user) {
    if (user.isLoggedIn()) _loadItems();
  }

  bool isLoading = false;

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  int getCountProducts() => products.length;

  bool isEmpty() {
    return products.isEmpty;
  }

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    firestore
        .collection(usersCollection)
        .document(user.firebaseUser.uid)
        .collection(cartCollection)
        .add(cartProduct.toMap())
        .then((product) {
      cartProduct.cartId = product.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    firestore
        .collection(usersCollection)
        .document(user.firebaseUser.uid)
        .collection(cartCollection)
        .document(cartProduct.cartId)
        .delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  void plusOne(CartProduct cartProduct) {
    cartProduct.plusOne();

    firestore
        .collection(usersCollection)
        .document(user.firebaseUser.uid)
        .collection(cartCollection)
        .document(cartProduct.cartId)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void lessOne(CartProduct cartProduct) {
    cartProduct.lessOne();

    firestore
        .collection(usersCollection)
        .document(user.firebaseUser.uid)
        .collection(cartCollection)
        .document(cartProduct.cartId)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  Future<Null> _loadItems() async {
    QuerySnapshot query = await firestore
        .collection(usersCollection)
        .document(user.firebaseUser.uid)
        .collection(cartCollection)
        .getDocuments();

    products =
        query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }

  void applyCoupon(String couponCode, int discountPercent) {
    this.couponCode = couponCode;
    this.discountPercent = discountPercent;
  }

  void removeCoupon() {
    this.couponCode = null;
    this.discountPercent = 0;
  }

  bool hasCoupon() {
    return discountPercent > 0;
  }

  double subTotal() {
    double sum = 0.0;

    for(CartProduct item in products) {
      if (item.productData != null)
        sum += (item.productData.price * item.quantity);
    }

    return sum;
  }

  double discountApplied() {
    if (hasCoupon()) return (subTotal() * discountPercent / 100);
    return 0.0;
  }

  double shipPrice() {
    return 0.0;
  }

  double total() {
    return subTotal() - discountApplied() + shipPrice();
  }

  void update() {
    notifyListeners();
  }

  Future<String> finishOrder() async {
    if (isEmpty()) return null;

    _startLoading();

    DocumentReference ref = await firestore.collection(ordersCollection).add({
      orderConsumerIdField: user.firebaseUser.uid,
      orderProductsField:
          products.map((cartProduct) => cartProduct.toMap()).toList(),
      orderSubTotalField: subTotal(),
      orderDiscountField: discountApplied(),
      orderShipPriceField: shipPrice(),
      orderTotalField: total(),
      orderStatusField: 0,
    });

    await firestore
        .collection(usersCollection)
        .document(user.firebaseUser.uid)
        .collection(ordersCollection)
        .document(ref.documentID)
        .setData({
      userOrderId: ref.documentID,
    });

    QuerySnapshot query = await firestore
        .collection(usersCollection)
        .document(user.firebaseUser.uid)
        .collection(cartCollection)
        .getDocuments();

    query.documents.forEach((doc) => doc.reference.delete());

    products.clear();

    removeCoupon();

    _stopLoading();

    return ref.documentID;
  }

  void _startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void _stopLoading() {
    isLoading = false;
    notifyListeners();
  }
}
