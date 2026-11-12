import 'package:flutter/material.dart';

import '../config/dependency_injector.dart';
import 'post_list_screen.dart';
import 'user_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil instance DependencyInjector dari InheritedWidget (DependencyProvider)
    final injector = DependencyProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda RPL & Keamanan'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserListScreen(repository: injector.userRepository),
                  ),
                );
              },
              icon: const Icon(Icons.people),
              label: const Text('Lihat Daftar Pengguna'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PostListScreen(repository: injector.postRepository),
                  ),
                );
              },
              icon: const Icon(Icons.article),
              label: const Text('Lihat Daftar Post'),
            ),
          ],
        ),
      ),
    );
  }
}
