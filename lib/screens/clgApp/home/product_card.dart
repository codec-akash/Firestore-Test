import 'package:flutter/material.dart';
import 'package:testFireStore/models/product.dart';

class ProductCard extends StatelessWidget {
  final ProductModel productModel;
  ProductCard({this.productModel});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown[200],
        border: Border.all(color: Colors.brown[700]),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(productModel.prodName),
              Text(productModel.prodAmount.toString()),
            ],
          ),
          SizedBox(height: 10.0),
          Text(productModel.produId),
          Text(productModel.createdBy),
        ],
      ),
    );
  }
}
