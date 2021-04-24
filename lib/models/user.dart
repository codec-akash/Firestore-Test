class UserModel {
  final String uId;

  UserModel({this.uId});
}

class UserDataModel {
  final String uid;
  final String name;
  final String sugars;
  final int strength;

  UserDataModel({
    this.name,
    this.sugars,
    this.strength,
    this.uid,
  });
}
