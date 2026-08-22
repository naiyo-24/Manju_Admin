import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../themes/app_theme.dart';
import '../../widgets/admin_stat_card.dart';
import '../../widgets/neumorphic_card.dart';

class LabTestsScreen extends StatelessWidget {
  const LabTestsScreen({super.key});

  void _showAddTestDialog(BuildContext context, bool isPackage) {
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
                              gradient: LinearGradient(
                                colors: isPackage 
                                  ? [AppTheme.promoGradientStart, AppTheme.promoGradientEnd]
                                  : [AppTheme.accentGreen, AppTheme.primaryGreen],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: AppTheme.primaryGreen.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
                              ],
                            ),
                            child: Icon(isPackage ? Icons.medical_services : Icons.science, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isPackage ? 'Add Test Package' : 'Add Single Test',
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen, letterSpacing: -0.5),
                                ),
                                Text(
                                  isPackage ? 'Create a bundle of multiple lab tests.' : 'Add a new individual lab test.',
                                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Image Upload Placeholder
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
                                  ? Icon(Icons.image, size: 40, color: AppTheme.textSecondary.withValues(alpha: 0.3))
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
                                    color: isPackage ? AppTheme.promoGradientStart : AppTheme.accentGreen,
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
                      
                      // Fields based on LabCatalog Schema
                      _buildTextField(isPackage ? 'Package Title' : 'Test Title', Icons.title),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildTextField('Price (₹)', Icons.currency_rupee)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildTextField('Turnaround (e.g. 24h)', Icons.timer)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        isPackage ? 'Includes (comma separated tests)' : 'Includes/Description', 
                        Icons.format_list_bulleted, 
                        maxLines: 3
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
                              // TODO: Handle saving to LabCatalog with selectedImageBytes
                              Navigator.pop(context);
                            },
                            child: const Text('Save to Catalog', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.science, color: AppTheme.primaryGreen),
                title: const Text('Add Single Test', style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  _showAddTestDialog(context, false);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.medical_services, color: AppTheme.accentGreen),
                title: const Text('Add Test Package', style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  _showAddTestDialog(context, true);
                },
              ),
            ],
          ),
        );
      },
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
        title: const Text('Lab Tests Catalog'),
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
        onPressed: () => _showActionSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Add New...'),
      ),
      body: Padding(
        padding: AppTheme.defaultScreenPadding,
        child: Column(
          children: [
            const Spacer(),
            const Center(
              child: Text(
                'No Lab Tests configured yet.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

