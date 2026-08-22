import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../themes/app_theme.dart';
import '../../../models/doctor.dart';
import '../../../providers/doctor_provider.dart';

class DoctorDetailsDialog extends ConsumerWidget {
  final Doctor doctor;
  final int bookingsCount;

  const DoctorDetailsDialog({
    super.key,
    required this.doctor,
    required this.bookingsCount,
  });

  Widget _buildDetailStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.accentGreen, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: AppTheme.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Image
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppTheme.primaryGreen.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10)),
                ],
                border: Border.all(color: AppTheme.accentGreen, width: 3),
                image: doctor.profilePicture != null
                    ? DecorationImage(
                        image: MemoryImage(doctor.profilePicture!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: doctor.profilePicture == null
                  ? const Center(child: Icon(Icons.person, size: 60, color: AppTheme.primaryGreen))
                  : null,
            ),
            const SizedBox(height: 24),
            Text(
              doctor.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            if (doctor.specialtyKey.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  doctor.specialtyKey,
                  style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            const SizedBox(height: 32),
            
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDetailStat(Icons.work_history, doctor.experience.isNotEmpty ? doctor.experience : 'N/A', 'Experience'),
                _buildDetailStat(Icons.calendar_month, bookingsCount.toString(), 'Bookings'),
                _buildDetailStat(Icons.currency_rupee, doctor.fee.toStringAsFixed(0), 'Fee'),
              ],
            ),
            const SizedBox(height: 32),
            
            // About section
            if (doctor.about.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(height: 8),
              Text(
                doctor.about,
                style: const TextStyle(color: AppTheme.textSecondary, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 32),
            ],
            
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
                          title: const Text('Delete Doctor?', style: TextStyle(color: AppTheme.primaryGreen)),
                          content: const Text('Are you sure you want to delete this doctor? This action cannot be undone.', style: TextStyle(color: AppTheme.textPrimary)),
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
                                ref.read(doctorProvider.notifier).deleteDoctor(doctor.id);
                                Navigator.pop(ctx); // close confirmation
                                Navigator.pop(context); // close details
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
                    child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
