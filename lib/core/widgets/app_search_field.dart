import 'package:flutter/material.dart';

import '../l10n/l10n_extensions.dart';
import 'app_text_field.dart';

/// A search input field with a search icon and clear action.
class AppSearchField extends StatefulWidget {
  /// Creates a search field.
  const AppSearchField({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.enabled = true,
    this.semanticsLabel,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final bool enabled;
  final String? semanticsLabel;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final placeholder = widget.placeholder ?? l10n.widgetSearchPlaceholder;

    return AppTextField(
      controller: _controller,
      focusNode: widget.focusNode,
      hint: placeholder,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      semanticsLabel: widget.semanticsLabel ?? placeholder,
      prefixIcon: const Icon(Icons.search),
      suffixIcon: !_hasText
          ? null
          : IconButton(
              onPressed: () {
                _controller.clear();
                widget.onChanged?.call('');
                widget.onClear?.call();
              },
              tooltip: l10n.widgetActionClose,
              icon: const Icon(Icons.clear),
            ),
      textInputAction: TextInputAction.search,
    );
  }
}
