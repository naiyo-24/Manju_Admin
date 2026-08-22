import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.primaryGreen,
      ),
      body: const Center(
        child: Text('Appointments Screen (Placeholder)'),
      ),
    );
  }
}
