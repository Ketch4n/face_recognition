class User2 {
  String id;
  final String name;
  final String email;
  final String role;
  // final String address;
  // final String birth;

  User2({
    this.id = '',
    required this.name,
    required this.email,
    required this.role,
    // required this.address,
    // required this.birth,
  });

  Map<String, dynamic> toJson() => {
        'card': id,
        'name': name,
        'email': email,
        'role': role,
        // 'address': address,
        // 'birth': birth,
      };

  static User2 fromJson(Map<String, dynamic> json) => User2(
        id: json['card'],
        name: json['name'],
        email: json['email'],
        role: json['role'],
        // address: json['address'],
        // birth: json['birth'],
      );
}

class UserDetails {
  static String id = " ";
  static String name = " ";
  static String email = " ";
  static String role = " ";
  static String card = " ";
}
