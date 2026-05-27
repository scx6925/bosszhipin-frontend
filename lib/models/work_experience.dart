class WorkExperience {
  final int? id;
  final String company;
  final String position;
  final String? description;
  final String startDate;
  final String? endDate;

  WorkExperience({
    this.id,
    required this.company,
    required this.position,
    this.description,
    required this.startDate,
    this.endDate,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) => WorkExperience(
        id: json['id'],
        company: json['company'] ?? '',
        position: json['position'] ?? '',
        description: json['description'],
        startDate: json['startDate'] ?? '',
        endDate: json['endDate'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'company': company,
        'position': position,
        'description': description,
        'startDate': startDate,
        'endDate': endDate,
      };
}
