class Education {
  final int? id;
  final String school;
  final String major;
  final String degree;
  final String startDate;
  final String? endDate;

  Education({
    this.id,
    required this.school,
    required this.major,
    required this.degree,
    required this.startDate,
    this.endDate,
  });

  factory Education.fromJson(Map<String, dynamic> json) => Education(
        id: json['id'],
        school: json['school'] ?? '',
        major: json['major'] ?? '',
        degree: json['degree'] ?? '',
        startDate: json['startDate'] ?? '',
        endDate: json['endDate'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'school': school,
        'major': major,
        'degree': degree,
        'startDate': startDate,
        'endDate': endDate,
      };
}
