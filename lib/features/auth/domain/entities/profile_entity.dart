class Profile {
  const Profile({
    required this.id,
    required this.username,
    this.firstName = '',
    this.lastName = '',
    this.gender = '',
    this.email = '',
    this.image = '',
  });
  final int id;
  final String username, firstName, lastName, image, gender, email;

  String get name => '$firstName $lastName'.trim().isEmpty
      ? username
      : '$firstName $lastName'.trim();
}
