import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String hint;
  final Function(T?) onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    this.hint = '--Select--',
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: AppTheme.shadowInsetDark, offset: Offset(3, 3), blurRadius: 6, spreadRadius: -2),
          BoxShadow(color: Colors.white, offset: Offset(-3, -3), blurRadius: 6, spreadRadius: 1),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.primaryGreen, size: 28),
          dropdownColor: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          elevation: 8,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w500),
          hint: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(hint, style: const TextStyle(color: AppTheme.textSecondary)),
          ),
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
