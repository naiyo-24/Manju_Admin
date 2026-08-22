import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final double padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.padding = 16.0,
    this.borderRadius = 16.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowDark,
              offset: const Offset(4, 4),
              blurRadius: 10,
              spreadRadius: 1,
            ),
            const BoxShadow(
              color: AppTheme.shadowLight,
              offset: Offset(-4, -4),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
