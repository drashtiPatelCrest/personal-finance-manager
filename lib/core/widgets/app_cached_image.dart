import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n_extensions.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import 'app_text.dart';

/// A cached network image with placeholder and error states.
class AppCachedImage extends StatelessWidget {
  /// Creates a cached network image widget.
  const AppCachedImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.semanticsLabel,
    this.errorMessage,
    this.placeholder,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? semanticsLabel;
  final String? errorMessage;
  final Widget? placeholder;

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
        child: CachedNetworkImage(
          imageUrl: url,
          width: width,
          height: height,
          fit: fit,
          placeholder: (context, url) =>
              placeholder ??
              SizedBox(
                width: width,
                height: height,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          errorWidget: (context, url, error) => _ErrorPlaceholder(
            width: width,
            height: height,
            message: errorMessage ?? l10n.widgetImageLoadError,
          ),
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
