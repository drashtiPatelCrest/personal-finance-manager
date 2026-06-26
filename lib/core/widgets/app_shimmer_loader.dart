import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

/// A shimmer loading placeholder for content skeletons.
class AppShimmerLoader extends StatefulWidget {
  /// Creates a shimmer loader.
  const AppShimmerLoader({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<AppShimmerLoader> createState() => _AppShimmerLoaderState();
}

class _AppShimmerLoaderState extends State<AppShimmerLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = widget.borderRadius ??
        BorderRadius.circular(AppDimensions.borderRadiusSm);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment(-1 + (_controller.value * 2), 0),
              end: Alignment(1 + (_controller.value * 2), 0),
              colors: [
                AppColors.shimmerBase(colorScheme),
                AppColors.shimmerHighlight(colorScheme),
                AppColors.shimmerBase(colorScheme),
              ],
              stops: const [0.1, 0.5, 0.9],
            ),
          ),
        );
      },
    );
  }
}
