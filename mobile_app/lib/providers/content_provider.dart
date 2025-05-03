import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/content.dart';

class ContentProvider with ChangeNotifier {
  List<Content> _feed = [];
  bool _isLoading = false;
  final String _baseUrl = 'http://localhost:5000/api/content';
  
  // Test mode flag to match auth provider
  final bool _testMode = true;

  List<Content> get feed => _feed;
  bool get isLoading => _isLoading;

  Future<void> fetchFeed() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_testMode) {
        // Create test content for development
        _feed = [
          Content(
            id: 'test-1',
            title: 'Introduction to Mathematics',
            content: 'Mathematics is the science of patterns. Learn about numbers, shapes, and logical relationships in this engaging introduction.',
            topic: 'math',
            difficulty: 'Beginner',
            authorId: 'test-123',
            authorUsername: 'Test User',
            likes: ['user1', 'user2', 'user3'],
            comments: [],
            tags: ['math', 'basics', 'numbers'],
            readingTime: 180,
            createdAt: DateTime.now(),
          ),
          Content(
            id: 'test-2',
            title: 'Basic Physics Concepts',
            content: 'Discover the fundamental laws that govern our universe. From motion to energy, explore the building blocks of physics.',
            topic: 'science',
            difficulty: 'Intermediate',
            authorId: 'test-123',
            authorUsername: 'Test User',
            likes: ['user1', 'user4'],
            comments: [],
            tags: ['physics', 'science', 'motion'],
            readingTime: 240,
            createdAt: DateTime.now(),
          ),
          Content(
            id: 'test-3',
            title: 'Ancient Civilizations',
            content: 'Journey through time to explore the great civilizations of the past. Learn about their cultures, achievements, and lasting impact.',
            topic: 'history',
            difficulty: 'Advanced',
            authorId: 'test-123',
            authorUsername: 'Test User',
            likes: ['user2', 'user3', 'user5'],
            comments: [],
            tags: ['history', 'civilization', 'culture'],
            readingTime: 300,
            createdAt: DateTime.now(),
          ),
        ];
        _isLoading = false;
        notifyListeners();
        return;
      }

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
      if (_testMode) {
        final contentIndex = _feed.indexWhere((c) => c.id == contentId);
        if (contentIndex != -1) {
          final currentContent = _feed[contentIndex];
          _feed[contentIndex] = Content(
            id: currentContent.id,
            title: currentContent.title,
            content: currentContent.content,
            topic: currentContent.topic,
            difficulty: currentContent.difficulty,
            authorId: currentContent.authorId,
            authorUsername: currentContent.authorUsername,
            likes: [...currentContent.likes, 'test-123'],
            comments: currentContent.comments,
            tags: currentContent.tags,
            readingTime: currentContent.readingTime,
            createdAt: currentContent.createdAt,
          );
          notifyListeners();
        }
        return;
      }

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
      if (_testMode) {
        final contentIndex = _feed.indexWhere((c) => c.id == contentId);
        if (contentIndex != -1) {
          final currentContent = _feed[contentIndex];
          final newComment = Comment(
            id: DateTime.now().toString(),
            userId: 'test-123',
            text: text,
            createdAt: DateTime.now(),
          );
          
          _feed[contentIndex] = Content(
            id: currentContent.id,
            title: currentContent.title,
            content: currentContent.content,
            topic: currentContent.topic,
            difficulty: currentContent.difficulty,
            authorId: currentContent.authorId,
            authorUsername: currentContent.authorUsername,
            likes: currentContent.likes,
            comments: [...currentContent.comments, newComment],
            tags: currentContent.tags,
            readingTime: currentContent.readingTime,
            createdAt: currentContent.createdAt,
          );
          notifyListeners();
        }
        return;
      }

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
      if (_testMode) {
        return _feed.where((content) => content.topic == topic).toList();
      }

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