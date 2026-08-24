import 'dart:convert';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/admin_stat_card.dart';
import '../../widgets/neumorphic_card.dart';
import '../../providers/doctor_provider.dart';
import '../../providers/appointment_provider.dart';
import 'widgets/add_doctor_dialog.dart';
import 'widgets/doctor_details_dialog.dart';

class DoctorBookingsScreen extends ConsumerWidget {
  const DoctorBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorsAsync = ref.watch(doctorProvider);
    final appointmentsAsync = ref.watch(appointmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Management'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.primaryGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Download CSV',
            onPressed: () async {
              if (!doctorsAsync.hasValue) return;

              final doctors = doctorsAsync.value!;
              final List<List<dynamic>> csvData = [
                ['ID', 'Name', 'Specialty', 'Experience', 'Fee', 'About'],
                ...doctors.map((d) => [
                  d.id,
                  d.name,
                  d.specialtyKey,
                  d.experience,
                  d.fee,
                  d.about,
                ]),
              ];

              final String csvString = Csv().encode(csvData);
              final Uint8List bytes = utf8.encoder.convert(csvString);

              try {
                await FilePicker.saveFile(
                  fileName: 'doctors_list.csv',
                  bytes: bytes,
                  type: FileType.custom,
                  allowedExtensions: ['csv'],
                );

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('CSV download complete')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error downloading CSV: $e')),
                  );
                }
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => const AddDoctorDialog(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Doctor'),
      ),
      body: Padding(
        padding: AppTheme.defaultScreenPadding,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AdminStatCard(
                    title: 'Total Doctors', 
                    value: doctorsAsync.maybeWhen(
                      data: (docs) => docs.length.toString(),
                      orElse: () => '...',
                    ), 
                    icon: Icons.person
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AdminStatCard(
                    title: 'Total Appointments', 
                    value: appointmentsAsync.maybeWhen(
                      data: (appts) => appts.length.toString(),
                      orElse: () => '0',
                    ),
                    icon: Icons.calendar_today, 
                    iconColor: AppTheme.accentGreen
                  )
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Registered Doctors', style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: doctorsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)),
                error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
                data: (doctors) {
                  if (doctors.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people_outline, size: 80, color: AppTheme.textSecondary.withValues(alpha: 0.3)),
                          const SizedBox(height: 16),
                          const Text('No doctors registered yet.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      final doctorBookings = appointmentsAsync.maybeWhen(
                        data: (appts) => appts.where((a) => a.doctorId == doctor.id).length,
                        orElse: () => 0,
                      );
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => DoctorDetailsDialog(
                                doctor: doctor,
                                bookingsCount: doctorBookings,
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: NeumorphicCard(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppTheme.accentGreen,
                                backgroundImage: doctor.profilePicture != null 
                                    ? MemoryImage(doctor.profilePicture!) 
                                    : null,
                                child: doctor.profilePicture == null 
                                    ? const Icon(Icons.person, color: Colors.white)
                                    : null,
                              ),
                              title: Text(
                                doctor.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                              ),
                              subtitle: Text(doctor.specialtyKey.isNotEmpty ? doctor.specialtyKey : 'General Physician'),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '₹${doctor.fee.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: AppTheme.primaryGreen,
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
