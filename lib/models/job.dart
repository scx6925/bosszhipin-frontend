class Job {
  final int id;
  final String title;
  final String companyName;
  final String? companyLogo;
  final String city;
  final int salaryMin;
  final int salaryMax;
  final String? education;
  final String? experience;
  final String? description;
  final String? companyDesc;
  final String? tags;
  final int viewCount;
  final String? publishTime;

  Job({
    required this.id,
    required this.title,
    required this.companyName,
    this.companyLogo,
    required this.city,
    required this.salaryMin,
    required this.salaryMax,
    this.education,
    this.experience,
    this.description,
    this.companyDesc,
    this.tags,
    this.viewCount = 0,
    this.publishTime,
  });

  String get salaryDisplay => '${salaryMin}K-${salaryMax}K';
  String get companyInitial => companyName.isNotEmpty ? companyName[0] : '?';

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json['id'],
        title: json['title'] ?? '',
        companyName: json['companyName'] ?? '',
        companyLogo: json['companyLogo'],
        city: json['city'] ?? '',
        salaryMin: json['salaryMin'] ?? 0,
        salaryMax: json['salaryMax'] ?? 0,
        education: json['education'],
        experience: json['experience'],
        description: json['description'],
        companyDesc: json['companyDesc'],
        tags: json['tags'],
        viewCount: json['viewCount'] ?? 0,
        publishTime: json['publishTime'],
      );
}
