import 'package:shopping_app_task/features/auth/domain/entities/profile_entity.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.username,
    super.firstName,
    super.lastName,
    super.gender,
    super.email,
    super.image,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] as num?)?.toInt();
    if (id == null || id <= 0) throw const FormatException('Invalid profile');
    return ProfileModel(
      id: id,
      username: json['username'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      email: json['email'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'gender': gender,
    'image': image,
  };

  factory ProfileModel.fromEntity(Profile value) => ProfileModel(
    id: value.id,
    username: value.username,
    firstName: value.firstName,
    lastName: value.lastName,
    gender: value.gender,
    email: value.email,
    image: value.image,
  );

  Profile toEntity() => Profile(
    id: id,
    username: username,
    firstName: firstName,
    lastName: lastName,
    email: email,
    gender: gender,
    image: image,
  );
}
