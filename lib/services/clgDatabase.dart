import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testFireStore/models/product.dart';

class ClgDataBaseService {
  final String userId;
  ClgDataBaseService({this.userId});

  final CollectionReference clgCollection =
      FirebaseFirestore.instance.collection("products");

  List<ProductModel> _productModelFromFireStore(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((e) {
      return ProductModel(
        prodName: e.data()['product_Name'] ?? "No Name",
        prodAmount: e.data()['amount'] ?? 0.0,
        produId: e.id,
        createdBy: e.data()['createdBy'],
      );
    }).toList();
  }

  Stream<List<ProductModel>> get products {
    return clgCollection
        .snapshots()
        .map((event) => _productModelFromFireStore(event));
  }

  Future addProduct() async {
    DocumentReference documentReference = await clgCollection.add({
      "userId": userId,
      "amount": 510.23,
      "createdBy": "Akash Dube",
      "product_Name": "Book",
    });
    print(documentReference.id);
  }
}
