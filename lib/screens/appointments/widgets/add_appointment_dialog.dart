import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../themes/app_theme.dart';
import '../../../models/appointment.dart';
import '../../../providers/appointment_provider.dart';
import '../../../providers/doctor_provider.dart';
import '../../../widgets/custom_dropdown.dart';

class AddAppointmentDialog extends ConsumerStatefulWidget {
  const AddAppointmentDialog({super.key});

  @override
  ConsumerState<AddAppointmentDialog> createState() => _AddAppointmentDialogState();
}

class _AddAppointmentDialogState extends ConsumerState<AddAppointmentDialog> {
  String? selectedDoctorId;
  DateTime? selectedDate = DateTime.now();
  Uint8List? fileBytes;
  String? fileName;
  String selectedStatus = 'PENDING_CONFIRMATION';
  String? selectedGender;
  
  final nameController = TextEditingController();
  final userIdController = TextEditingController();
  final ageController = TextEditingController();
  final notesController = TextEditingController();

  Widget _buildTextField(String hint, IconData icon, {int maxLines = 1, TextEditingController? controller, TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: AppTheme.shadowInsetDark, offset: Offset(3, 3), blurRadius: 6, spreadRadius: -2),
          BoxShadow(color: Colors.white, offset: Offset(-3, -3), blurRadius: 6, spreadRadius: 1),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 16, right: 12, bottom: maxLines == 1 ? 0 : 48),
            child: Icon(icon, color: AppTheme.primaryGreen.withValues(alpha: 0.8), size: 22),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 48),
          hintText: hint,
          hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.6)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 0, right: 16, top: maxLines == 1 ? 20 : 16, bottom: maxLines == 1 ? 20 : 16),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final doctorsAsync = ref.watch(doctorProvider);

    return Dialog(
      backgroundColor: AppTheme.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
      ),
      elevation: 20,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 550),
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
                          'Schedule a visit and fill patient details.',
                          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Doctor Selection
              CustomDropdown<String>(
                value: selectedDoctorId,
                hint: '--Select Doctor--',
                items: doctorsAsync.maybeWhen(
                  data: (doctors) {
                    return doctors.map((doc) => DropdownMenuItem(
                      value: doc.id,
                      child: Text('Dr. ${doc.name} - ${doc.specialtyKey}'),
                    )).toList();
                  },
                  orElse: () => [],
                ),
                onChanged: (val) => setState(() => selectedDoctorId = val),
              ),
              const SizedBox(height: 16),
              
              // Date Picker & Status
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
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
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                selectedDate == null 
                                    ? 'Date (Optional)' 
                                    : DateFormat('MMM dd, yyyy').format(selectedDate!),
                                style: const TextStyle(fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomDropdown<String>(
                      value: selectedStatus,
                      hint: '--Select Status--',
                      items: const [
                        DropdownMenuItem(value: 'PENDING_CONFIRMATION', child: Text('Pending Confirmation')),
                        DropdownMenuItem(value: 'CONFIRMED', child: Text('Confirmed')),
                        DropdownMenuItem(value: 'COMPLETED', child: Text('Completed')),
                        DropdownMenuItem(value: 'CANCELLED', child: Text('Cancelled')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => selectedStatus = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Patient Details', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
              const SizedBox(height: 12),
              
              // Patient Details
              _buildTextField('Phone Number / User ID (Required)', Icons.phone, controller: userIdController, keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField('Patient Name (Optional)', Icons.person, controller: nameController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Age (Optional)', Icons.cake, controller: ageController, keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomDropdown<String>(
                      value: selectedGender,
                      hint: '--Select Gender--',
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(value: 'Female', child: Text('Female')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (val) => setState(() => selectedGender = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField('Additional Notes (Optional)', Icons.description, maxLines: 3, controller: notesController),
              const SizedBox(height: 16),
              
              // Prescription File Picker
              InkWell(
                onTap: () async {
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
                      if (userIdController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a User ID or Phone Number')));
                        return;
                      }
                      
                      final newAppt = Appointment(
                        id: '',
                        userId: userIdController.text.trim(),
                        doctorId: selectedDoctorId ?? 'unknown_doctor',
                        preferredDate: selectedDate ?? DateTime.now(),
                        status: selectedStatus,
                        formDetails: {
                          'patient_name': nameController.text.trim(),
                          'age': ageController.text.trim(),
                          'gender': selectedGender ?? '',
                          'notes': notesController.text.trim(),
                        },
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
  }
}
