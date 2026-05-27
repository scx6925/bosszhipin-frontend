import 'package:flutter/material.dart';
import '../models/job.dart';
import '../services/api_service.dart';

class JobProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Job> _jobs = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  Job? _currentJob;
  bool _isFavorited = false;

  List<Job> get jobs => _jobs;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  Job? get currentJob => _currentJob;
  bool get isFavorited => _isFavorited;

  Future<void> loadJobs({bool refresh = false}) async {
    if (_isLoading) return;
    if (refresh) {
      _page = 1;
      _hasMore = true;
    }
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _api.dio.get('/jobs', queryParameters: {
        'page': _page,
        'size': 10,
      });
      final data = res.data;
      if (data['code'] == 200) {
        final records = (data['data']['records'] as List)
            .map((j) => Job.fromJson(j))
            .toList();
        if (refresh) {
          _jobs = records;
        } else {
          _jobs.addAll(records);
        }
        _hasMore = records.length >= 10;
        _page++;
      }
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchJobs({
    String? keyword,
    String? city,
    int? salaryMin,
    int? salaryMax,
    String? education,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final params = <String, dynamic>{'page': 1, 'size': 10};
      if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;
      if (city != null && city.isNotEmpty) params['city'] = city;
      if (salaryMin != null) params['salaryMin'] = salaryMin;
      if (salaryMax != null) params['salaryMax'] = salaryMax;
      if (education != null && education.isNotEmpty) {
        params['education'] = education;
      }

      final res = await _api.dio.get('/jobs/search', queryParameters: params);
      if (res.data['code'] == 200) {
        _jobs = (res.data['data']['records'] as List)
            .map((j) => Job.fromJson(j))
            .toList();
        _hasMore = false;
      }
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadJobDetail(int jobId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _api.dio.get('/jobs/$jobId');
      if (res.data['code'] == 200) {
        _currentJob = Job.fromJson(res.data['data']);
      }
      // Check favorite status
      final favRes = await _api.dio.get('/favorites/check/$jobId');
      if (favRes.data['code'] == 200) {
        _isFavorited = favRes.data['data'] ?? false;
      }
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> toggleFavorite(int jobId) async {
    try {
      if (_isFavorited) {
        final res = await _api.dio.delete('/favorites/$jobId');
        if (res.data['code'] == 200) {
          _isFavorited = false;
          notifyListeners();
          return null;
        }
      } else {
        final res = await _api.dio.post('/favorites/$jobId');
        if (res.data['code'] == 200) {
          _isFavorited = true;
          notifyListeners();
          return null;
        }
        return res.data['message'];
      }
    } on Exception catch (e) {
      return e.toString();
    }
    return null;
  }
}
