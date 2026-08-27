import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../themes/app_theme.dart';

class NeumorphicLoader extends StatelessWidget {
  final int count;
  final bool isGrid;

  const NeumorphicLoader({
    super.key,
    this.count = 3,
    this.isGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return GridView.count(
            crossAxisCount: isWide ? 3 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isWide ? 3.0 : 1.4,
            children: List.generate(count, (index) => _buildShimmerCard()),
          );
        }
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildShimmerCard(),
        );
      },
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppTheme.shadowInsetDark, offset: Offset(4, 4), blurRadius: 10, spreadRadius: -2),
          BoxShadow(color: Colors.white, offset: Offset(-4, -4), blurRadius: 10, spreadRadius: 1),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: AppTheme.textSecondary.withValues(alpha: 0.1),
        highlightColor: AppTheme.textSecondary.withValues(alpha: 0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
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
