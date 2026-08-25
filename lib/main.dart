import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/app_router.dart';
import 'themes/app_theme.dart';

import 'services/api_client.dart';

void main() {
  ApiClient().initialize(); // Initialize network clients
  runApp(const ProviderScope(child: ManjuAdminApp()));
}

class ManjuAdminApp extends ConsumerWidget {
  const ManjuAdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Manju Medical Admin',
      theme: AppTheme.themeData,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
