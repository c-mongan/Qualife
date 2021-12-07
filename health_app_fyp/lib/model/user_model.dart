class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? gender;
  int? age;
  int? weight;
  int? height;
  int? bmi;
  int? bmr;
  int? activityLevel;

  UserModel(
      {this.uid,
      this.email,
      this.firstName,
      this.secondName,
      this.gender,
      this.age,
      this.activityLevel,
      this.weight,
      this.bmr,
      this.bmi,
      this.height});

  //Get Data from the server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        secondName: map['secondName'],
        gender: map['gender'],
        age: map['age'],
        activityLevel: map['activityLevel'],
        weight: map['weight'],
        bmi: map['bmi'],
        bmr: map['bmr'],
        height: map['height']);
  }

//Send data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'gender': gender,
      'age': age,
      'activityLevel': activityLevel,
      'weight': weight,
      'bmi': bmi,
      'bmr': bmr,
      'height': height,
    };
  }

  @override
  String toString() => "Record<$uid:<$email:<$firstName";
}
