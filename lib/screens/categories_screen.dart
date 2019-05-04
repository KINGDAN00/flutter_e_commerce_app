import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce/constants/tab_type.dart';
import 'package:flutter_e_commerce/datas/product_data.dart';
import 'package:flutter_e_commerce/tiles/product_tile.dart';
import 'package:flutter_e_commerce/util/firebase_database.dart';
import 'package:flutter_e_commerce/widgets/cart_button.dart';

class CategoriesScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoriesScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: CartButton(),
        appBar: AppBar(
          title: Text(
            snapshot.data[productTitleField],
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.grid_on),
              ),
              Tab(
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection(categoriesCollection)
              .document(snapshot.documentID)
              .collection(productsCollection)
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else
              return TabBarView(
//                physics: NeverScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    padding: EdgeInsets.all(4.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      crossAxisCount: 2,
                      childAspectRatio: 0.60,
                    ),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      ProductData productData = ProductData.fromDocument(
                          snapshot.data.documents[index],
                          category: this.snapshot.documentID);

                      return ProductTile(
                        TabType.grid,
                        productData,
                      );
                    },
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(4.0),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      ProductData productData = ProductData.fromDocument(
                          snapshot.data.documents[index],
                          category: this.snapshot.documentID);

                      return ProductTile(
                        TabType.list,
                        productData,
                      );
                    },
                  ),
                ],
              );
          },
        ),
      ),
    );
  }
}
