import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import '../../themes/app_theme.dart';
import '../../models/lab_test.dart';
import '../../providers/lab_test_provider.dart';
import 'widgets/add_lab_test_dialog.dart';

class LabTestsScreen extends ConsumerWidget {
  const LabTestsScreen({super.key});

  void _showAddTestDialog(BuildContext context, bool isPackage) {
    showDialog(
      context: context,
      builder: (context) => AddLabTestDialog(isPackage: isPackage),
    );
  }

  Future<void> _handleBulkImport(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result.isNotEmpty) {
        final bytes = await result.first.readAsBytes();
        if (bytes.isEmpty) {
          if (context.mounted) {
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to read file')));
          }
          return;
        }

        final csvString = utf8.decode(bytes);
        final List<List<dynamic>> csvTable = Csv().decode(csvString);

        if (csvTable.isEmpty || csvTable.length == 1) {
          if (context.mounted) {
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CSV file is empty or missing data')));
          }
          return;
        }

        int addedCount = 0;
        final notifier = ref.read(labTestProvider.notifier);

        for (int i = 1; i < csvTable.length; i++) {
          final row = csvTable[i];
          if (row.length >= 3) {
            final title = row[0].toString();
            final price = double.tryParse(row[1].toString()) ?? 0.0;
            final turnaround = row[2].toString();
            final type = row.length > 3 ? row[3].toString().toUpperCase() : 'SINGLE_TEST';
            
            List<String> includes = [];
            if (row.length > 4 && row[4].toString().isNotEmpty) {
               includes = row[4].toString().split(';').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
            }

            final test = LabTest(
              id: '',
              type: type == 'PACKAGE' ? 'PACKAGE' : 'SINGLE_TEST',
              title: title,
              price: price,
              turnaroundTime: turnaround,
              includes: includes,
            );
            
            await notifier.addLabTest(test);
            addedCount++;
          }
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Successfully imported $addedCount lab tests')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error importing CSV: $e')),
        );
      }
    }
  }

  void _showActionSheet(BuildContext context, WidgetRef ref) {
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
              const Divider(),
              ListTile(
                leading: const Icon(Icons.upload_file, color: Colors.blue),
                title: const Text('Bulk Import (CSV)', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Columns: Title, Price, Turnaround, Type (PACKAGE/SINGLE), Includes (use ; separator)'),
                onTap: () {
                  Navigator.pop(context);
                  _handleBulkImport(context, ref);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labTestsAsync = ref.watch(labTestProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Tests Catalog'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.primaryGreen,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        onPressed: () => _showActionSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add New...'),
      ),
      body: Padding(
        padding: AppTheme.defaultScreenPadding,
        child: labTestsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (tests) {
            if (tests.isEmpty) {
              return const Center(
                child: Text(
                  'No Lab Tests configured yet.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textSecondary,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: tests.length,
              itemBuilder: (context, index) {
                final test = tests[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    elevation: 4,
                    shadowColor: AppTheme.shadowInsetDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: test.type == 'PACKAGE' ? AppTheme.pricePink.withValues(alpha: 0.1) : AppTheme.accentGreen.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          test.type == 'PACKAGE' ? Icons.medical_services : Icons.science, 
                          color: test.type == 'PACKAGE' ? AppTheme.pricePink : AppTheme.primaryGreen,
                        ),
                      ),
                      title: Text(test.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('₹${test.price} • Turnaround: ${test.turnaroundTime}', style: const TextStyle(color: AppTheme.textSecondary)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: test.includes.map((inc) => Chip(
                              label: Text(inc, style: const TextStyle(fontSize: 12)),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            )).toList(),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: AppTheme.accentGreen),
                            onPressed: () {
                              // TODO: Implement Edit Dialog
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: AppTheme.backgroundColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  title: const Text('Delete Lab Test', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                                  content: Text('Are you sure you want to delete ${test.title}? This action cannot be undone.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ref.read(labTestProvider.notifier).deleteLabTest(test.id);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

