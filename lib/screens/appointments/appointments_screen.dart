import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../themes/app_theme.dart';
import '../../widgets/admin_stat_card.dart';
import '../../widgets/neumorphic_card.dart';
import '../../models/doctor.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/doctor_provider.dart';
import 'widgets/add_appointment_dialog.dart';
import 'widgets/appointment_details_dialog.dart';

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apptsAsync = ref.watch(appointmentProvider);
    final doctorsAsync = ref.watch(doctorProvider);

    final List<Doctor> doctorsList = doctorsAsync.maybeWhen(
      data: (docs) => docs,
      orElse: () => [],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
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
            builder: (ctx) => const AddAppointmentDialog(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Book Appointment'),
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
                    value: apptsAsync.maybeWhen(
                      data: (appts) => appts.length.toString(),
                      orElse: () => '...',
                    ), 
                    icon: Icons.calendar_month
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AdminStatCard(
                    title: 'Completed', 
                    value: apptsAsync.maybeWhen(
                      data: (appts) => appts.where((a) => a.status == 'COMPLETED').length.toString(),
                      orElse: () => '...',
                    ), 
                    icon: Icons.check_circle, 
                    iconColor: AppTheme.accentGreen
                  )
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Recent Bookings', style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: apptsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)),
                error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
                data: (appts) {
                  if (appts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_month_outlined, size: 80, color: AppTheme.textSecondary.withValues(alpha: 0.3)),
                          const SizedBox(height: 16),
                          const Text('No appointments booked yet.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: appts.length,
                    itemBuilder: (context, index) {
                      final appt = appts[index];
                      // Find doctor info
                      final doctor = doctorsList.where((d) => d.id == appt.doctorId).firstOrNull;
                      final doctorName = doctor != null ? 'Dr. ${doctor.name}' : 'Unknown Doctor';
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AppointmentDetailsDialog(appt: appt, doctors: doctorsList),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: NeumorphicCard(
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: AppTheme.accentGreen,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              title: Text(
                                doctorName,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                              ),
                              subtitle: Text(DateFormat('MMM dd, yyyy').format(appt.preferredDate)),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: appt.status == 'COMPLETED' 
                                      ? AppTheme.accentGreen.withValues(alpha: 0.2) 
                                      : AppTheme.pricePink.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  appt.status.toUpperCase(),
                                  style: TextStyle(
                                    color: appt.status == 'COMPLETED' ? AppTheme.primaryGreen : AppTheme.pricePink,
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
