class AppUserModel {
  final String uid;
  final String name;
  final String email;
  final String? profileImage;
  final DateTime createdAt;
  final bool isOnline;
  final DateTime? lastSeen;

  AppUserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImage,
    required this.createdAt,
    this.isOnline = false,
    this.lastSeen,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'createdAt': createdAt,
    };
  }

  //takes json and convert it into user object
  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
      createdAt: json['createdAt'].toDate(),
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen']?.toDate(),
    );
  }
}