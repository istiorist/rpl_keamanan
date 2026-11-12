import 'package:flutter/material.dart';

import '../repositories/post_repository.dart';
import '../repositories/post_repository_impl.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../services/api_service.dart';

/// Kelas DependencyInjector untuk mengelola dan menyediakan instance
/// [ApiService], [UserRepository], dan [PostRepository] secara terpusat.
class DependencyInjector {
  // Singleton instance untuk DependencyInjector
  static final DependencyInjector _instance = DependencyInjector._internal();

  factory DependencyInjector() {
    return _instance;
  }

  // Instance tunggal (singleton) untuk ApiService dan Repository
  late final ApiService apiService;
  late final UserRepository userRepository;
  late final PostRepository postRepository;

  DependencyInjector._internal() {
    apiService = ApiService();
    userRepository = UserRepositoryImpl(apiService: apiService);
    postRepository = PostRepositoryImpl(apiService: apiService);
  }

  /// Menutup resource yang digunakan oleh service dan repository.
  void dispose() {
    apiService.dispose();
  }
}

/// InheritedWidget untuk menyuntikkan [DependencyInjector] ke dalam widget tree.
class DependencyProvider extends InheritedWidget {
  final DependencyInjector injector;

  const DependencyProvider({
    super.key,
    required this.injector,
    required super.child,
  });

  /// Mengambil instance [DependencyInjector] dari [BuildContext].
  static DependencyInjector of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<DependencyProvider>();
    assert(
      provider != null,
      'DependencyProvider tidak ditemukan di widget tree',
    );
    return provider!.injector;
  }

  @override
  bool updateShouldNotify(DependencyProvider oldWidget) {
    return injector != oldWidget.injector;
  }
}
