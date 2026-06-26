import 'package:flutter/material.dart';

import '../l10n/l10n_extensions.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import 'app_text.dart';

/// A network image with loading and error fallbacks.
class AppNetworkImage extends StatelessWidget {
  /// Creates a network image widget.
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.semanticsLabel,
    this.errorMessage,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? semanticsLabel;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final radius = borderRadius ??
        BorderRadius.circular(AppDimensions.borderRadiusMd);

    return Semantics(
      label: semanticsLabel,
      image: true,
      child: ClipRRect(
        borderRadius: radius,
        child: Image.network(
          url,
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return SizedBox(
              width: width,
              height: height,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _ErrorPlaceholder(
              width: width,
              height: height,
              message: errorMessage ?? l10n.widgetImageLoadError,
            );
          },
        ),
      ),
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  const _ErrorPlaceholder({
    this.width,
    this.height,
    required this.message,
  });

  final double? width;
  final double? height;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            message,
            variant: AppTextVariant.caption,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
