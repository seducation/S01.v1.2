import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  Client client = Client();
  late Account account;
  late Databases databases;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> init() async {
    client
        .setEndpoint('https://sgp.cloud.appwrite.io/v1') // Your Appwrite Endpoint
        .setProject('691948bf001eb3eccd77'); // Your project ID
    account = Account(client);
    databases = Databases(client);
    await checkUser();
  }

  Future<void> createPost(Map<String, dynamic> postData) async {
    try {
      final user = await account.get();
      const databaseId = '691963ed003c37eb797f';
      const collectionId = 'post';
      
      // Add creator and other fields to the postData
      postData['creator'] = user.$id;
      postData['imageurl'] = ''; // Placeholder
      postData['imageid'] = ''; // Placeholder
      postData['likes'] = []; // Placeholder
      postData['saves'] = []; // Placeholder

      await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: ID.unique(),
        data: postData,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      final newUser = await account.create(
        userId: ID.unique(),
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
          'username': name, // Using name as username
          'accountid': newUser.$id,
          'emailid': email,
          'bio': '',
          'imageid': '',
          'imageurl': ''
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
      _isLoggedIn = true;
      notifyListeners();
      return session;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await account.deleteSession(sessionId: 'current');
      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkUser() async {
    try {
      await account.get();
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoggedIn = false;
      notifyListeners();
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