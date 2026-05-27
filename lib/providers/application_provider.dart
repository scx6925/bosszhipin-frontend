import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ApplicationRecord {
  final int id;
  final Map<String, dynamic> job;
  final String status;
  final String appliedAt;
  final String? updatedAt;

  ApplicationRecord({
    required this.id,
    required this.job,
    required this.status,
    required this.appliedAt,
    this.updatedAt,
  });

  factory ApplicationRecord.fromJson(Map<String, dynamic> json) =>
      ApplicationRecord(
        id: json['id'],
        job: json['job'],
        status: json['status'],
        appliedAt: json['appliedAt'] ?? '',
        updatedAt: json['updatedAt'],
      );
}

class ApplicationProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<ApplicationRecord> _records = [];
  bool _isLoading = false;

  List<ApplicationRecord> get records => _records;
  bool get isLoading => _isLoading;

  Future<void> loadRecords() async {
    _isLoading = true;
    notifyListeners();
    try {
      final res =
          await _api.dio.get('/applications', queryParameters: {'page': 1, 'size': 50});
      if (res.data['code'] == 200) {
        _records = (res.data['data']['records'] as List)
            .map((r) => ApplicationRecord.fromJson(r))
            .toList();
      }
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> apply(int jobId) async {
    try {
      final res = await _api.dio.post('/applications/$jobId');
      if (res.data['code'] == 200) {
        await loadRecords();
        return null;
      }
      return res.data['message'] ?? '投递失败';
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
