class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? phone;
  final String gender;
  final String image;
  final String? university;
  final String? bloodGroup;
  final int? age;

  // Only present right after /user/login
  final String? accessToken;
  final String? refreshToken;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.phone,
    this.gender = '',
    this.image = '',
    this.university,
    this.bloodGroup,
    this.age,
    this.accessToken,
    this.refreshToken,
  });

  String get fullName => '$firstName $lastName';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      gender: json['gender'] ?? '',
      image: json['image'] ?? '',
      university: json['university'],
      bloodGroup: json['bloodGroup'],
      age: json['age'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'phone': phone,
      'gender': gender,
      'image': image,
      'university': university,
      'bloodGroup': bloodGroup,
      'age': age,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  UserModel copyWith({String? accessToken, String? refreshToken}) {
    return UserModel(
      id: id,
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      phone: phone,
      gender: gender,
      image: image,
      university: university,
      bloodGroup: bloodGroup,
      age: age,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
