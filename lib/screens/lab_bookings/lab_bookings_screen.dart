import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../themes/app_theme.dart';
import '../../widgets/admin_stat_card.dart';
import '../../widgets/neumorphic_card.dart';
import '../../providers/lab_booking_provider.dart';
import 'widgets/add_lab_booking_dialog.dart';
import 'widgets/lab_booking_details_dialog.dart';

class LabBookingsScreen extends ConsumerWidget {
  const LabBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labBookingsAsync = ref.watch(labBookingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Bookings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.primaryGreen,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => const AddLabBookingDialog(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Mock Booking'),
      ),
      body: Padding(
        padding: AppTheme.defaultScreenPadding,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AdminStatCard(
                    title: 'Total Bookings', 
                    value: labBookingsAsync.maybeWhen(
                      data: (bookings) => bookings.length.toString(),
                      orElse: () => '...',
                    ), 
                    icon: Icons.science
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AdminStatCard(
                    title: 'Reports Ready', 
                    value: labBookingsAsync.maybeWhen(
                      data: (bookings) => bookings.where((b) => b.status.toUpperCase() == 'REPORT_READY').length.toString(),
                      orElse: () => '...',
                    ), 
                    icon: Icons.assignment_turned_in, 
                    iconColor: AppTheme.accentGreen
                  )
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Recent Lab Bookings', style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: labBookingsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)),
                error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
                data: (bookings) {
                  if (bookings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.biotech, size: 80, color: AppTheme.textSecondary.withValues(alpha: 0.3)),
                          const SizedBox(height: 16),
                          const Text('No lab bookings yet.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      final patientName = (booking.formDetails?['patient_name']?.toString().isNotEmpty ?? false) 
                          ? booking.formDetails!['patient_name']
                          : 'Unknown Patient';
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => LabBookingDetailsDialog(booking: booking),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: NeumorphicCard(
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: AppTheme.accentGreen,
                                child: Icon(Icons.science, color: Colors.white),
                              ),
                              title: Text(
                                patientName,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                              ),
                              subtitle: Text(DateFormat('MMM dd, yyyy').format(booking.preferredDate)),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: booking.status.toUpperCase() == 'REPORT_READY' 
                                      ? AppTheme.accentGreen.withValues(alpha: 0.2) 
                                      : (booking.status.toUpperCase() == 'SAMPLE_COLLECTED' 
                                          ? Colors.blue.withValues(alpha: 0.2)
                                          : AppTheme.pricePink.withValues(alpha: 0.2)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  booking.status.replaceAll('_', ' ').toUpperCase(),
                                  style: TextStyle(
                                    color: booking.status.toUpperCase() == 'REPORT_READY' 
                                        ? AppTheme.primaryGreen 
                                        : (booking.status.toUpperCase() == 'SAMPLE_COLLECTED' 
                                            ? Colors.blue[700]
                                            : AppTheme.pricePink),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
