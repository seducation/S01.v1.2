import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  Client client = Client();
  late Account account;
  late Databases databases;

  AuthService() {
    client
        .setEndpoint('https://sgp.cloud.appwrite.io/v1') // Your Appwrite Endpoint
        .setProject('691948bf001eb3eccd77') // Your project ID
        .setSelfSigned(status: true);
    account = Account(client);
    databases = Databases(client);
  }

  Future<void> createPost(String content) async {
    try {
      final user = await account.get();
      const databaseId = '691963ed003c37eb797f';
      const collectionId = 'posts';
      await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: 'unique()',
        data: {
          'content': content,
          'userId': user.$id,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      final newUser = await account.create(
        userId: 'unique()',
        email: email,
        password: password,
        name: name,
      );
      const databaseId = '691963ed003c37eb797f';
      const collectionId = 'users';
      await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: newUser.$id,
        data: {
          'name': name,
          'email': email,
        },
      );
      await signIn(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<models.Session> signIn(String email, String password) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      notifyListeners();
      return session;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await account.deleteSession(sessionId: 'current');
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkUser() async {
    try {
      await account.get();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final user = await account.get();
      return User(name: user.name, email: user.email);
    } catch (e) {
      return null;
    }
  }
}

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});
}