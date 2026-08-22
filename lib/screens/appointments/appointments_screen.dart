import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../themes/app_theme.dart';
import '../../widgets/admin_stat_card.dart';
import '../../widgets/neumorphic_card.dart';
import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/doctor_provider.dart';

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  void _showAddAppointmentDialog(BuildContext context, WidgetRef ref) {
    String? selectedDoctorId;
    DateTime? selectedDate = DateTime.now();
    Uint8List? fileBytes;
    String? fileName;
    
    final detailsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final doctorsAsync = ref.watch(doctorProvider);
            
            return Dialog(
              backgroundColor: AppTheme.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
              ),
              elevation: 20,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppTheme.promoGradientStart, AppTheme.promoGradientEnd],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: AppTheme.promoGradientEnd.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
                              ],
                            ),
                            child: const Icon(Icons.calendar_month, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Book Appointment',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen, letterSpacing: -0.5),
                                ),
                                Text(
                                  'Schedule a visit and upload prescription.',
                                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Doctor Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(color: AppTheme.shadowInsetDark, offset: Offset(3, 3), blurRadius: 6, spreadRadius: -2),
                            BoxShadow(color: Colors.white, offset: Offset(-3, -3), blurRadius: 6, spreadRadius: 1),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text('Select Doctor (Optional)', style: TextStyle(color: AppTheme.textSecondary)),
                            value: selectedDoctorId,
                            items: doctorsAsync.maybeWhen(
                              data: (doctors) {
                                return doctors.map((doc) => DropdownMenuItem(
                                  value: doc.id,
                                  child: Text('Dr. ${doc.name} - ${doc.specialtyKey}'),
                                )).toList();
                              },
                              orElse: () => [],
                            ),
                            onChanged: (val) {
                              setState(() {
                                selectedDoctorId = val;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Date Picker
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppTheme.primaryGreen,
                                    onPrimary: Colors.white,
                                    onSurface: AppTheme.textPrimary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) {
                            setState(() {
                              selectedDate = date;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(color: AppTheme.shadowInsetDark, offset: Offset(3, 3), blurRadius: 6, spreadRadius: -2),
                              BoxShadow(color: Colors.white, offset: Offset(-3, -3), blurRadius: 6, spreadRadius: 1),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: AppTheme.primaryGreen.withValues(alpha: 0.8)),
                              const SizedBox(width: 16),
                              Text(
                                selectedDate == null 
                                    ? 'Select Date (Optional)' 
                                    : DateFormat('MMM dd, yyyy').format(selectedDate!),
                                style: const TextStyle(fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Form Details
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(color: AppTheme.shadowInsetDark, offset: Offset(3, 3), blurRadius: 6, spreadRadius: -2),
                            BoxShadow(color: Colors.white, offset: Offset(-3, -3), blurRadius: 6, spreadRadius: 1),
                          ],
                        ),
                        child: TextField(
                          controller: detailsController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 16, right: 12, bottom: 48),
                              child: Icon(Icons.description, color: AppTheme.primaryGreen.withValues(alpha: 0.8), size: 22),
                            ),
                            prefixIconConstraints: const BoxConstraints(minWidth: 48),
                            hintText: 'Patient notes or form details (Optional)',
                            hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.6)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Prescription File Picker
                      InkWell(
                        onTap: () async {
                          // Allow image or PDF
                          PlatformFile? result = await FilePicker.pickFile(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                          );

                          if (result != null) {
                            final bytes = await result.readAsBytes();
                            setState(() {
                              fileBytes = bytes;
                              fileName = result.name;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.accentGreen.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.upload_file, color: AppTheme.primaryGreen),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  fileName ?? 'Upload Prescription (Image/PDF)',
                                  style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (fileName != null)
                                IconButton(
                                  icon: const Icon(Icons.close, color: AppTheme.pricePink, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      fileBytes = null;
                                      fileName = null;
                                    });
                                  },
                                )
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              elevation: 8,
                              shadowColor: AppTheme.primaryGreen.withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () {
                              final newAppt = Appointment(
                                id: '',
                                userId: 'dummy_user_id', // No user module yet
                                doctorId: selectedDoctorId ?? 'unknown_doctor',
                                preferredDate: selectedDate ?? DateTime.now(),
                                status: fileName != null ? 'COMPLETED' : 'pending',
                                formDetails: {'notes': detailsController.text},
                                prescriptionBytes: fileBytes,
                                prescriptionFileName: fileName,
                              );
                              
                              ref.read(appointmentProvider.notifier).addAppointment(newAppt);
                              Navigator.pop(context);
                            },
                            child: const Text('Save Booking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAppointmentDetails(BuildContext context, WidgetRef ref, Appointment appt, List<Doctor> doctors) {
    final doctor = doctors.where((d) => d.id == appt.doctorId).firstOrNull;
    
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppTheme.backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
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
                          ref.read(appointmentProvider.notifier).deleteAppointment(appt.id);
                          Navigator.pop(context);
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
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
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
        onPressed: () => _showAddAppointmentDialog(context, ref),
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
                          onTap: () => _showAppointmentDetails(context, ref, appt, doctorsList),
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
