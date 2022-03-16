class UserModel{
  String? uid;
  String? email;
  String? fname;
  String? lname;
  String? type;

  UserModel({this.uid, this.email, this.fname, this.lname, this.type});

  factory UserModel.fromMap(map)
  {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      fname: map['fname'],
      lname: map['lname'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return{
      'uid': uid,
      'email': email,
      'fname':fname,
      'lname':lname,
      'type': type,
    };
  }
}