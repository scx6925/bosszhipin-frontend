import 'package:flutter/material.dart';
import '../models/job.dart';
import '../services/api_service.dart';

class FavoriteProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<Job> _favorites = [];
  bool _isLoading = false;

  List<Job> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _api.dio.get('/favorites', queryParameters: {
        'page': 1,
        'size': 50,
      });
      if (res.data['code'] == 200) {
        _favorites = (res.data['data']['records'] as List)
            .map((j) => Job.fromJson(j['job']))
            .toList();
      }
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> removeFavorite(int jobId) async {
    try {
      final res = await _api.dio.delete('/favorites/$jobId');
      if (res.data['code'] == 200) {
        _favorites.removeWhere((j) => j.id == jobId);
        notifyListeners();
        return null;
      }
      return res.data['message'];
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
