class Measurements {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? gender;
  int? age;
  int? weight;
  int? height;
  double? bmi;
  double? tdee;
  int? activityLevel;
  String? bmiTime;

  Measurements(
      {this.uid,
      this.email,
      this.firstName,
      this.secondName,
      this.gender,
      this.age,
      this.activityLevel,
      this.weight,
      this.tdee,
      this.bmi,
      this.height,
      this.bmiTime});

  //Get Data from the server
  factory Measurements.fromMap(map) {
    return Measurements(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        secondName: map['secondName'],
        gender: map['gender'],
        age: map['age'],
        activityLevel: map['activityLevel'],
        weight: map['weight'],
        bmi: map['bmi'],
        bmiTime: map['bmiTime'],
        tdee: map['tdee'],
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
      // 'bmi': bmi,
      // 'bmiTime': bmiTime,
      // 'tdee': tdee,
      'height': height,
    };
  }

//   //Send data to our server
//   Map<String, dynamic> toJson() => {'bmi': bmi};

//   Measurements.fromSnapshot(snapshot, this.uid) : bmi = snapshot.data()['bmi'];
// }

  Measurements fromJson(Map<String, dynamic> json) => Measurements(
      age: json['age'],
      activityLevel: json['activityLevel'],
      weight: json['weight'],
      // bmi: json['bmi'],
      // bmiTime: json['bmiTime'],
      // tdee: json['tdee'],
      height: json['height']);

//   // @override
//   // String toString() => "Record<$uid:<$email:<$firstName";

//   toList() {}
// }
}
