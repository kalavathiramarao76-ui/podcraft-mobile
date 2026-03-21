import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  bool _onboardingComplete = false;
  bool _isLoading = false;
  String _generatedContent = '';
  List<Map<String, String>> _savedContent = [];
  String _podcastName = '';
  String _hostName = '';

  bool get onboardingComplete => _onboardingComplete;
  bool get isLoading => _isLoading;
  String get generatedContent => _generatedContent;
  List<Map<String, String>> get savedContent => _savedContent;
  String get podcastName => _podcastName;
  String get hostName => _hostName;

  AppProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    _podcastName = prefs.getString('podcast_name') ?? '';
    _hostName = prefs.getString('host_name') ?? '';
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    _onboardingComplete = true;
    notifyListeners();
  }

  Future<void> updateProfile(String podcast, String host) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('podcast_name', podcast);
    await prefs.setString('host_name', host);
    _podcastName = podcast;
    _hostName = host;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setGeneratedContent(String content) {
    _generatedContent = content;
    notifyListeners();
  }

  void addContent(String type, String title, String content) {
    _savedContent.insert(0, {
      'type': type,
      'title': title,
      'content': content,
      'date': DateTime.now().toIso8601String(),
    });
    notifyListeners();
  }
}
