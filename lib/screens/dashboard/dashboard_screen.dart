import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import '../../widgets/admin_stat_card.dart';
import '../../widgets/neumorphic_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                    crossAxisCount: isWide ? 4 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isWide ? 2.5 : 1.4,
                    children: const [
                      AdminStatCard(title: 'Active Doctors', value: '42', icon: Icons.health_and_safety, iconColor: AppTheme.primaryGreen),
                      AdminStatCard(title: 'Pending Meds', value: '12', icon: Icons.medication, iconColor: AppTheme.pricePink),
                      AdminStatCard(title: 'Lab Tests', value: '23', icon: Icons.biotech, iconColor: AppTheme.accentGreen),
                      AdminStatCard(title: 'Total Revenue', value: '₹ 12.5k', icon: Icons.account_balance_wallet, iconColor: AppTheme.primaryGreen),
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
                itemCount: 4,
                itemBuilder: (context, index) {
                  final activities = [
                    {'title': 'New Doctor Registered', 'subtitle': 'Dr. Alan Smith joined the platform', 'icon': Icons.person_add, 'color': AppTheme.primaryGreen},
                    {'title': 'Medicine Order Dispatched', 'subtitle': 'Order #MMD-004 is on the way', 'icon': Icons.local_shipping, 'color': AppTheme.accentGreen},
                    {'title': 'Lab Test Completed', 'subtitle': 'CBC test results uploaded for John Doe', 'icon': Icons.check_circle, 'color': AppTheme.primaryGreen},
                    {'title': 'Payment Failed', 'subtitle': 'Order #MMD-002 payment declined', 'icon': Icons.error, 'color': AppTheme.pricePink},
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
              const Text(
                'Good Morning, Admin! ☀️',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5),
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
