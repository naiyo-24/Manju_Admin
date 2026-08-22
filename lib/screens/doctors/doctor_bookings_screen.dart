import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../themes/app_theme.dart';
import '../../widgets/admin_stat_card.dart';
import '../../widgets/neumorphic_card.dart';

class DoctorBookingsScreen extends StatelessWidget {
  const DoctorBookingsScreen({super.key});

  void _showAddDoctorDialog(BuildContext context) {
    Uint8List? selectedImageBytes;
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                      _buildTextField('Doctor Name', Icons.person),
                      const SizedBox(height: 16),
                      _buildTextField('Specialty (e.g. Cardiologist)', Icons.local_hospital),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildTextField('Experience', Icons.work_history)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildTextField('Fee (₹)', Icons.currency_rupee)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField('About Doctor', Icons.info_outline, maxLines: 3),
                      
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
                              // TODO: Handle saving the doctor with selectedImageBytes
                              Navigator.pop(context);
                            },
                            child: const Text('Save Doctor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

  void _showDoctorDetailsDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
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
                  ),
                  child: const Center(
                    child: Icon(Icons.person, size: 60, color: AppTheme.primaryGreen),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Dr. Alan Smith',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Cardiologist',
                    style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDetailStat(Icons.work_history, '12 Years', 'Experience'),
                    _buildDetailStat(Icons.star, '4.8', 'Rating'),
                    _buildDetailStat(Icons.currency_rupee, '800', 'Fee'),
                  ],
                ),
                const SizedBox(height: 32),
                
                // About section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Dr. Alan Smith is a highly experienced cardiologist specializing in treating heart diseases and cardiovascular conditions with a high success rate.',
                  style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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

  Widget _buildTextField(String hint, IconData icon, {int maxLines = 1}) {
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
        maxLines: maxLines,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Bookings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.primaryGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Download CSV',
            onPressed: () {
              // TODO: Implement CSV download
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        onPressed: () => _showAddDoctorDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Doctor'),
      ),
      body: Padding(
        padding: AppTheme.defaultScreenPadding,
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(child: AdminStatCard(title: 'Total Doctors', value: '42', icon: Icons.person)),
                SizedBox(width: 16),
                Expanded(child: AdminStatCard(title: 'Today\'s Appts', value: '18', icon: Icons.calendar_today, iconColor: AppTheme.accentGreen)),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Doctors & Recent Bookings', style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: InkWell(
                      onTap: () => _showDoctorDetailsDialog(context, index),
                      borderRadius: BorderRadius.circular(16),
                      child: NeumorphicCard(
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppTheme.accentGreen,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text('Dr. Alan Smith (Patient ${index + 1})'),
                          subtitle: Text('Today, ${10 + index}:00 AM'),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: index % 2 == 0 ? AppTheme.accentGreen.withValues(alpha: 0.2) : AppTheme.pricePink.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              index % 2 == 0 ? 'Confirmed' : 'Pending',
                              style: TextStyle(
                                color: index % 2 == 0 ? AppTheme.primaryGreen : AppTheme.pricePink,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}


