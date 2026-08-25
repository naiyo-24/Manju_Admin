import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/admin_stat_card.dart';
import '../../widgets/neumorphic_card.dart';
import '../../providers/doctor_provider.dart';
import '../../providers/lab_booking_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    final doctorsAsync = ref.watch(doctorProvider);
    final labBookingsAsync = ref.watch(labBookingProvider);
    
    final doctorCount = doctorsAsync.value?.length.toString() ?? '0';
    final labBookingCount = labBookingsAsync.value?.length.toString() ?? '0';
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/manju.png',
              height: 48,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.local_pharmacy),
            ),
            const SizedBox(width: 12),
            const Text('Manju Medical Stores & Digital Clinic'),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.primaryGreen,

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppTheme.defaultScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium Greeting Banner
              _buildPremiumBanner(context),
              const SizedBox(height: 32),
              
              // Quick Actions
              Text('Overview', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: AppTheme.primaryGreen)),
              const SizedBox(height: 16),
              
              // Stats Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  return GridView.count(
                    crossAxisCount: isWide ? 2 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isWide ? 4.0 : 1.4,
                    children: [
                      AdminStatCard(title: 'Active Doctors', value: doctorCount, icon: Icons.health_and_safety, iconColor: AppTheme.primaryGreen),
                      AdminStatCard(title: 'Lab Bookings', value: labBookingCount, icon: Icons.science_outlined, iconColor: AppTheme.accentGreen),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Activity', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {}, 
                    child: const Text('View All', style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold))
                  )
                ],
              ),
              const SizedBox(height: 12),
              
              // Activity List with premium styling
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  String doctorSubtitle = 'Waiting for doctors to join';
                  if (doctorsAsync.hasValue && doctorsAsync.value!.isNotEmpty) {
                    final latestDoctor = doctorsAsync.value!.last;
                    doctorSubtitle = 'Dr. ${latestDoctor.name} joined the platform';
                  }

                  String labSubtitle = 'Waiting for completed lab tests';
                  if (labBookingsAsync.hasValue && labBookingsAsync.value!.isNotEmpty) {
                    final completedBookings = labBookingsAsync.value!.where((b) => b.status.toUpperCase() == 'REPORT_READY').toList();
                    if (completedBookings.isNotEmpty) {
                      labSubtitle = 'A lab test report was recently finalized';
                    }
                  }

                  final activities = [
                    {'title': 'New Doctor Registered', 'subtitle': doctorSubtitle, 'icon': Icons.person_add, 'color': AppTheme.primaryGreen},
                    {'title': 'Lab Test Completed', 'subtitle': labSubtitle, 'icon': Icons.check_circle, 'color': AppTheme.primaryGreen},
                  ];
                  final activity = activities[index];
                  final Color iconColor = activity['color'] as Color;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: NeumorphicCard(
                      padding: 12,
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [iconColor.withValues(alpha: 0.2), iconColor.withValues(alpha: 0.05)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: iconColor.withValues(alpha: 0.2), width: 1),
                          ),
                          child: Icon(activity['icon'] as IconData, color: iconColor),
                        ),
                        title: Text(activity['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(activity['subtitle'] as String, style: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.8), fontSize: 13)),
                        ),
                        trailing: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Just now', style: TextStyle(fontSize: 12, color: AppTheme.accentGreen, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning, Admin! ☀️';
    } else if (hour < 17) {
      return 'Good Afternoon, Admin! 🌤️';
    } else {
      return 'Good Evening, Admin! 🌙';
    }
  }

  Widget _buildPremiumBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.promoGradientStart, AppTheme.promoGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.promoGradientEnd.withValues(alpha: 0.4),
            offset: const Offset(0, 10),
            blurRadius: 20,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background decorative elements
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -50,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Your medical ecosystem is running smoothly.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.promoGradientEnd,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {},
                icon: const Icon(Icons.flash_on),
                label: const Text('Generate Daily Report', style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
