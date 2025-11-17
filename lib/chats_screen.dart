
import 'dart:convert';
import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  final String jsonData = '''{
    "posts": [
      {
        "id": 1,
        "title": "Introduction to Flutter",
        "author": "John Doe",
        "content": "Flutter is a popular open-source framework by Google for building beautiful, natively compiled, multi-platform applications from a single codebase.",
        "published_date": "2023-01-15"
      },
      {
        "id": 2,
        "title": "State Management in Flutter",
        "author": "Jane Smith",
        "content": "This post explores various state management techniques in Flutter, such as Provider, BLoC, and Riverpod.",
        "published_date": "2023-02-10"
      },
      {
        "id": 3,
        "title": "Flutter Widgets Deep Dive",
        "author": "Sam Wilson",
        "content": "A comprehensive guide to understanding and using Flutter widgets effectively.",
        "published_date": "2023-03-20"
      }
    ]
  }''';

  @override
  Widget build(BuildContext context) {
    final data = json.decode(jsonData);
    final posts = data['posts'] as List;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Posts'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return ListTile(
            title: Text(post['title']),
            subtitle: Text('by ${post['author']}'),
          );
        },
      ),
    );
  }
}
