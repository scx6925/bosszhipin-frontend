import 'package:flutter/material.dart';
import '../models/education.dart';
import '../models/work_experience.dart';
import '../services/api_service.dart';

class ResumeProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Education> _educations = [];
  List<WorkExperience> _workExperiences = [];
  bool _isLoading = false;

  List<Education> get educations => _educations;
  List<WorkExperience> get workExperiences => _workExperiences;
  bool get isLoading => _isLoading;

  Future<void> loadEducations() async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _api.dio.get('/user/educations');
      if (res.data['code'] == 200) {
        _educations = (res.data['data'] as List)
            .map((e) => Education.fromJson(e))
            .toList();
      }
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> addEducation(Education edu) async {
    try {
      final res = await _api.dio.post('/user/educations', data: edu.toJson());
      if (res.data['code'] == 200) {
        await loadEducations();
        return null;
      }
      return res.data['message'];
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateEducation(int id, Education edu) async {
    try {
      final res = await _api.dio.put('/user/educations/$id', data: edu.toJson());
      if (res.data['code'] == 200) {
        await loadEducations();
        return null;
      }
      return res.data['message'];
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteEducation(int id) async {
    try {
      final res = await _api.dio.delete('/user/educations/$id');
      if (res.data['code'] == 200) {
        _educations.removeWhere((e) => e.id == id);
        notifyListeners();
        return null;
      }
      return res.data['message'];
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<void> loadWorkExperiences() async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _api.dio.get('/user/work-experiences');
      if (res.data['code'] == 200) {
        _workExperiences = (res.data['data'] as List)
            .map((e) => WorkExperience.fromJson(e))
            .toList();
      }
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> addWorkExperience(WorkExperience we) async {
    try {
      final res =
          await _api.dio.post('/user/work-experiences', data: we.toJson());
      if (res.data['code'] == 200) {
        await loadWorkExperiences();
        return null;
      }
      return res.data['message'];
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateWorkExperience(int id, WorkExperience we) async {
    try {
      final res =
          await _api.dio.put('/user/work-experiences/$id', data: we.toJson());
      if (res.data['code'] == 200) {
        await loadWorkExperiences();
        return null;
      }
      return res.data['message'];
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteWorkExperience(int id) async {
    try {
      final res = await _api.dio.delete('/user/work-experiences/$id');
      if (res.data['code'] == 200) {
        _workExperiences.removeWhere((e) => e.id == id);
        notifyListeners();
        return null;
      }
      return res.data['message'];
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
