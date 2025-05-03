import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/content.dart';

class ContentProvider with ChangeNotifier {
  List<Content> _feed = [];
  bool _isLoading = false;
  final String _baseUrl = 'http://localhost:5000/api/content';

  List<Content> get feed => _feed;
  bool get isLoading => _isLoading;

  Future<void> fetchFeed() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.get(
        Uri.parse('$_baseUrl/feed'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token ?? '',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _feed = data.map((item) => Content.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to fetch feed');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> likeContent(String contentId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.post(
        Uri.parse('$_baseUrl/$contentId/like'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token ?? '',
        },
      );

      if (response.statusCode == 200) {
        // Update the feed with the new like status
        await fetchFeed();
      } else {
        throw Exception('Failed to like content');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addComment(String contentId, String text) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.post(
        Uri.parse('$_baseUrl/$contentId/comments'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token ?? '',
        },
        body: json.encode({'text': text}),
      );

      if (response.statusCode == 200) {
        // Update the feed with the new comment
        await fetchFeed();
      } else {
        throw Exception('Failed to add comment');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Content>> getContentByTopic(String topic) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/topic/$topic'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Content.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch topic content');
      }
    } catch (e) {
      rethrow;
    }
  }
} 