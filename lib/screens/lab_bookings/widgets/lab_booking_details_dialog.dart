import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../../../themes/app_theme.dart';
import '../../../models/lab_booking.dart';
import '../../../providers/lab_booking_provider.dart';

class LabBookingDetailsDialog extends ConsumerStatefulWidget {
  final LabBooking booking;

  const LabBookingDetailsDialog({
    super.key,
    required this.booking,
  });

  @override
  ConsumerState<LabBookingDetailsDialog> createState() => _LabBookingDetailsDialogState();
}

class _LabBookingDetailsDialogState extends ConsumerState<LabBookingDetailsDialog> {
  late String selectedStatus;
  Uint8List? fileBytes;
  String? fileName;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.booking.status.toUpperCase();
  }

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
  Widget build(BuildContext context) {
    final patientName = (widget.booking.formDetails?['patient_name']?.toString().isNotEmpty ?? false) 
        ? widget.booking.formDetails!['patient_name']
        : 'Not Specified';
    final age = (widget.booking.formDetails?['age']?.toString().isNotEmpty ?? false)
        ? widget.booking.formDetails!['age']
        : 'N/A';
    final gender = (widget.booking.formDetails?['gender']?.toString().isNotEmpty ?? false)
        ? widget.booking.formDetails!['gender']
        : 'N/A';
    final notes = (widget.booking.formDetails?['notes']?.toString().isNotEmpty ?? false)
        ? widget.booking.formDetails!['notes']
        : 'None';
    
    return Dialog(
      backgroundColor: AppTheme.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 750),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Lab Booking Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.accentGreen.withValues(alpha: 0.3)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedStatus,
                      icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primaryGreen),
                      items: ['PENDING_CONFIRMATION', 'SAMPLE_COLLECTED', 'REPORT_READY']
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(
                                  s.replaceAll('_', ' '),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen, fontSize: 12),
                                ),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            selectedStatus = val;
                          });
                          ref.read(labBookingProvider.notifier).updateLabBooking(
                                widget.booking.copyWith(status: val),
                              );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            Expanded(
              child: ListView(
                children: [
                  _buildInfoRow(Icons.calendar_today, 'Date', DateFormat('MMM dd, yyyy').format(widget.booking.preferredDate)),
                  const SizedBox(height: 16),
                  
                  const Text('Patient Info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryGreen)),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.personal_injury, 'Patient', patientName),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.cake, 'Age/Gender', '$age / $gender'),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.description, 'Notes', notes),

                  const SizedBox(height: 24),
                  const Text('Cart Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryGreen)),
                  const SizedBox(height: 12),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.accentGreen.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      children: [
                        ...widget.booking.bookedItems.map((item) {
                          return ListTile(
                            leading: Icon(
                              item['type'] == 'PACKAGE' ? Icons.medical_services : Icons.science,
                              color: AppTheme.accentGreen,
                            ),
                            title: Text(item['title'] ?? 'Unknown Test', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(item['type'] ?? ''),
                            trailing: Text('₹${item['price']}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen, fontSize: 16)),
                          );
                        }),
                        const Divider(height: 1),
                        ListTile(
                          title: const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Text('₹${widget.booking.totalAmount}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen, fontSize: 18)),
                        )
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Report Upload File Picker
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
                          selectedStatus = 'REPORT_READY';
                        });
                        
                        // Automatically update backend
                        ref.read(labBookingProvider.notifier).updateLabBooking(
                          widget.booking.copyWith(
                            status: 'REPORT_READY',
                            reportFileName: fileName,
                            reportBytes: fileBytes,
                          ),
                        );
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
                              fileName ?? widget.booking.reportFileName ?? 'Upload Lab Report (PDF/Image)',
                              style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (fileName != null || widget.booking.reportFileName != null)
                            IconButton(
                              icon: const Icon(Icons.close, color: AppTheme.pricePink),
                              onPressed: () {
                                setState(() {
                                  fileBytes = null;
                                  fileName = null;
                                });
                                ref.read(labBookingProvider.notifier).updateLabBooking(
                                  widget.booking.copyWith(
                                    status: 'PENDING_CONFIRMATION', // fallback
                                    reportFileName: null,
                                    reportBytes: null,
                                  ),
                                );
                              },
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
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
                          title: const Text('Delete Booking?', style: TextStyle(color: AppTheme.primaryGreen)),
                          content: const Text('Are you sure you want to delete this lab booking?'),
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
                                ref.read(labBookingProvider.notifier).deleteLabBooking(widget.booking.id);
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
