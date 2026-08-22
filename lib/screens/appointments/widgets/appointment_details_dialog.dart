import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../themes/app_theme.dart';
import '../../../models/appointment.dart';
import '../../../models/doctor.dart';
import '../../../providers/appointment_provider.dart';

class AppointmentDetailsDialog extends ConsumerWidget {
  final Appointment appt;
  final List<Doctor> doctors;

  const AppointmentDetailsDialog({
    super.key,
    required this.appt,
    required this.doctors,
  });

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.accentGreen, size: 20),
        const SizedBox(width: 12),
        Text('$label:', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary))),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctor = doctors.where((d) => d.id == appt.doctorId).firstOrNull;
    final patientName = (appt.formDetails?['patient_name']?.toString().isNotEmpty ?? false) 
        ? appt.formDetails!['patient_name']
        : 'Not Specified';
    final age = (appt.formDetails?['age']?.toString().isNotEmpty ?? false)
        ? appt.formDetails!['age']
        : 'N/A';
    final gender = (appt.formDetails?['gender']?.toString().isNotEmpty ?? false)
        ? appt.formDetails!['gender']
        : 'N/A';
    final notes = (appt.formDetails?['notes']?.toString().isNotEmpty ?? false)
        ? appt.formDetails!['notes']
        : 'None';
    
    return Dialog(
      backgroundColor: AppTheme.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Appointment Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen)),
            const SizedBox(height: 24),
            
            _buildInfoRow(Icons.person, 'Doctor', doctor != null ? 'Dr. ${doctor.name}' : 'Not Specified'),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.calendar_today, 'Date', DateFormat('MMM dd, yyyy').format(appt.preferredDate)),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.info_outline, 'Status', appt.status.toUpperCase()),
            const SizedBox(height: 24),
            
            const Text('Patient Info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryGreen)),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.personal_injury, 'Patient', patientName),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.cake, 'Age/Gender', '$age / $gender'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.description, 'Notes', notes),

            if (appt.prescriptionFileName != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentGreen),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.file_present, color: AppTheme.primaryGreen),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Attached: ${appt.prescriptionFileName}', style: const TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              )
            ],
            
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.pricePink,
                      side: const BorderSide(color: AppTheme.pricePink),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Appointment?', style: TextStyle(color: AppTheme.primaryGreen)),
                          content: const Text('Are you sure you want to delete this appointment? This action cannot be undone.', style: TextStyle(color: AppTheme.textPrimary)),
                          backgroundColor: AppTheme.backgroundColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('No', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.pricePink,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                ref.read(appointmentProvider.notifier).deleteAppointment(appt.id);
                                Navigator.pop(ctx);
                                Navigator.pop(context);
                              },
                              child: const Text('Yes, Delete', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
