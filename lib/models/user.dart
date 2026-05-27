class User {
  final int id;
  final String phone;
  final String? name;
  final String? avatarUrl;
  final String? desiredPosition;
  final String? city;
  final int? salaryMin;
  final int? salaryMax;
  final String role;

  User({
    required this.id,
    required this.phone,
    this.name,
    this.avatarUrl,
    this.desiredPosition,
    this.city,
    this.salaryMin,
    this.salaryMax,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        phone: json['phone'] ?? '',
        name: json['name'],
        avatarUrl: json['avatarUrl'],
        desiredPosition: json['desiredPosition'],
        city: json['city'],
        salaryMin: json['salaryMin'],
        salaryMax: json['salaryMax'],
        role: json['role'] ?? 'JOB_SEEKER',
      );
}
