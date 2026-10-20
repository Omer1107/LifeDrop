class UserModel {
  final String uid;
  final String name;
  final String email;
  final String bloodGroup;
  final String city;
  final String contact;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.bloodGroup,
    required this.city,
    required this.contact,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "bloodGroup": bloodGroup,
      "city": city,
      "contact": contact,
    };
  }
}