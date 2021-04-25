import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testFireStore/models/product.dart';
import 'package:testFireStore/models/user.dart';
import 'package:testFireStore/services/clgDatabase.dart';

class ClgHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserModel>(context).uId;
    print(userData);
    return Scaffold(
      appBar: AppBar(
        title: Text("Clg App"),
        actions: [
          PopupMenuButton(
              onSelected: (value) {},
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("data"),
                      value: 0,
                    ),
                  ]),
        ],
      ),
      body: StreamBuilder<List<ProductModel>>(
          stream: ClgDataBaseService().products,
          builder: (context, snapshot) {
            return Column(
              children: [
                RaisedButton(
                  child: Text("Add Products"),
                  onPressed: () async {
                    await ClgDataBaseService(userId: userData).addProduct();
                  },
                ),
                if (snapshot.hasData)
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => Text(
                        snapshot.data[index].createdBy,
                      ),
                    ),
                  ),
              ],
            );
          }),
    );
  }
}
