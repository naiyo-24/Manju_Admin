import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../themes/app_theme.dart';
import '../../../models/doctor.dart';
import '../../../providers/doctor_provider.dart';

class AddDoctorDialog extends ConsumerStatefulWidget {
  const AddDoctorDialog({super.key});

  @override
  ConsumerState<AddDoctorDialog> createState() => _AddDoctorDialogState();
}

class _AddDoctorDialogState extends ConsumerState<AddDoctorDialog> {
  Uint8List? selectedImageBytes;
  final ImagePicker picker = ImagePicker();
  
  final nameController = TextEditingController();
  final specialtyController = TextEditingController();
  final experienceController = TextEditingController();
  final feeController = TextEditingController();
  final aboutController = TextEditingController();
  bool _isLoading = false;

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
        style: const TextStyle(fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 16, right: 12, bottom: maxLines == 1 ? 0 : 48),
            child: Icon(icon, color: AppTheme.primaryGreen.withValues(alpha: 0.8), size: 22),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 48),
          hintText: hint,
          hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.6), fontWeight: FontWeight.normal),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 0, right: 16, top: maxLines == 1 ? 20 : 16, bottom: maxLines == 1 ? 20 : 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
      ),
      elevation: 20,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Premium Header
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
                    child: const Icon(Icons.person_add_alt_1, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Doctor',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen, letterSpacing: -0.5),
                        ),
                        Text(
                          'Enter details to register a new physician.',
                          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Profile Picture Upload
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.3), width: 2),
                        boxShadow: const [
                          BoxShadow(color: AppTheme.shadowInsetDark, offset: Offset(2, 2), blurRadius: 6),
                        ],
                        image: selectedImageBytes != null
                            ? DecorationImage(
                                image: MemoryImage(selectedImageBytes!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: selectedImageBytes == null
                          ? Icon(Icons.person, size: 50, color: AppTheme.textSecondary.withValues(alpha: 0.3))
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () async {
                          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            final bytes = await image.readAsBytes();
                            setState(() {
                              selectedImageBytes = bytes;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Fields
              _buildTextField('Doctor Name', Icons.person, controller: nameController),
              const SizedBox(height: 16),
              _buildTextField('Specialty (e.g. Cardiologist)', Icons.local_hospital, controller: specialtyController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Experience', Icons.work_history, controller: experienceController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Fee (₹)', Icons.currency_rupee, controller: feeController, keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField('About Doctor', Icons.info_outline, maxLines: 3, controller: aboutController),
              
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
                    onPressed: _isLoading ? null : () async {
                      final name = nameController.text.trim();
                      if (name.isEmpty) return; // Basic validation
                      
                      setState(() => _isLoading = true);
                      try {
                        final newDoc = Doctor(
                          id: '', // Will be generated by notifier if empty
                          name: name,
                          specialtyKey: specialtyController.text.trim(),
                          experience: experienceController.text.trim(),
                          fee: double.tryParse(feeController.text.trim()) ?? 0.0,
                          about: aboutController.text.trim(),
                          profilePicture: selectedImageBytes,
                        );
                        
                        await ref.read(doctorProvider.notifier).addDoctor(newDoc);
                        if (context.mounted) Navigator.pop(context);
                      } finally {
                        if (context.mounted) setState(() => _isLoading = false);
                      }
                    },
                    child: _isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Save Doctor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
