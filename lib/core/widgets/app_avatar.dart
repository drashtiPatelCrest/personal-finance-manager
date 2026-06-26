import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';

/// A theme-aware avatar with image, icon, or initials fallback.
class AppAvatar extends StatelessWidget {
  /// Creates an application avatar.
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.icon,
    this.size = AppDimensions.avatarSizeMd,
    this.backgroundColor,
    this.foregroundColor,
    this.semanticsLabel,
  });

  final String? imageUrl;
  final String? initials;
  final IconData? icon;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? colorScheme.primaryContainer;
    final fg = foregroundColor ?? colorScheme.onPrimaryContainer;

    Widget child;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      child = CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: bg,
      );
    } else if (initials != null && initials!.isNotEmpty) {
      child = CircleAvatar(
        radius: size / 2,
        backgroundColor: bg,
        foregroundColor: fg,
        child: Text(
          initials!,
          style: TextStyle(
            fontSize: size * 0.36,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      child = CircleAvatar(
        radius: size / 2,
        backgroundColor: bg,
        foregroundColor: fg,
        child: Icon(
          icon ?? Icons.person_outline,
          size: size * 0.5,
        ),
      );
    }

    return Semantics(
      label: semanticsLabel ?? initials,
      image: imageUrl != null,
      child: child,
    );
  }
}
