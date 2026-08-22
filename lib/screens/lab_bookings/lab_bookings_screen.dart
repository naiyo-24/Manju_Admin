import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class LabBookingsScreen extends StatelessWidget {
  const LabBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Lab Bookings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.primaryGreen,
      ),
      body: const Center(
        child: Text('Lab Bookings Screen (Placeholder)'),
      ),
    );
  }
}
