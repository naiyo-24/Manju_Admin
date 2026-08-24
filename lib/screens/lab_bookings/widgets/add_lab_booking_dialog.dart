import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../themes/app_theme.dart';
import '../../../models/lab_booking.dart';
import '../../../providers/lab_booking_provider.dart';
import '../../../providers/lab_test_provider.dart';
import '../../../widgets/custom_dropdown.dart';

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
  
  // Real cart using LabTest id and properties
  List<Map<String, dynamic>> cartItems = [];
  String? _selectedTestId;

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

  void _addTestToCart(String id, String title, double price, String type) {
    if (!cartItems.any((item) => item['id'] == id)) {
      setState(() {
        cartItems.add({
          'id': id,
          'title': title,
          'price': price,
          'type': type,
        });
        _selectedTestId = null; // Reset selection
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test already added to booking.')),
      );
    }
  }

  void _removeTestFromCart(String id) {
    setState(() {
      cartItems.removeWhere((item) => item['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = cartItems.fold(0.0, (sum, item) => sum + (item['price'] as double));
    final labTestsAsync = ref.watch(labTestProvider);

    return Dialog(
      backgroundColor: AppTheme.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 750),
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
                    CustomDropdown<String>(
                      value: selectedStatus,
                      hint: '--Select Status--',
                      items: ['PENDING_CONFIRMATION', 'SAMPLE_COLLECTED', 'REPORT_READY']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s.replaceAll('_', ' '))))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => selectedStatus = val);
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    const Text('Select Lab Tests', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                    const SizedBox(height: 12),
                    
                    labTestsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Text('Error loading tests: $err', style: const TextStyle(color: Colors.red)),
                      data: (tests) {
                        if (tests.isEmpty) {
                          return const Text('No tests available in catalog.', style: TextStyle(fontStyle: FontStyle.italic));
                        }
                        
                        return Row(
                          children: [
                            Expanded(
                              child: CustomDropdown<String>(
                                value: _selectedTestId,
                                hint: '--Select Test--',
                                items: tests.map((t) => DropdownMenuItem(
                                  value: t.id,
                                  child: Text('${t.title} (₹${t.price})'),
                                )).toList(),
                                onChanged: (val) {
                                  setState(() => _selectedTestId = val);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.add_circle, color: AppTheme.primaryGreen, size: 36),
                              onPressed: _selectedTestId == null ? null : () {
                                final selectedTest = tests.firstWhere((t) => t.id == _selectedTestId);
                                _addTestToCart(selectedTest.id, selectedTest.title, selectedTest.price, selectedTest.type);
                              },
                            ),
                          ],
                        );
                      }
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
                                  Expanded(child: Text(item['title'])),
                                  Text('₹${item['price']}'),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () => _removeTestFromCart(item['id']),
                                    child: const Icon(Icons.close, color: Colors.red, size: 18),
                                  )
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
                        if (cartItems.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please add at least one test to booking.')),
                          );
                          return;
                        }

                        setState(() => _isSubmitting = true);
                        // Submit logic
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
                        
                        final nav = Navigator.of(context);
                        await ref.read(labBookingProvider.notifier).addLabBooking(booking);
                        if (mounted) nav.pop();
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

