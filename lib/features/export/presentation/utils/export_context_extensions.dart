import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../domain/entities/export_error_code.dart';
import '../../domain/repository/export_repository.dart';
import 'export_localization.dart';

extension ExportErrorContext on BuildContext {
  String exportErrorMessage(ExportErrorCode code) => code.message(l10n);
}

extension ExportDataTypeContext on BuildContext {
  String exportDataTypeLabel(ExportDataType dataType) => dataType.label(l10n);

  String exportDataTypeDescription(ExportDataType dataType) =>
      dataType.description(l10n);
}

extension ExportFormatContext on BuildContext {
  String exportFormatLabel(ExportFormat format) => format.label(l10n);
}
