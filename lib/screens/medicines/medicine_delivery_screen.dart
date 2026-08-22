import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import '../../widgets/admin_stat_card.dart';
import '../../widgets/neumorphic_card.dart';

class MedicineDeliveryScreen extends StatelessWidget {
  const MedicineDeliveryScreen({super.key});

  void _showAddMedicineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Add New Medicine'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Medicine Name', Icons.medication),
              const SizedBox(height: 16),
              _buildTextField('Quantity', Icons.production_quantity_limits),
              const SizedBox(height: 16),
              _buildTextField('Price (₹)', Icons.currency_rupee),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
            ),
            ElevatedButton(
              style: AppTheme.primaryButtonStyle,
              onPressed: () {
                // TODO: Handle saving the medicine
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppTheme.shadowInsetDark, offset: Offset(2, 2), blurRadius: 4),
          BoxShadow(color: AppTheme.shadowLight, offset: Offset(-2, -2), blurRadius: 4),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppTheme.primaryGreen),
          hintText: hint,
          hintStyle: const TextStyle(color: AppTheme.textHint),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Delivery'),
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
        onPressed: () => _showAddMedicineDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Medicine'),
      ),
      body: Padding(
        padding: AppTheme.defaultScreenPadding,
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(child: AdminStatCard(title: 'Pending', value: '12', icon: Icons.local_shipping, iconColor: AppTheme.pricePink)),
                SizedBox(width: 16),
                Expanded(child: AdminStatCard(title: 'Completed', value: '34', icon: Icons.check_circle, iconColor: AppTheme.accentGreen)),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Active Orders', style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: NeumorphicCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Order #MMD-00${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const Text('10 mins ago', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text('Paracetamol 500mg, Cough Syrup x2'),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('₹ 450.00', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.pricePink)),
                              ElevatedButton(
                                style: AppTheme.primaryButtonStyle.copyWith(
                                  padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                                ),
                                onPressed: () {},
                                child: const Text('Dispatch', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          )
                        ],
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

