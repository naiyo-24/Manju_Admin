import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../themes/app_theme.dart';
import '../../../models/lab_booking.dart';
import '../../../providers/lab_booking_provider.dart';

class AddLabBookingDialog extends ConsumerStatefulWidget {
  const AddLabBookingDialog({super.key});

  @override
  ConsumerState<AddLabBookingDialog> createState() => _AddLabBookingDialogState();
}

class _AddLabBookingDialogState extends ConsumerState<AddLabBookingDialog> {
  final _formKey = GlobalKey<FormState>();
  
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final notesController = TextEditingController();
  
  DateTime selectedDate = DateTime.now();
  String selectedStatus = 'PENDING_CONFIRMATION';
  bool _isSubmitting = false;
  
  // Mock cart
  List<Map<String, dynamic>> cartItems = [];

  Widget _buildTextField(String label, IconData icon, {int maxLines = 1, TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.accentGreen),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.accentGreen.withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.accentGreen.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2),
        ),
      ),
    );
  }

  void _addMockTest(String title, double price, String type) {
    setState(() {
      cartItems.add({
        'id': 'test-${DateTime.now().millisecondsSinceEpoch}',
        'title': title,
        'price': price,
        'type': type,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = cartItems.fold(0.0, (sum, item) => sum + (item['price'] as double));

    return Dialog(
      backgroundColor: AppTheme.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add Lab Booking', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen)),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    // Patient Details
                    const Text('Patient Details', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                    const SizedBox(height: 12),
                    _buildTextField('Patient Name (Optional)', Icons.person, controller: nameController),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Age (Optional)', Icons.cake, controller: ageController)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField('Gender (Optional)', Icons.people, controller: genderController)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Date
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppTheme.primaryGreen,
                                  onPrimary: Colors.white,
                                  onSurface: AppTheme.primaryGreen,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() => selectedDate = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.accentGreen.withValues(alpha: 0.5)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: AppTheme.accentGreen),
                            const SizedBox(width: 16),
                            Text(
                              'Preferred Date: ${DateFormat('MMM dd, yyyy').format(selectedDate)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Status Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        prefixIcon: const Icon(Icons.info_outline, color: AppTheme.accentGreen),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      items: ['PENDING_CONFIRMATION', 'SAMPLE_COLLECTED', 'REPORT_READY']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s.replaceAll('_', ' '))))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => selectedStatus = val);
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    const Text('Simulate Cart Items', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ActionChip(
                          label: const Text('Add CBC (₹500)'),
                          onPressed: () => _addMockTest('Complete Blood Count', 500, 'SINGLE_TEST'),
                        ),
                        ActionChip(
                          label: const Text('Add Lipid (₹800)'),
                          onPressed: () => _addMockTest('Lipid Profile', 800, 'PACKAGE'),
                        ),
                        ActionChip(
                          label: const Text('Add Urine (₹200)'),
                          onPressed: () => _addMockTest('Urine Routine', 200, 'SINGLE_TEST'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    if (cartItems.isEmpty)
                      const Text('Cart is empty', style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic))
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...cartItems.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['title']),
                                  Text('₹${item['price']}'),
                                ],
                              ),
                            )),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('₹$totalAmount', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                    const SizedBox(height: 16),
                    _buildTextField('Additional Notes (Optional)', Icons.description, maxLines: 3, controller: notesController),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      onPressed: _isSubmitting ? null : () async {
                        setState(() => _isSubmitting = true);
                        // Submit logic (mock)
                        final booking = LabBooking(
                          id: '', // generated in notifier
                          userId: 'admin-mock-user',
                          paymentMethod: 'COD',
                          bookedItems: cartItems,
                          status: selectedStatus,
                          totalAmount: totalAmount,
                          preferredDate: selectedDate,
                          createdAt: DateTime.now(),
                          formDetails: {
                            'patient_name': nameController.text,
                            'age': ageController.text,
                            'gender': genderController.text,
                            'notes': notesController.text,
                          },
                        );
                        
                        await ref.read(labBookingProvider.notifier).addLabBooking(booking);
                        if (mounted) Navigator.pop(context);
                      },
                      child: const Text('Create Lab Booking', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
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
