import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../themes/app_theme.dart';
import '../../../models/lab_test.dart';
import '../../../providers/lab_test_provider.dart';

class AddLabTestDialog extends ConsumerStatefulWidget {
  final bool isPackage;
  final LabTest? existingTest;
  
  const AddLabTestDialog({
    super.key,
    required this.isPackage,
    this.existingTest,
  });

  @override
  ConsumerState<AddLabTestDialog> createState() => _AddLabTestDialogState();
}

class _AddLabTestDialogState extends ConsumerState<AddLabTestDialog> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _turnaroundController = TextEditingController();
  
  final List<String> _includes = [];
  final _includeItemController = TextEditingController();
  
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingTest != null) {
      _titleController.text = widget.existingTest!.title;
      _priceController.text = widget.existingTest!.price.toString();
      _turnaroundController.text = widget.existingTest!.turnaroundTime;
      _includes.addAll(widget.existingTest!.includes);
    }
  }

  void _addIncludeItem() {
    final text = _includeItemController.text.trim();
    if (text.isNotEmpty && !_includes.contains(text)) {
      setState(() {
        _includes.add(text);
        _includeItemController.clear();
      });
    }
  }

  void _removeIncludeItem(String item) {
    setState(() {
      _includes.remove(item);
    });
  }

  Widget _buildTextField(String hint, IconData icon, {
    TextEditingController? controller, 
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: AppTheme.shadowInsetDark, offset: Offset(3, 3), blurRadius: 6, spreadRadius: -2),
          BoxShadow(color: Colors.white, offset: Offset(-3, -3), blurRadius: 6, spreadRadius: 1),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Icon(icon, color: AppTheme.primaryGreen.withValues(alpha: 0.8), size: 22),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 48),
          hintText: hint,
          hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.6), fontWeight: FontWeight.normal),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(left: 0, right: 16, top: 20, bottom: 20),
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
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 750),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
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
                      gradient: LinearGradient(
                        colors: widget.isPackage 
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
                    child: Icon(widget.isPackage ? Icons.medical_services : Icons.science, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.existingTest != null
                              ? (widget.isPackage ? 'Edit Test Package' : 'Edit Single Test')
                              : (widget.isPackage ? 'Add Test Package' : 'Add Single Test'),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen, letterSpacing: -0.5),
                        ),
                        Text(
                          widget.existingTest != null
                              ? 'Modify the details of your lab test.'
                              : (widget.isPackage ? 'Create a bundle of multiple lab tests.' : 'Add a new individual lab test.'),
                          style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              Expanded(
                child: ListView(
                  children: [
                    _buildTextField(
                      widget.isPackage ? 'Package Title' : 'Test Title', 
                      Icons.title,
                      controller: _titleController,
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'Price (₹)', 
                            Icons.currency_rupee,
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            validator: (val) => val == null || val.isEmpty || double.tryParse(val) == null ? 'Invalid price' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            'Turnaround (e.g. 24h)', 
                            Icons.timer,
                            controller: _turnaroundController,
                            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    const Text('Includes (Sub-tests)', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                    const SizedBox(height: 8),
                    
                    // Dynamic List Input
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _includeItemController,
                            decoration: InputDecoration(
                              hintText: 'Enter test name (e.g. RBC)',
                              isDense: true,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onSubmitted: (_) => _addIncludeItem(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: AppTheme.primaryGreen),
                          onPressed: _addIncludeItem,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    if (_includes.isEmpty)
                      const Text('No items added.', style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic))
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _includes.map((item) => Chip(
                          label: Text(item),
                          deleteIcon: const Icon(Icons.cancel, size: 18),
                          onDeleted: () => _removeIncludeItem(item),
                          backgroundColor: AppTheme.accentGreen.withValues(alpha: 0.2),
                        )).toList(),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
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
                    onPressed: _isSubmitting ? null : () async {
                      if (_formKey.currentState!.validate()) {
                        if (_includes.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please add at least one included test.')),
                          );
                          return;
                        }
                        
                        setState(() => _isSubmitting = true);
                        
                        final test = LabTest(
                          id: widget.existingTest?.id ?? '',
                          type: widget.existingTest?.type ?? (widget.isPackage ? 'PACKAGE' : 'SINGLE_TEST'),
                          title: _titleController.text.trim(),
                          price: double.parse(_priceController.text.trim()),
                          turnaroundTime: _turnaroundController.text.trim(),
                          includes: _includes,
                        );
                        
                        final nav = Navigator.of(context);
                        if (widget.existingTest != null) {
                          await ref.read(labTestProvider.notifier).updateLabTest(test);
                        } else {
                          await ref.read(labTestProvider.notifier).addLabTest(test);
                        }
                        
                        if (mounted) nav.pop();
                      }
                    },
                    child: Text(widget.existingTest != null ? 'Update Catalog' : 'Save to Catalog', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
