import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: FutureBuilder<User?>(
        future: authService.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/signin');
            });
            return const Center(child: Text('Redirecting to sign in...'));
          }

          final user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${user.name}', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Email: ${user.email}', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    await authService.signOut();
                    if (context.mounted) {
                      context.go('/signin');
                    }
                  },
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
