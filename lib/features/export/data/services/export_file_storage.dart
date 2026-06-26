import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

@lazySingleton
class ExportFileStorage {
  Future<Directory> getExportsDirectory() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final exportsDirectory = Directory(
      p.join(documentsDirectory.path, 'exports'),
    );
    if (!exportsDirectory.existsSync()) {
      exportsDirectory.createSync(recursive: true);
    }
    return exportsDirectory;
  }

  Future<String> writeFile({
    required String fileName,
    required List<int> bytes,
  }) async {
    final exportsDirectory = await getExportsDirectory();
    final file = File(p.join(exportsDirectory.path, fileName));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }
}
